return {
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      local devicons = require("nvim-web-devicons")

      devicons.set_icon {
        ['prettier.config.js'] = {
          icon = "",
          color = "#4285F4",
          cterm_color = "33",
          name = "PrettierConfig",
        },
      }
    end,
  },

}
