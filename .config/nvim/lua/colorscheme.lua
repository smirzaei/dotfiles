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
	red     = "#ffa9a0",
	green   = "#9cf3ae",
	blue    = "#8cd1ff",
	yellow  = "#ffdb77",
	magenta = "#ffb0ff",
	cyan    = "#6cfffd",
	white   = "#ffffff",
	gray1   = "#eef1f8",
	gray2   = "#e0e2ea",
	gray3   = "#c4c6cd",
	gray4   = "#9b9ea4",
	gray5   = "#4f5258",
	gray6   = "#2c2e33",
	gray7   = "#14161b",
	gray8   = "#07080d"
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

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local M = {
	palette = palette,
	lualine = {
		normal = {},
	},
}

M.apply = function()
	vim.o.background = "dark"

	hl("Normal", { fg = palette.fg, bg = palette.bg }) -- Normal text, editor background
	hl("Identifier", { fg = palette.fg }) -- Variable names, etc.
	hl("@Variable", { fg = palette.fg }) -- Variable names, etc.
	hl("Comment", { fg = palette.comment })
	hl("Character", { fg = palette.string }) -- e.g. 'c'
	hl("String", { fg = palette.string })
	hl("Function", { fg = palette.fn_name }) -- Function names
	hl("Statement", { fg = palette.keyword }) -- Keywords
	hl("Special", { fg = palette.symbol }) -- Symbols
	hl("Type", { fg = palette.type }) -- types like struct, class, etc.
	hl("ColorColumn", { bg = palette.colorcolumn }) -- types like struct, class, etc.

	-- Go
	hl("@constant.builtin.go", { fg = palette.symbol, italic = true }) -- nil
	hl("@function.builtin.go", { fg = palette.symbol, italic = true }) -- make, append, len, cap
	hl("@keyword.function.go", { fg = palette.keyword, italic = true }) -- func
	hl("@keyword.repeat.go", { fg = palette.keyword, italic = true }) -- for
end

return M
