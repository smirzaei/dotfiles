return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      filters = {
        dotfiles = false,
      },
    },
    init = function ()
      vim.keymap.set('n', '<leader>ot', ':NvimTreeToggle<CR>', { desc = '[O]pen [T]ree View'})
    end
  },
}
