return {

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {
    'AckslD/nvim-FeMaco.lua',
    config = function()
      require("femaco").setup()
    end,
  },

  'Nedra1998/nvim-mdlink',
}
