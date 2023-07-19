local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#configurations
local lsp_servers = {
  "gopls",
  "golangci_lint_ls",
  "rust_analyzer",
--  "yamlls",
  "lua_ls",
--  "dockerls",
--  "docker-compose-langserver",
--  "sqls",
}


-- When you don't have mason.nvim installed
-- You'll need to list the servers installed in your system
lsp.setup_servers(lsp_servers)

lsp.ensure_installed(lsp_servers)

-- (Optional) Configure lua language server for neovim
require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.on_attach(function (client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function () vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "<C-Space>", function () vim.lsp.buf.hover() end, opts)
  vim.keymap.set("i", "<C-Space>", function () vim.lsp.buf.hover() end, opts)
  vim.keymap.set("i", "<C-Space>", function () vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
  }),
  mapping = {
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    ["<Tab>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}),
    -- Ctrl+Space to trigger completion menu
    ['<C-n'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = cmp.SelectBehavior.Select})
      else
        cmp.complete()
      end
    end),
    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  }
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers['signature_help'], {
    border = 'single',
    close_events = {"CursorMoved", "BufHidden", "InsertCharPre"},
  }
)

