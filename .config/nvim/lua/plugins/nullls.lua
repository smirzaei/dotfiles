local init_null_ls = function()
  local null_ls = require('null-ls')

  local sources = {
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.diagnostics.actionlint, -- Github Actions
    null_ls.builtins.diagnostics.buf, -- Protocol Buffers
    null_ls.builtins.diagnostics.checkmake, -- Makefile
    null_ls.builtins.diagnostics.dotenv_linter, -- .env
    null_ls.builtins.diagnostics.shellcheck, -- shell script
    null_ls.builtins.diagnostics.tfsec, -- Terraform
    null_ls.builtins.diagnostics.typos, -- Misspelling
  }

  null_ls.setup({
    sources = sources,
  })
end

return {
  'jose-elias-alvarez/null-ls.nvim',
  config = init_null_ls,
  dependencies = {
    'nvim-lua/plenary.nvim',
  }
}
