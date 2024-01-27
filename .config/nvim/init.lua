require('options')
require('keybindings')
require('autocmds')
require('init_lazy')

require('lazy').setup({
  { import = 'plugins' },
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Custom Commands
function format_then_write(opts)
  vim.cmd.Format()
  vim.cmd.write()
end

vim.api.nvim_create_user_command('FW', format_then_write, {})


