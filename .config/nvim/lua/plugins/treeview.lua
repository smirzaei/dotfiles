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
      vim.keymap.set('n', '<leader>ot', ':NvimTreeToggle<CR>', { desc = '[O]pen [T]ree View'})
    end
  },
}
