return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = { "Obsidian" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    ---@module "obsidian"
    ---@type obsidian.config.ClientOpts
    opts = {
      -- Vault lives on local disk via Obsidian Sync (no more iCloud Drive).
      workspaces = {
        {
          name = "main",
          path = "~/Obsidian",
        },
      },

      -- Opt out of the legacy `ObsidianFoo` command aliases (removed in 4.0).
      legacy_commands = false,

      -- Snacks picker integration
      picker = {
        name = "snacks.pick",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },

      -- Completion via blink.cmp (already configured in init.lua)
      -- min_chars = 3 avoids triggering vault-wide ripgrep on every keystroke.
      -- (Was needed for iCloud Drive latency; local SSD is faster but still a good default.)
      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 3,
      },

      -- Daily notes — matches Obsidian app's YYYY/MM/DD format.
      -- Files land at: 2026/04/15.md (vault root, no nesting).
      daily_notes = {
        folder = ".",
        date_format = "%Y/%m/%d",
        alias_format = "%B %-d, %Y",
        template = nil,
      },

      -- Link creation; `format = "shortest"` matches vault's app.json `newLinkFormat`.
      link = {
        style = "wiki",
        format = "shortest",
      },

      -- New notes go into Inbox for later triage.
      new_notes_location = "notes_subdir",
      notes_subdir = "Inbox",

      -- Disable the built-in UI so render-markdown/other markdown plugins
      -- keep full control over rendering.
      ui = { enable = false },

      -- Attachments — matches vault's app.json `attachmentFolderPath`.
      attachments = {
        folder = "assets/imgs",
      },
    },
    keys = {
      { "<leader>oo", "<cmd>Obsidian open<cr>",         desc = "[o]bsidian [o]pen in app" },
      { "<leader>on", "<cmd>Obsidian new<cr>",          desc = "[o]bsidian [n]ew note" },
      { "<leader>os", "<cmd>Obsidian search<cr>",       desc = "[o]bsidian [s]earch" },
      { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "[o]bsidian [q]uick switch" },
      { "<leader>ot", "<cmd>Obsidian today<cr>",        desc = "[o]bsidian [t]oday" },
      { "<leader>oy", "<cmd>Obsidian yesterday<cr>",    desc = "[o]bsidian [y]esterday" },
      { "<leader>od", "<cmd>Obsidian dailies<cr>",      desc = "[o]bsidian [d]ailies" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>",    desc = "[o]bsidian [b]acklinks" },
      { "<leader>og", "<cmd>Obsidian tags<cr>",         desc = "[o]bsidian ta[g]s" },
      { "<leader>ol", "<cmd>Obsidian follow_link<cr>",  desc = "[o]bsidian follow [l]ink" },
      { "<leader>om", "<cmd>Obsidian template<cr>",     desc = "[o]bsidian te[m]plate" },
      { "<leader>op", "<cmd>Obsidian paste_img<cr>",    desc = "[o]bsidian [p]aste image" },
    },
  },
}
