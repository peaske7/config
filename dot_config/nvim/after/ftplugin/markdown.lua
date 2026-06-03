vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

local highlight_color = "#FFF3A3A6"
local wrappers = {
  highlight = {
    prefix = ('<mark style="background: %s;">'):format(highlight_color),
    suffix = "</mark>",
  },
  strikethrough = {
    prefix = "~~",
    suffix = "~~",
  },
}

local function toggle_wrapped_text(text, wrapper)
  local leading, body, trailing = text:match("^(%s*)(.-)(%s*)$")
  if body == "" then return text end

  if body:sub(1, #wrapper.prefix) == wrapper.prefix and body:sub(-#wrapper.suffix) == wrapper.suffix then
    return leading .. body:sub(#wrapper.prefix + 1, -#wrapper.suffix - 1) .. trailing
  end

  return leading .. wrapper.prefix .. body .. wrapper.suffix .. trailing
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

local function end_byte_col_for_char(lnum, one_indexed_byte_col)
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
  local zero_indexed_byte_col = math.max(one_indexed_byte_col - 1, 0)

  if zero_indexed_byte_col >= #line then return #line end

  local char_index = vim.str_utfindex(line, zero_indexed_byte_col)
  return vim.str_byteindex(line, char_index + 1)
end

local function surrounding_wrapper_range(start_row, start_byte_col, end_row, end_byte_col, wrapper)
  local start_line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1] or ""
  local end_line = vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, false)[1] or ""
  local prefix_start_col = start_byte_col - #wrapper.prefix
  local suffix_end_col = end_byte_col + #wrapper.suffix

  if prefix_start_col < 0 or suffix_end_col > #end_line then return end

  local prefix = start_line:sub(prefix_start_col + 1, start_byte_col)
  local suffix = end_line:sub(end_byte_col + 1, suffix_end_col)

  if prefix == wrapper.prefix and suffix == wrapper.suffix then
    return prefix_start_col, suffix_end_col
  end
end

local function toggle_line_wrapped(lnum, wrapper)
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
  if not line then return end

  local prefix, body = split_task_line(line)
  local next_line = prefix and (prefix .. toggle_wrapped_text(body, wrapper))
    or toggle_wrapped_text(line, wrapper)

  if next_line ~= line then
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { next_line })
  end
end

local function toggle_visual_wrapped(wrapper)
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
      toggle_line_wrapped(lnum, wrapper)
    end
    return
  end

  local start_byte_col = start_col - 1
  local end_byte_col = end_byte_col_for_char(end_row, end_col)
  local selected_lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_byte_col, end_row - 1, end_byte_col, {})
  local prefix_start_col, suffix_end_col = surrounding_wrapper_range(start_row, start_byte_col, end_row, end_byte_col, wrapper)

  if prefix_start_col then
    vim.api.nvim_buf_set_text(0, start_row - 1, prefix_start_col, end_row - 1, suffix_end_col, selected_lines)
    return
  end

  local text = table.concat(selected_lines, "\n")
  local replacement = vim.split(wrapper.prefix .. text .. wrapper.suffix, "\n", { plain = true })
  vim.api.nvim_buf_set_text(0, start_row - 1, start_byte_col, end_row - 1, end_byte_col, replacement)
end

local mark_namespace = vim.api.nvim_create_namespace("obsidian_mark_highlights")

local function readable_foreground(hex_color)
  local r = tonumber(hex_color:sub(2, 3), 16) or 0
  local g = tonumber(hex_color:sub(4, 5), 16) or 0
  local b = tonumber(hex_color:sub(6, 7), 16) or 0
  local brightness = (r * 299 + g * 587 + b * 114) / 1000
  return brightness > 150 and "#1f1f28" or "#dcd7ba"
end

local function normal_background()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
  if not normal.bg then return "#1f1f28" end

  return ("#%06x"):format(normal.bg)
end

local function highlight_group_for_color(mark_color)
  local bg = mark_color:sub(1, 7)
  local group = "ObsidianMarkdownHighlight" .. bg:gsub("#", "")

  vim.api.nvim_set_hl(0, group, {
    bg = bg,
    fg = readable_foreground(bg),
  })

  return group
end

local function set_mark_tag_highlight()
  vim.api.nvim_set_hl(0, "ObsidianMarkdownHighlightTag", {
    fg = "#565a6e",
    bg = normal_background(),
  })
end

local function render_mark_highlights()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(buf, mark_namespace, 0, -1)

  for row, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    local search_start = 1

    while true do
      local open_start, open_end, mark_color = line:find('<mark style="background:%s*(#[%x]+)%s*;%s*">', search_start)
      if not open_start then break end

      local close_start, close_end = line:find("</mark>", open_end + 1, true)
      if not close_start then break end

      local row_index = row - 1
      local open_start_col = open_start - 1
      local content_start_col = open_end
      local content_end_col = close_start - 1
      local close_end_col = close_end

      vim.api.nvim_buf_set_extmark(buf, mark_namespace, row_index, open_start_col, {
        end_col = content_start_col,
        hl_group = "ObsidianMarkdownHighlightTag",
        priority = 10000,
      })
      vim.api.nvim_buf_set_extmark(buf, mark_namespace, row_index, content_start_col, {
        end_col = content_end_col,
        hl_group = highlight_group_for_color(mark_color),
        priority = 10001,
      })
      vim.api.nvim_buf_set_extmark(buf, mark_namespace, row_index, content_end_col, {
        end_col = close_end_col,
        hl_group = "ObsidianMarkdownHighlightTag",
        priority = 10000,
      })

      search_start = close_end + 1
    end
  end
end

set_mark_tag_highlight()

local group = vim.api.nvim_create_augroup("ObsidianMarkdownHighlights" .. vim.api.nvim_get_current_buf(), { clear = true })
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP", "BufEnter", "InsertLeave" }, {
  buffer = 0,
  group = group,
  callback = render_mark_highlights,
})
render_mark_highlights()

vim.keymap.set("n", "<leader>oh", function()
  toggle_line_wrapped(vim.fn.line("."), wrappers.highlight)
  render_mark_highlights()
end, { buffer = true, desc = "[o]bsidian toggle highlight" })

vim.keymap.set("x", "<leader>oh", function()
  toggle_visual_wrapped(wrappers.highlight)
  render_mark_highlights()
end, {
  buffer = true,
  desc = "[o]bsidian toggle highlight selection",
})

vim.keymap.set("n", "<leader>ox", function()
  toggle_line_wrapped(vim.fn.line("."), wrappers.strikethrough)
  render_mark_highlights()
end, { buffer = true, desc = "[o]bsidian toggle strikethrough" })

vim.keymap.set("x", "<leader>ox", function()
  toggle_visual_wrapped(wrappers.strikethrough)
  render_mark_highlights()
end, {
  buffer = true,
  desc = "[o]bsidian toggle strikethrough selection",
})
