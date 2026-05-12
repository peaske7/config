vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

local strike = "~~"

local function toggle_strikethrough_text(text)
  local leading, body, trailing = text:match("^(%s*)(.-)(%s*)$")
  if body == "" then return text end

  if body:sub(1, #strike) == strike and body:sub(-#strike) == strike then
    return leading .. body:sub(#strike + 1, -#strike - 1) .. trailing
  end

  return leading .. strike .. body .. strike .. trailing
end

local function split_task_line(line)
  for _, pattern in ipairs({
    "^(%s*>?%s*[-*+]%s+%[[^%]]%]%s+)(.*)$",
    "^(%s*>?%s*%d+[.)]%s+%[[^%]]%]%s+)(.*)$",
    "^(%s*>?%s*[-*+]%s+)(.+)$",
    "^(%s*>?%s*%d+[.)]%s+)(.+)$",
  }) do
    local prefix, body = line:match(pattern)
    if prefix then return prefix, body end
  end
end

local function toggle_line_strikethrough(lnum)
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
  if not line then return end

  local prefix, body = split_task_line(line)
  local next_line = prefix and (prefix .. toggle_strikethrough_text(body))
    or toggle_strikethrough_text(line)

  if next_line ~= line then
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { next_line })
  end
end

local function toggle_visual_strikethrough()
  local mode = vim.fn.mode()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getcurpos()
  local start_row, start_col = start_pos[2], start_pos[3]
  local end_row, end_col = end_pos[2], end_pos[3]

  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  if mode == "V" or mode == "\22" then
    for lnum = start_row, end_row do
      toggle_line_strikethrough(lnum)
    end
    return
  end

  local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
  local text = table.concat(lines, "\n")
  local replacement = vim.split(toggle_strikethrough_text(text), "\n", { plain = true })
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, replacement)
end

vim.keymap.set("n", "<leader>ox", function()
  toggle_line_strikethrough(vim.fn.line("."))
end, { buffer = true, desc = "[o]bsidian toggle strikethrough" })

vim.keymap.set("x", "<leader>ox", toggle_visual_strikethrough, {
  buffer = true,
  desc = "[o]bsidian toggle strikethrough selection",
})
