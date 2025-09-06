if vim.g.vscode then
  return {}
else
  return {
    "3rd/image.nvim",
    config = function()
      require("image").setup({
        rocks = {
            hererocks = true,  -- recommended if you do not have global installation of Lua 5.1.
        },
        spec = {
            {
                "3rd/image.nvim",
                opts = {}
            },
        },
        backend = "kitty",
        kitty_method = "normal",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },
          },
          html = {
            enabled = true,
          },
          neorg = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "norg" },
          },
        },

        -- thumbnail, the default value is 50
        max_height_window_percentage = 40,

        -- toggles images when windows are overlapped
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

        -- auto show/hide images when the editor gains/looses focus
        editor_only_render_when_focused = true,
      })
    end,
  }
end
