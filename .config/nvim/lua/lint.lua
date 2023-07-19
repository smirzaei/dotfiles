local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Spell checking
    -- null_ls.builtins.diagnostics.cspell,
    -- null_ls.builtins.code_actions.cspell,
    -- null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.code_actions.proselint, -- catch grammatical errors
    -- null_ls.builtins.diagnostics.actionlint, -- GitHub actions
    -- null_ls.builtins.diagnostics.buf, -- protobuffs
    -- null_ls.builtins.diagnostics.checkmake, -- Makefile
    -- null_ls.builtins.formatting.clang_format,
    -- null_ls.builtins.diagnostics.clang_check, -- C, C++
    -- null_ls.builtins.diagnostics.dotenv_linter, -- .env
    -- null_ls.builtins.diagnostics.gitlint, -- Git commit
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.diagnostics.trail_space,
  }
})
