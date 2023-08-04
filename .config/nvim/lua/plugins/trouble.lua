return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function ()
    local trouble = require('trouble')
    local function open(name)
      trouble.open(name)
    end
    vim.keymap.set('n', '<leader>xx', function () open(nil) end)
    vim.keymap.set('n', '<leader>xw', function () open('workspace_diagnostics') end)
    vim.keymap.set('n', '<leader>xd', function () open('document_diagnostics') end)
    vim.keymap.set('n', '<leader>xq', function () open('quickfix') end)
    vim.keymap.set('n', '<leader>xl', function () open('loclist') end)
    vim.keymap.set('n', 'gR', function () open('lsp_references') end)
  end
}
