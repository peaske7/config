-- Disabled 2026-05-08: image.nvim/diagram.nvim render bleeds across tmux panes
-- and floating windows under Ghostty. Using markdown-preview instead.
-- Re-enable by flipping `enabled = true` on both specs.
return {
  {
    "3rd/image.nvim",
    enabled = false,
    -- magick_cli avoids the luarocks `magick` rock; relies on the system
    -- ImageMagick binary (brew install imagemagick).
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_width_window_percentage = 80,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif" },
      -- tmux: only paint into the focused tmux window/nvim instance to avoid
      -- ghost images on window-switch (we set allow-passthrough on in tmux.conf).
      tmux_show_only_in_active_window = true,
      editor_only_render_when_focused = true,
    },
  },
  {
    "3rd/diagram.nvim",
    enabled = false,
    dependencies = { "3rd/image.nvim" },
    -- `config` not `opts`: the integrations table requires the plugin to be
    -- on the runtimepath at setup time, which only holds inside config().
    config = function()
      require("diagram").setup({
        integrations = {
          require("diagram.integrations.markdown"),
        },
        renderer_options = {
          mermaid = {
            theme = "dark",
            scale = 2,
          },
        },
      })
    end,
  },
}
