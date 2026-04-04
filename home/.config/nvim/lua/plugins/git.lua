require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 1000,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
})

vim.keymap.set("n", "<leader>gdvo", function()
	vim.cmd("DiffviewOpen")
end, { desc = "[G]it [D]iff[v]iew [O]pen" })

vim.keymap.set("n", "<leader>gdvc", function()
	vim.cmd("DiffviewClose")
end, { desc = "[G]it [D]iff[v]iew [C]lose" })

require("neogit").setup({
	graph_style = "unicode",
	process_spinner = true,
})
