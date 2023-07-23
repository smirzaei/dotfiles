return {
  'catppuccin/nvim', name = 'catppuccin', priority = 1000,
  opts = {
      flavour = 'mocha',
      show_end_of_buffer = true,
  },
  config = function()
      vim.cmd.colorscheme('catppuccin')
  end
}

