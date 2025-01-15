local closing_chars = { ")", "]", "}", '"', "'", "`" }

-- A simple function to jump out of enclosing brackets
local function jump_out_of_bracket()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()

	for i = col, #line do
		local char = line:sub(i, i)
		if vim.tbl_contains(closing_chars, char) then
			vim.api.nvim_win_set_cursor(0, { row, i })
			return
		end
	end
end

vim.keymap.set("i", "<Tab>", jump_out_of_bracket, { noremap = true, silent = true })
