-- Default Neovim colorscheme
-- Yoinked from https://github.com/neovim/neovim/blob/2331c52affe64070ad59c0ef63ddcc8f7ca41781/src/nvim/highlight_group.c#L2928-L2958
-- // Default Neovim palettes.
-- // Dark/light palette is used for background in dark/light color scheme and
-- // for foreground in light/dark color scheme.
-- { "NvimDarkBlue", RGB_(0x00, 0x4c, 0x73) },
-- { "NvimDarkCyan", RGB_(0x00, 0x73, 0x73) },
-- { "NvimDarkGray1", RGB_(0x07, 0x08, 0x0d) },
-- { "NvimDarkGray2", RGB_(0x14, 0x16, 0x1b) },
-- { "NvimDarkGray3", RGB_(0x2c, 0x2e, 0x33) },
-- { "NvimDarkGray4", RGB_(0x4f, 0x52, 0x58) },
-- { "NvimDarkGreen", RGB_(0x00, 0x55, 0x23) },
-- { "NvimDarkGrey1", RGB_(0x07, 0x08, 0x0d) },
-- { "NvimDarkGrey2", RGB_(0x14, 0x16, 0x1b) },
-- { "NvimDarkGrey3", RGB_(0x2c, 0x2e, 0x33) },
-- { "NvimDarkGrey4", RGB_(0x4f, 0x52, 0x58) },
-- { "NvimDarkMagenta", RGB_(0x47, 0x00, 0x45) },
-- { "NvimDarkRed", RGB_(0x59, 0x00, 0x08) },
-- { "NvimDarkYellow", RGB_(0x6b, 0x53, 0x00) },
-- { "NvimLightBlue", RGB_(0xa6, 0xdb, 0xff) },
-- { "NvimLightCyan", RGB_(0x8c, 0xf8, 0xf7) },
-- { "NvimLightGray1", RGB_(0xee, 0xf1, 0xf8) },
-- { "NvimLightGray2", RGB_(0xe0, 0xe2, 0xea) },
-- { "NvimLightGray3", RGB_(0xc4, 0xc6, 0xcd) },
-- { "NvimLightGray4", RGB_(0x9b, 0x9e, 0xa4) },
-- { "NvimLightGreen", RGB_(0xb3, 0xf6, 0xc0) },
-- { "NvimLightGrey1", RGB_(0xee, 0xf1, 0xf8) },
-- { "NvimLightGrey2", RGB_(0xe0, 0xe2, 0xea) },
-- { "NvimLightGrey3", RGB_(0xc4, 0xc6, 0xcd) },
-- { "NvimLightGrey4", RGB_(0x9b, 0x9e, 0xa4) },
-- { "NvimLightMagenta", RGB_(0xff, 0xca, 0xff) },
-- { "NvimLightRed", RGB_(0xff, 0xc0, 0xb9) },
-- { "NvimLightYellow", RGB_(0xfc, 0xe0, 0x94) },

-- stylua: ignore
local palette = {
	red           = "#ffa9a0",
	red_light     = "#ffc0b9",
	green         = "#9cf3ae",
	green_light   = "#b3f6c0",
	blue          = "#8cd1ff",
	blue_light    = "#a6dbff",
	yellow        = "#ffdb77",
	yellow_light  = "#fce094",
	magenta       = "#ffb0ff",
	magenta_light = "#ffcaff",
	cyan          = "#6cfffd",
	cyan_light    = "#8cf8f7",
	white         = "#ffffff",
	gray1         = "#eef1f8",
	gray2         = "#e0e2ea",
	gray3         = "#c4c6cd",
	gray4         = "#9b9ea4",
	gray5         = "#4f5258",
	gray6         = "#2c2e33",
	gray7         = "#14161b",
	gray8         = "#07080d"
}

palette.bg = palette.gray7
palette.fg = palette.white
palette.comment = palette.gray4
palette.colorcolumn = "#1a1d23"
palette.string = palette.green
palette.fn_name = palette.blue
palette.keyword = palette.red
palette.symbol = palette.cyan
palette.type = palette.yellow

-- Lualine
-- Most of these colors are yoinked from the default colors.
-- I just really dislike the huge white background that appears in the middle of
-- my status line. It might be a misconfiguarion on my end
-- stylua: ignore
palette.lualine = {
	red     = palette.red_light,
	green   = "#c4ffd3",
	blue    = "#b6f0ff",
	cyan    = "#9affff",

	gray1 = "#565a60",
	gray2 = "#a7a9ae",

	gray3 = "#16181d",
	gray4 = "#65696f",
}

