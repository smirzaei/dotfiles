return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local trouble = require('trouble')
    local function open(name)
      trouble.open(name)
    end
    vim.keymap.set('n', '<leader>do', function () open(nil) end, { desc = '[D]iagnostics [O]pen'})
    vim.keymap.set('n', '<leader>dw', function () open('workspace_diagnostics') end, { desc = '[D]iagnostics [W]orkspace'})
    vim.keymap.set('n', '<leader>dd', function () open('document_diagnostics') end, { desc = '[D]iagnostics [D]ocument'})
    vim.keymap.set('n', '<leader>dq', function () open('quickfix') end, { desc = '[D]iagnostics [Q]ickfix'})
    vim.keymap.set('n', '<leader>dl', function () open('loclist') end, { desc = '[D]iagnostics [L]oclist'})
    vim.keymap.set('n', '<leader>dr', function () open('lsp_references') end, { desc = '[D]iagnostics LSP [R]eferences'})
  end
}
