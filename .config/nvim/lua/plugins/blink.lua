return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
	},
	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
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
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "enter" },

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},
		completion = { documentation = { auto_show = true } },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
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
	},
	opts_extend = { "sources.default" },
}
