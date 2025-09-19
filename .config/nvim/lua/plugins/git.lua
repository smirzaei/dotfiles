return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		},
	},
	{
		"sindrets/diffview.nvim",
		keys = {
			{
				"<leader>gdvo",
				function()
					vim.cmd("DiffviewOpen")
				end,
				desc = "[G]it [D]iff[v]iew [O]pen",
			},
			{
				"<leader>gdvc",
				function()
					vim.cmd("DiffviewClose")
				end,
				desc = "[G]it [D]iff[v]iew [C]lose",
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		opts = {
			graph_style = "unicode",
			process_spinner = true,
		},
	},
}
