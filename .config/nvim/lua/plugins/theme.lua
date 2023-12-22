local config_catppuccin = function()
  require('catppuccin').setup({
    flavour = 'mocha',
    show_end_of_buffer = true,
    no_italic = true,
    styles = {
      comments = {},
    },
    integrations = {
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = {},
          hints = {},
          warnings = {},
          information = {},
        }
      }
    },
    dim_inactive = {
      enabled = true,
      shade = 'dark',
      percentage = 0.5,
    }
  })
end

return {
  {
    'catppuccin/nvim', name = 'catppuccin', priority = 1000,
    opts = {
      flavour = 'mocha',
      show_end_of_buffer = true,
    },
    config = function()
      config_catppuccin()
    end
  },
  {
    'folke/tokyonight.nvim'
  },
  {
    'EdenEast/nightfox.nvim',
  },
  {
    'sainnhe/everforest',
    config = function ()
      -- vim.cmd.colorscheme('everforest')
    end
  },
  {
    'nordtheme/vim',
  },
  {
    'AlexvZyl/nordic.nvim',
    config = function ()
      require('nordic').setup({
        override = {
          Visual = {
            bg = '#3A515D'
          }
        }
      })

      -- vim.cmd.colorscheme('nordic')
    end
  },
  {
    'sainnhe/gruvbox-material',
    config = function ()
      vim.cmd.colorscheme('gruvbox-material')
    end
  },
  {
    'projekt0n/github-nvim-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup({
      })

      -- vim.cmd.colorscheme('github_dark_dimmed')
      -- vim.cmd.colorscheme('github_dark')
    end,
  },
  {
    'Shatur/neovim-ayu',
    config = function ()
      local colors = require('ayu.colors')
      require('ayu').setup({
        dark = true,
        overrides = function ()
          return { Comment = { fg =  colors.comment }}
        end
      })

      -- vim.cmd.colorscheme('ayu')
    end
  }
}

