require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	keymaps = {
		["<C-v>"] = { "actions.select", opts = { vertical = true } },
		["C-p"] = "actions.preview",

		-- Prevent accidentally leaving the floating window.
		["<C-h>"] = function() end,
		["<C-l>"] = function() end,
		["<C-k>"] = function() end,
		["<C-j>"] = function() end,
	},
})

vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Oil" })
