-- live-preview.nvim: in-browser preview for HTML/Markdown/AsciiDoc with
-- WebSocket auto-reload on :w. Bundles its own HTTP server (default :5500),
-- so no live-server / browser-sync dep needed.
--
-- Lazy on :LivePreview command + filetype, so it never loads until first use.
-- Picker auto-detects snacks (already the project default), no extra wiring.
return {
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "LivePreview" },
    ft = { "html", "markdown", "asciidoc" },
    opts = {
      port = 5500,
      browser = "default",
      dynamic_root = false,
    },
    keys = {
      { "<leader>lp", "<cmd>LivePreview start<cr>",  desc = "[l]ive [p]review start" },
      { "<leader>lc", "<cmd>LivePreview close<cr>",  desc = "[l]ive preview [c]lose" },
      { "<leader>lf", "<cmd>LivePreview pick<cr>",   desc = "[l]ive preview pick [f]ile" },
    },
  },
}
