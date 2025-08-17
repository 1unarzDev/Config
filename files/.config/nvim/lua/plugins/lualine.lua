return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 
        'nvim-tree/nvim-web-devicons',
        'uZer/pywal16.nvim',
    },
	config = function()
        local pywal16 = require('pywal16')
        pywal16.setup()
        
        local pywal16_core = require('pywal16.core')
        local colors = pywal16_core.get_colors()
        
        local pywal_theme = {
          normal = {
            a = { fg = colors.color0, bg = colors.color5 },
            b = { fg = colors.foreground, bg = "NONE" },
            c = { fg = colors.foreground },
          },
        
          insert = { a = { fg = colors.color0, bg = colors.color4 } },
          visual = { a = { fg = colors.color0, bg = colors.color3 } },
          replace = { a = { fg = colors.foreground, bg = 'NONE' } },
        
          inactive = {
            a = { fg = colors.foreground, bg = 'NONE' },
            b = { fg = colors.foreground, bg = 'NONE' },
            c = { fg = colors.foreground },
          },
        }
        
        -- local auto_theme_custom = require('lualine.themes.auto')
        -- auto_theme_custom.normal.c.bg = 'none'
        
        require('lualine').setup {
          options = {
            icons_enabled = true,
            theme = pywal_theme,
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
              statusline = {},
              winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
              statusline = 1000,
              tabline = 1000,
              winbar = 1000,
              refresh_time = 16, -- ~60fps
              events = {
                'WinEnter',
                'BufEnter',
                'BufWritePost',
                'SessionLoadPost',
                'FileChangedShellPost',
                'VimResized',
                'Filetype',
                'CursorMoved',
                'CursorMovedI',
                'ModeChanged',
              },
            }
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
          },
          tabline = {},
          winbar = {},
          inactive_winbar = {},
          extensions = {}
        }
    end,
}
