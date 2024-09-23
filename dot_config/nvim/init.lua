require("peaske7.plugins.buffers")

-- Set language settings
vim.cmd("language en_US")

-- The second most important remaps
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set highlight on search
vim.wo.nu = true
vim.wo.signcolumn = 'yes'

vim.o.mouse = 'a'

vim.o.breakindent = true

vim.o.undofile = true
vim.o.termguicolors = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- Decrease update time
vim.o.updatetime = 150
vim.o.timeoutlen = 250

vim.o.completeopt = 'menuone,noselect'

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- These can get annoying fast so disable them
vim.o.swapfile = false
vim.o.backup = false

vim.o.colorcolumn = '80'

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", {
  expr = true, silent = true
})
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", {
  expr = true, silent = true
})

-- The most important remap
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })

-- Don't know, don't care
vim.keymap.set("n", "J", "mzJ`z")

-- Keep cursor centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep search centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- ufo folding
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- source nvim config
vim.keymap.set("n", "<leader>chea", "!chezmoi apply", { remap = false })

-- open current buffer in vertical split
vim.keymap.set('n', "<leader>vs", "<cmd>vert sb#<cr>", { remap = false })

-- inherit colorscheme from terminal
-- vim.cmd('hi Normal ctermbg=none guibg=none')

-- netrw
-- vim.cmd("hi! link netrwMarkFile Search")
-- vim.keymap.set("n", "<leader>dd", ":20Lexplore %:p:h<CR>")
-- vim.keymap.set("n", "<leader>da", ":20Lexplore <CR>")

-- terminal mode
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")

-- Always start in insert mode when opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert"
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

