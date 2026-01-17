return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			show_hidden = true,
		},
		keymaps = {
			["<C-v>"] = { "actions.select", opts = { vertical = true } },
			["C-p"] = "actions.preview",

			-- Prevent accidentally leaving the floating window
			["<C-h>"] = function() end,
			["<C-l>"] = function() end,
			["<C-k>"] = function() end,
			["<C-j>"] = function() end,
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "-", "<cmd>Oil --float<CR>", desc = "Open Oil" },
	},
}
