-- tmux_send: send visual selection to any tmux pane (Cursor's Cmd-L for tmux + nvim).
--
-- Default keymaps (visual mode):
--   <leader>l  send to the last-used pane (zoxide-style memory); on first
--              use, or when the cached pane is gone, pops tmux's native
--              display-panes overlay so you pick by typing the pane number.
--   <leader>L  force the picker regardless of cache.
--
-- Mechanics: yank → pbcopy → tmux switch-client to target → osascript
-- triggers Cmd+V on the active app (Ghostty), which then runs its own
-- bracketed paste into the focused pane. We piggyback on Ghostty's working
-- paste pipeline instead of recreating it through tmux primitives —
-- bracketed-paste markers emitted via tmux get intercepted by tmux's own
-- paste-mode tracking and never reach the receiver. Cmd+V bypasses that.
--
-- Platform: macOS-only (uses pbcopy + osascript). Linux support would need
-- xclip/wl-copy + xdotool/ydotool.

local M = {}

local config = {
  scope = "window", -- "window" | "session" — cache key granularity
  focus = "follow", -- "follow" | "stay"   — focus moves to target / bounces back
  keymap_send = "<leader>l",
  keymap_pick = "<leader>L",
  paste_settle_ms = 150,         -- delay before bouncing focus back, lets paste pipeline complete
  poll_interval_ms = 100,
  poll_timeout_iters = 300,      -- 30s at 100ms cadence
  reset_on_layout_change = true, -- invalidate cached pane when window layout shifts
}

local function cache_path()
  local fmt = config.scope == "session" and "#{session_name}" or "#{window_id}"
  local key = vim.fn.trim(vim.fn.system({ "tmux", "display-message", "-p", fmt }))
  key = key:gsub("[^%w@%-_.]", "_")
  return vim.fn.stdpath("cache") .. "/tmux_send." .. config.scope .. "." .. key
end

-- Fingerprint the current window's panes. Add/remove invalidates the cache,
-- but pure resizes don't — resizing is a frequent mid-task action and
-- shouldn't force the user back through the picker.
local function layout_signature()
  local ids = vim.fn.systemlist({ "tmux", "list-panes", "-F", "#{pane_id}" })
  table.sort(ids)
  return table.concat(ids, ",")
end

local function pane_alive(pane_id)
  if not pane_id or pane_id == "" then return false end
  vim.fn.system({ "tmux", "display-message", "-p", "-t", pane_id, "#{pane_id}" })
  return vim.v.shell_error == 0
end

local function trigger_cmd_v()
  vim.fn.system({ "osascript", "-e",
    'tell application "System Events" to keystroke "v" using command down' })
end

local function calling_client()
  local session = vim.fn.trim(vim.fn.system({
    "tmux", "display-message", "-p", "#{session_name}"
  }))
  local clients = vim.fn.systemlist({
    "tmux", "list-clients", "-t", session, "-F", "#{client_name}"
  })
  return clients[1]
end

local function pick_pane()
  -- Resolve the client to display the picker on. With multiple Ghostty
  -- windows / tmux clients, display-panes can't auto-pick the right one
  -- when invoked from a subprocess.
  local client = calling_client()
  if not client or client == "" then
    vim.notify("tmux_send: no client attached", vim.log.levels.ERROR)
    return nil
  end

  vim.fn.system({ "tmux", "set-environment", "-g", "NVIM_SEND_PICK", "" })
  -- Only ONE %% in the template — tmux substitutes only the first occurrence
  -- per `man tmux`. We capture the pane id via env var, then drive the rest
  -- from Lua where multi-step logic isn't constrained by the template DSL.
  local out = vim.fn.system({
    "tmux", "display-panes", "-t", client, "-d", "0",
    "set-environment -g NVIM_SEND_PICK %%"
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("tmux_send: display-panes failed: " .. out, vim.log.levels.ERROR)
    return nil
  end

  for _ = 1, config.poll_timeout_iters do
    local env = vim.fn.system({ "tmux", "show-environment", "-g", "NVIM_SEND_PICK" })
    local pane = env:match("NVIM_SEND_PICK=(%%%w+)")
    if pane then return pane end
    vim.cmd("sleep " .. config.poll_interval_ms .. "m")
  end
  vim.notify("tmux_send: pick timed out", vim.log.levels.WARN)
  return nil
end

local function send(force_pick)
  return function()
    vim.cmd('noau normal! "vy')
    local text = vim.fn.getreg('v')
    if text == "" then return end

    vim.fn.system({ "pbcopy" }, text)

    local marker = cache_path()
    local target
    if not force_pick and vim.fn.filereadable(marker) == 1 then
      local cached = vim.fn.readfile(marker)
      local cached_pane = cached[1] or ""
      local cached_sig = cached[2] or ""
      local layout_ok = not config.reset_on_layout_change
          or cached_sig == layout_signature()
      if pane_alive(cached_pane) and layout_ok then target = cached_pane end
    end
    if not target then
      target = pick_pane()
      if not target then return end
      vim.fn.writefile({ target, layout_signature() }, marker)
    end

    -- Get calling client and (optionally) capture origin pane for stay-mode.
    local client = calling_client()
    local origin
    if config.focus == "stay" then
      origin = vim.fn.trim(vim.fn.system({
        "tmux", "display-message", "-p", "#{pane_id}"
      }))
    end

    -- switch-client handles all three cross-* cases atomically: same window,
    -- cross-window, cross-session (walks up from pane to find session+window).
    if client and client ~= "" then
      vim.fn.system({ "tmux", "switch-client", "-c", client, "-t", target })
    else
      vim.fn.system({ "tmux", "select-window", "-t", target })
      vim.fn.system({ "tmux", "select-pane", "-t", target })
    end

    trigger_cmd_v()

    -- Restore focus *after* the paste pipeline (Ghostty → tmux → target)
    -- has time to deliver the bytes. Switching tmux's active pane mid-paste
    -- would route the tail of the bracketed sequence to the wrong pane.
    if origin and client and client ~= "" then
      vim.defer_fn(function()
        vim.fn.system({ "tmux", "switch-client", "-c", client, "-t", origin })
      end, config.paste_settle_ms)
    end
  end
end

function M.setup(opts)
  opts = opts or {}
  for k, v in pairs(opts) do config[k] = v end

  if config.keymap_send then
    vim.keymap.set("x", config.keymap_send, send(false),
      { desc = "tmux_send: send selection to last pane" })
  end
  if config.keymap_pick then
    vim.keymap.set("x", config.keymap_pick, send(true),
      { desc = "tmux_send: send selection (force pane pick)" })
  end
end

-- Expose the action functions for users who want to bind their own keys.
M.send_to_last = send(false)
M.send_with_pick = send(true)

return M
