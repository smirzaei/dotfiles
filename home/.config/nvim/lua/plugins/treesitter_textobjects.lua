local textobjects = require("nvim-treesitter-textobjects")
local move = require("nvim-treesitter-textobjects.move")
local select = require("nvim-treesitter-textobjects.select")

textobjects.setup({
	select = {
		lookahead = true,
	},
	move = {
		set_jumps = true,
	},
})

local map = vim.keymap.set

-- You can use the capture groups defined in textobjects.scm.
map({ "x", "o" }, "aa", function()
	select.select_textobject("@parameter.outer", "textobjects")
end)
map({ "x", "o" }, "ia", function()
	select.select_textobject("@parameter.inner", "textobjects")
end)
map({ "x", "o" }, "af", function()
	select.select_textobject("@function.outer", "textobjects")
end)
map({ "x", "o" }, "if", function()
	select.select_textobject("@function.inner", "textobjects")
end)
map({ "x", "o" }, "ac", function()
	select.select_textobject("@class.outer", "textobjects")
end)
map({ "x", "o" }, "ic", function()
	select.select_textobject("@class.inner", "textobjects")
end)

map({ "n", "x", "o" }, "]m", function()
	move.goto_next_start("@function.outer", "textobjects")
end)
map({ "n", "x", "o" }, "]]", function()
	move.goto_next_start("@class.outer", "textobjects")
end)
map({ "n", "x", "o" }, "]M", function()
	move.goto_next_end("@function.outer", "textobjects")
end)
map({ "n", "x", "o" }, "][", function()
	move.goto_next_end("@class.outer", "textobjects")
end)
map({ "n", "x", "o" }, "[m", function()
	move.goto_previous_start("@function.outer", "textobjects")
end)
map({ "n", "x", "o" }, "[[", function()
	move.goto_previous_start("@class.outer", "textobjects")
end)
map({ "n", "x", "o" }, "[M", function()
	move.goto_previous_end("@function.outer", "textobjects")
end)
map({ "n", "x", "o" }, "[]", function()
	move.goto_previous_end("@class.outer", "textobjects")
end)
