require("blink.cmp").setup({
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap.
	keymap = { preset = "default" },
	signature = { enabled = true },
	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned.
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = true } },
	cmdline = {
		keymap = { preset = "inherit" },
		completion = { menu = { auto_show = true } },
	},
	-- Keep copilot in default sources for blink-copilot integration.
	sources = {
		-- Default list of enabled providers.
		default = { "lsp", "copilot", "path", "snippets", "buffer" },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				async = true,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