palette.diffview = {
	red = "#4f3a3b",
	green = "#24352d",
	gold = "#956a07",
	yellow = "#433215",
	bg = palette.gray7,
	green_pop = "#1a5c4a",
}

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local M = {
	palette = palette,
	lualine = {
		normal = {
			a = { bg = palette.lualine.gray1, fg = palette.lualine.gray2, gui = "bold" },
			b = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			c = { bg = palette.lualine.gray3, fg = palette.gray2 },
			x = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			y = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			z = { bg = palette.lualine.gray1, fg = palette.lualine.gray2, gui = "bold" },
		},
		insert = {
			a = { bg = palette.lualine.green, fg = palette.lualine.gray3, gui = "bold" },
			b = { bg = palette.lualine.gray3, fg = palette.lualine.green },
			c = { bg = palette.lualine.gray3, fg = palette.gray2 },
			x = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			y = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			z = { bg = palette.lualine.green, fg = palette.lualine.gray3, gui = "bold" },
		},
		visual = {
			a = { bg = palette.lualine.blue, fg = palette.lualine.gray3, gui = "bold" },
			b = { bg = palette.lualine.gray3, fg = palette.lualine.blue },
			c = { bg = palette.lualine.gray3, fg = palette.gray2 },
			x = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			y = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			z = { bg = palette.lualine.blue, fg = palette.lualine.gray3, gui = "bold" },
		},
		replace = {
			a = { bg = palette.lualine.red, fg = palette.lualine.gray3, gui = "bold" },
			b = { bg = palette.lualine.gray3, fg = palette.lualine.red },
			c = { bg = palette.lualine.gray3, fg = palette.gray2 },
			x = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			y = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			z = { bg = palette.lualine.red, fg = palette.lualine.gray3, gui = "bold" },
		},
		command = {
			a = { bg = palette.lualine.cyan, fg = palette.lualine.gray3, gui = "bold" },
			b = { bg = palette.lualine.gray3, fg = palette.lualine.cyan },
			c = { bg = palette.lualine.gray3, fg = palette.gray2 },
			x = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			y = { bg = palette.lualine.gray3, fg = palette.lualine.gray4 },
			z = { bg = palette.lualine.cyan, fg = palette.lualine.gray3, gui = "bold" },
		},
		inactive = {
			c = { bg = palette.lualine.gray3, fg = palette.lualine.gray2 },
		},
	},
}

M.apply = function()
	vim.o.background = "dark"

	hl("Normal", { fg = palette.fg, bg = palette.bg }) -- Normal text, editor background
	hl("Visual", { bg = palette.gray5 }) -- Selected text in visual mode

	hl("CursorLine", { bg = palette.gray6 }) -- Cursor line color
	hl("CursorLineNr", { bg = palette.gray6, fg = palette.fg }) -- Cursor line color on the number line
	hl("LineNr", { bg = palette.bg, fg = palette.gray5 }) -- Line number

	-- https://neovim.io/doc/user/syntax.html
	hl("@variable", { fg = palette.fg })
	hl("Identifier", { link = "@variable" }) -- Variable names, etc.

	hl("@comment", { fg = palette.comment })
	hl("Comment", { link = "@comment" })

	hl("@string", { fg = palette.string })
	hl("String", { link = "@string" })
	hl("Character", { link = "@string" }) -- e.g. 'c'

	hl("@function", { fg = palette.fn_name })
	hl("Function", { link = "@function" })

	hl("@keyword", { fg = palette.keyword })
	hl("Statement", { link = "@keyword" })

	hl("@type", { fg = palette.type }) -- types like struct, class, etc.
	hl("Type", { link = "@type" })

	hl("@symbol", { fg = palette.symbol })
	hl("Special", { link = "@symbol" })
	hl("boolean", { link = "@symbol" })

	hl("Search", { bg = palette.gray3, fg = palette.gray7 })
	hl("CurSearch", { bg = palette.yellow, fg = palette.gray7 })
	hl("Error", { bg = palette.red, fg = palette.gray7, bold = true })
	hl("Todo", { bg = palette.yellow, fg = palette.gray7, bold = true })
	hl("Whitespace", { fg = palette.gray5 })

	hl("ColorColumn", { bg = palette.colorcolumn })

	-- Rust
	hl("@keyword.rust", { fg = palette.keyword, italic = true }) -- let
	hl("@keyword.function.rust", { fg = palette.keyword, italic = true }) -- fn
	hl("@lsp.typemod.keyword.unsafe.rust", { reverse = true, nocombine = true }) -- unsafe
	hl("@lsp.type.macro.rust", { fg = palette.fn_name })

	-- Go
	hl("@constant.builtin.go", { fg = palette.symbol, italic = true }) -- nil
	hl("@function.builtin.go", { fg = palette.symbol, italic = true }) -- make, append, len, cap
	hl("@keyword.function.go", { fg = palette.keyword, italic = true }) -- func
	hl("@keyword.repeat.go", { fg = palette.keyword, italic = true }) -- for
	hl("@boolean.go", { fg = palette.symbol, bold = true }) -- true, false

	-- Diffview
	hl("DiffAdd", { bg = palette.diffview.green })
	hl("DiffDelete", { bg = palette.diffview.red, fg = palette.diffview.red })
	hl("DiffChange", { bg = palette.diffview.yellow })
	hl("DiffText", { bg = palette.diffview.green_pop, bold = true })
end

return M
