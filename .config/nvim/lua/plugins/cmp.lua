local config_cmp = function ()
  -- [[ Configure nvim-cmp ]]
  -- See `:help cmp`

  local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
  }

  local cmp = require('cmp')
  local luasnip = require('luasnip')
  require('luasnip.loaders.from_vscode').lazy_load()
  luasnip.config.setup {}

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    experimental = {
      ghost_text = true,
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(_, item)
        local label_width = 30
        local label = item.abbr
        local truncated_label = vim.fn.strcharpart(label, 0, label_width)

        if truncated_label ~= label then
          item.abbr = truncated_label .. '…'
        elseif string.len(label) < label_width then
          local padding = string.rep(' ', label_width - string.len(label))
          item.abbr = label .. padding
        end

        item.menu = item.kind
        item.kind = kind_icons[item.kind]
        return item
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete({}),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<S-CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        local function has_words_before()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))

          return col ~= 0
            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match('%s') == nil
        end

        if cmp.visible() then
          cmp.confirm({select = true})
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    -- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
    sources = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lsp_document_symbol' },
      { name = 'crates' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    },
  }

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers['signature_help'], {
      border = 'single',
      close_events = {"CursorMoved", "BufHidden", "InsertCharPre"},
    }
  )
end



return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
   },
    config = config_cmp,
  },
}
