return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      },
    },
    config = function()
      -- Enable fzf native
      pcall(require('telescope').load_extension, 'fzf')

      -- Enable args plugin
      pcall(require('telescope').load_extension, 'live_grep_args')

      local telescope_builtin = require('telescope.builtin')

      local opts = { noremap = true }
      vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, {
        noremap = true,
        desc = '[s]earch through [f]iles'
      })
      vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, {
        noremap = true,
        desc = '[s]earch with live [g]rep'
      })

      -- grep with telescope from visual mode
      vim.keymap.set('v', '<leader>sg', 'zy:Telescope grep_string default_text=<C-r>z<CR>', {
        noremap = true,
        silent = true,
        desc = '(visual) [s]earch visually selected text with live [g]rep'
      })

      vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, {
        noremap = true,
        desc = '[s]earch [d]iagnostics'
      })
      vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, {
        noremap = true,
        desc = '[s]earch [b]uffers'
      })
      vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, {
        noremap = true,
        desc = '[s]earch [r]esume'
      })
      vim.keymap.set('n', '<leader>sq', telescope_builtin.quickfix, {
        noremap = true,
        desc = '[s]earch [q]uickfix'
      })
      vim.keymap.set('n', '<leader>se', telescope_builtin.registers, {
        noremap = true,
        desc = '[s]earch r[e]gisters'
      })
      vim.keymap.set('n', '<leader>sh', telescope_builtin.highlights, {
        noremap = true,
        silent = true,
        desc = 'highlights'
      })
      vim.keymap.set('n', '<leader>sj', telescope_builtin.jumplist, {
        noremap = true,
        silent = true,
        desc = 'jumplist'
      })

      -- [v] as in version control
      vim.keymap.set('n', '<leader>svc', telescope_builtin.git_commits, {
        noremap = true,
        desc = '[s]earch [v]ersion [c]ontrol'
      })
      vim.keymap.set('n', '<leader>svb', telescope_builtin.git_branches, {
        noremap = true,
        desc = '[s]earch [v]ersion control [b]ranches'
      })
      vim.keymap.set('n', '<leader>svss', telescope_builtin.git_status, {
        noremap = true,
        desc = '[s]earch [v]ersion control [s]tatus'
      })

      vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<cr>', {
        noremap = true,
        desc = '[s]earch [t]odo'
      })

      require('telescope').setup {
        defaults = {
          file_ignore_patterns = { "%.git/.*", "node%_modules/.*", "%.venv/.*", "target/.*" },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
        extensions = {},
      }
    end
  },
}
