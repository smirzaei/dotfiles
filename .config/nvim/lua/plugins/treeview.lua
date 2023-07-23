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
      actions = {
        open_file = {
          quit_on_open = true,
        }
      }
    },
    init = function ()
      vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { desc = 'Open Tree View'})
    end
  },
}