-- Open files at last seen position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Fix svelte syntax highlighting issue with treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/582a92ee120532a603b75239f40cba06b9a5ec07#i-experience-weird-highlighting-issues-similar-to-78
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.svelte",
  callback = function()
    vim.cmd('write | edit | TSBufEnable highlight')
  end
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',

  'machakann/vim-sandwich',
  'nvim-lua/plenary.nvim',

  { 'wakatime/vim-wakatime', lazy = false },

  {
    'stevearc/qf_helper.nvim',
    config = function()
      require("qf_helper").setup()

      -- use <C-N> and <C-P> for next/prev.
      vim.keymap.set("n", "<C-N>", "<cmd>QNext<cr>")
      vim.keymap.set("n", "<C-P>", "<cmd>QPrev<cr>")
      -- toggle the quickfix open/closed without jumping to it
      vim.keymap.set("n", "<leader>q", "<cmd>QFToggle!<cr>")
      vim.keymap.set("n", "<leader>l", "<cmd>LLToggle!<cr>")
    end
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta",  lazy = true },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = false,
    config = false,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'nvimtools/none-ls.nvim',

      {
        'jay-babu/mason-null-ls.nvim',
        opts = {}
      },

      {
        "j-hui/fidget.nvim",
        config = function()
          require('fidget').setup({
            notification = {
              window = {
                winblend = 0,
              },
            }
          })
        end
      },
    }
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',

      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
      },

    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
  },

  {
    "sontungexpt/stcursorword",
    event = "VeryLazy",
    config = true,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-go",
      "antoinemadec/FixCursorHold.nvim",
      { "fredrikaverpil/neotest-golang", version = "*" },
    },
    config = function()
      local neotest = require("neotest")

      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      neotest.setup({
        adapters = {
          require('rustaceanvim.neotest'),
          require("neotest-golang"),
        },
      })

      local opts = { noremap = true }
      vim.keymap.set("n", "<leader>nt", function()
        neotest.run.run()
      end, opts)
      vim.keymap.set('n', '<leader>ndt', function()
        neotest.run.run({ vim.fn.expand("%"), strategy = "dap" })
      end, opts)
    end
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    event = "BufReadPre",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
      require('copilot_cmp').setup()
    end
  },

  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    opts = {},
    config = function()
      -- Run gofmt + goimports on save
      local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
    end
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    event = "InsertEnter",
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
      vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, opts)
      vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, opts)

      -- grep with telescope from visual mode
      vim.keymap.set('v', '<leader>sg', 'zy:Telescope grep_string default_text=<C-r>z<CR>', opts)

      vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, opts)
      vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, opts)
      vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, opts)
      vim.keymap.set('n', '<leader>sq', telescope_builtin.quickfix, opts)
      vim.keymap.set('n', '<leader>se', telescope_builtin.registers, opts)
      vim.keymap.set('n', '<leader>sh', telescope_builtin.highlights, opts)

      -- [v] as in version control
      vim.keymap.set('n', '<leader>svc', telescope_builtin.git_commits, opts)
      vim.keymap.set('n', '<leader>svb', telescope_builtin.git_branches, opts)
      vim.keymap.set('n', '<leader>svss', telescope_builtin.git_status, opts)

      vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<cr>', opts)

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

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "rust", "lua", "javascript", "typescript" },
        auto_install = true,
        highlight = {
          enable = true,
        },

        -- disable slow treesitter highlight for large files
        disable = function(_, buf)
          local max_filesize = 3000 * 1024 -- 3000 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      })

      local npairs = require("nvim-autopairs")
      local rule = require("nvim-autopairs.rule")
      local conds = require("nvim-autopairs.conds")

      -- Angle brackets are handled as pairs too
      npairs.add_rules {
        rule("<", ">"):with_pair(conds.before_regex("%a+")):with_move(function(opts)
          return opts.char == ">"
        end),
      }
    end,
    build = ':TSUpdate',
  },

  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    opts = {}
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            runBuildScripts = true,
          },
          checkOnSave = {
            allFeatures = true,
            command = "clippy",
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force",
        {},
        opts or {})
    end
  },

  "scalameta/nvim-metals",

  {
    "folke/trouble.nvim",
    version = 'v2.x',
    event = "BufReadPre",
    config = function()
      local t = require("trouble")
      local opts = { noremap = true, silent = true }

      t.setup({
        fold_open = "v",
        fold_closed = ">",
        indent_lines = false,
        signs = {
          error = "error",
          warning = "warn",
          hint = "hint",
          information = "info"
        },
        use_diagnostic_signs = true
      })

      vim.keymap.set("n", "<leader>xx", function() t.open() end, opts)
      vim.keymap.set("n", "<leader>xw", function() t.open("workspace_diagnostics") end, opts)
      vim.keymap.set("n", "<leader>xd", function() t.open("document_diagnostics") end, opts)
      vim.keymap.set("n", "<leader>xq", function() t.open("quickfix") end, opts)
    end
  },

  'nvim-lualine/lualine.nvim',

  {
    'brenoprata10/nvim-highlight-colors',
    event = "BufReadPre",
    config = function()
      require('nvim-highlight-colors').setup({
        render = 'background',
        virtual_symbol = '■',
        enable_named_colors = true,
        enable_tailwind = false,
      })
    end
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {}
  },

  {
    'numToStr/Comment.nvim',
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufReadPre",
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    opts = {}
  },

  {
    -- I don't usually use it, but it's super helpful when I do
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "anuvyklack/keymap-amend.nvim",
      {
        "anuvyklack/fold-preview.nvim",
        config = true
      },
    },
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },

  {
    "otavioschwanck/arrow.nvim",
    lazy = false,
    opts = {
      always_show_path = true,
      separate_by_branch = true,
    }
  },

  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    config = function()
      require('gitsigns').setup()

      vim.keymap.set('n', '<leader>gl', '<cmd>Gitsigns toggle_current_line_blame<cr>', {
        noremap = true, silent = true
      })
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    event = "InsertEnter",
    opts = {}
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPre",
    config = function()
      require("rainbow-delimiters.setup").setup {}
    end,
  },

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

  -- functional
  require 'peaske7.plugins.buffers',
  require 'peaske7.plugins.nvim_tree',
  require 'peaske7.plugins.dap',

  -- cosmetic
  require 'peaske7.plugins.indent_line',
  require 'peaske7.plugins.colortheme',
  require 'peaske7.plugins.devicons',
})
