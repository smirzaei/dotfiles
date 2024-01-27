require('options')
require('keybindings')
require('autocmds')
require('init_lazy')

require('lazy').setup({
  { import = 'plugins' },
})

-- Custom Commands
function format_then_write(opts)
  vim.cmd.Format()
  vim.cmd.write()
end

vim.api.nvim_create_user_command('FW', format_then_write, {})


