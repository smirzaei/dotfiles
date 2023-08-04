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
      vim.cmd.colorscheme('catppuccin')
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
  },
  {
    'AlexvZyl/nordic.nvim',
  },
  {
    'sainnhe/gruvbox-material',
  },
}

