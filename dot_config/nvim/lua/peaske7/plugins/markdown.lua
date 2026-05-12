return {
  {
    dir = "/Users/jay/Developer/github.com/peaske7/readit/nvim-readit",
    name = "readit",
    ft = { "markdown" },
  },

  {
    'AckslD/nvim-FeMaco.lua',
    config = function()
      require("femaco").setup()
    end,
  },

  'Nedra1998/nvim-mdlink',
}
