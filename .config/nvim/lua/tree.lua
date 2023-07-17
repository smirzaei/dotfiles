local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

require("nvim-tree").setup({
  filters = {
    dotfiles = false,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    }
  }
})

-- NvimTree
keymap("n", "<C-b>", ":NvimTreeToggle<CR>", opts)

