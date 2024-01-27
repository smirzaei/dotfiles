return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local trouble = require('trouble')
    local function open(name)
      trouble.open(name)
    end
    vim.keymap.set('n', '<leader>odg', function () open(nil) end, { desc = 'Open Global Diagnostics'})
    vim.keymap.set('n', '<leader>odw', function () open('workspace_diagnostics') end, { desc = 'Open Workspace Diagnostics'})
    vim.keymap.set('n', '<leader>odd', function () open('document_diagnostics') end, { desc = 'Open Document Diagnostics'})
    vim.keymap.set('n', '<leader>odq', function () open('quickfix') end, { desc = 'Open Diagnostics Quickfix'})
    vim.keymap.set('n', '<leader>odl', function () open('loclist') end, { desc = 'Open Diagnostics Loclist'})
    vim.keymap.set('n', '<leader>odr', function () open('lsp_references') end, { desc = 'Open Diagnostics LSP References'})
  end
}

