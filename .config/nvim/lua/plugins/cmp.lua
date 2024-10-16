local config_cmp = function()
	-- [[ Configure nvim-cmp ]]
	-- See `:help cmp`

	local kind_icons = {
		Array = " ",
		Boolean = "󰨙 ",
		Class = " ",
		Codeium = "󰘦 ",
		Color = " ",
		Control = " ",
		Collapsed = " ",
		Constant = "󰏿 ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = "󰊕 ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = " ",
		Module = "󰦮 ",
		Namespace = " ",
		Null = "󰟢 ",
		Number = "󰎠 ",
		Object = "󰘦 ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = " ",
		TabNine = "󰏚 ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = "󰀫 ",
	}

	local cmp = require("cmp")
	local luasnip = require("luasnip")
	require("luasnip.loaders.from_vscode").lazy_load()
	luasnip.config.setup({})

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		experimental = {
			ghost_text = false,
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(_, item)
				local label_width = 30
				local label = item.abbr
				local truncated_label = vim.fn.strcharpart(label, 0, label_width)

				if truncated_label ~= label then
					item.abbr = truncated_label .. "…"
				elseif string.len(label) < label_width then
					local padding = string.rep(" ", label_width - string.len(label))
					item.abbr = label .. padding
				end

				item.menu = item.kind
				item.kind = kind_icons[item.kind]
				return item
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete({}),
			["<CR>"] = cmp.mapping.confirm({ select = false }),
			["<S-CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
		}),
		-- https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "nvim_lsp_document_symbol" },
			-- { name = "crates" },
			{
				name = "luasnip",
				option = { show_autosnippets = true, use_show_condition = false }
			},
			{ name = "treesitter" },
			{
				name = "git",
				entry_filter = function ()
					if vim.bo.filetype ~= "gitcommit" then
						return false
					else
						return true
					end
				end
			},
			{
				name = "conventionalcommits",
				entry_filter = function ()
					if vim.bo.filetype ~= "gitcommit" then
						return false
					else
						return true
					end
				end
			},
			-- { name = 'buffer' },
			{ name = "path" },
			{ name = "calc" },
		},
		preselect = cmp.PreselectMode.None,
		sorting = {
			priority_weight = 2,
			comparators = {
				cmp.config.compare.exact,
				cmp.config.compare.offset,
				cmp.config.compare.kind,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.locality,
			},
		},
	})

	-- "/" completions
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- ":" completions
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			name = "cmdline",
			options = {
				ignore_cmds = { "Man", "!" },
			},
		}),
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers["signature_help"], {
		border = "single",
		close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
	})
end

return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline", -- depends on hrsh7th/cmp-buffer
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"davidsierradz/cmp-conventionalcommits",
			"ray-x/cmp-treesitter",
		},
		config = config_cmp,
	},
}
