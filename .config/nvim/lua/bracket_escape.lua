local PAIRS = {
	["("] = ")",
	["{"] = "}",
	["["] = "]",
	["<"] = ">",
	['"'] = '"',
	["'"] = "'",
	["`"] = "`",
}

local function default_behavior()
	-- Do the default tab behavior
	-- local tab = vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
	-- vim.fn.feedkeys(tab, "n")

	-- Jump to the next word instead
	vim.cmd("normal! w")
	vim.cmd("startinsert")
end

local function is_symmetrical(char)
	return PAIRS[char] == char
end

local function is_closing_bracket(char)
	for open, close in pairs(PAIRS) do
		if char == close and close ~= open then
			return true
		end
	end

	return false
end

local function escape_bracket()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	-- The cursor is at the first character of the line, there is nothing to do
	if col == 0 then
		default_behavior()
		return
	end

	local line = vim.api.nvim_get_current_line()
	local line_len = #line
	------------------------------------------------------------------------------
	-- PASS 1: Identify the "active" unmatched opening bracket up to the cursor
	------------------------------------------------------------------------------
	-- We'll maintain a stack of unmatched openings (char + position).
	-- Each time we see an opening bracket, we push it. Each time we see a matching
	-- closing bracket, we pop from the stack if it matches.
	local stack = {}

	for i = 1, col do
		local c = line:sub(i, i)
		local top = (#stack > 0) and stack[#stack] or nil

		if PAIRS[c] then
			if is_symmetrical(c) then
				if top and top.char == c then
					-- Found a symmetrical pair
					table.remove(stack)
				else
					table.insert(stack, { char = c, pos = i })
				end
			else
				table.insert(stack, { char = c, pos = i })
			end
		elseif is_closing_bracket(c) then
			-- Found a closing bracket
			if #stack > 0 then
				local top = stack[#stack]
				if PAIRS[top.char] == c then
					table.remove(stack) -- Found a match - POP
				end
			end
		end
	end

	-- If stack is empty then it means there's no unmatched bracket behind the cursor
	if #stack == 0 then
		default_behavior()
		return
	end

	local unmatched_open = stack[#stack]
	local open_char = unmatched_open.char
	local open_pos = unmatched_open.pos
	local needs_closing = PAIRS[open_char]

	------------------------------------------------------------------------------
	-- PASS 2: From the opening bracket, find its matching closing bracket forward
	------------------------------------------------------------------------------
	local depth = 1
	for i = open_pos + 1, line_len do
		local c = line:sub(i, i)
		if c == open_char and not is_symmetrical(open_char) then
			-- Found another opening of the same type - we need find more closing
			depth = depth + 1
		elseif c == needs_closing or (c == open_char and is_symmetrical(open_char)) then
			depth = depth - 1
			if depth == 0 then
				-- Found the matching closing bracket
				-- Note that col is 0-based and i is 1-based

				local jump_col = math.min(i, line_len)
				vim.api.nvim_win_set_cursor(0, { row, jump_col })
				return
			end
		end
	end

	-- No unmatched opening pair is found, do nothing
	default_behavior()
end

vim.keymap.set("i", "<C-l>", escape_bracket, { noremap = true, silent = true })
