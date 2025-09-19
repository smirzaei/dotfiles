local colorscheme = require("colorscheme")

local file_format = {
	"fileformat",
	symbols = {
		unix = "unix",
		dos = "dos",
		mac = "mac",
	},
}

-- stylua: ignore
local mode_map = {
	["n"]      = "N",
	["no"]     = "O·P",
	["nov"]    = "O·P",
	["noV"]    = "O·P",
	["no\22"]  = "O·P",
	["niI"]    = "N·I",
	["niR"]    = "N·R",
	["niV"]    = "N",
	["nt"]     = "N·T",
	["v"]      = "V",
	["vs"]     = "V",
	["V"]      = "V·L",
	["Vs"]     = "V·L",
	["\22"]    = "V·B",
	["\22s"]   = "V·B",
	["s"]      = "S",
	["S"]      = "S·L",
	["\19"]    = "S·B",
	["i"]      = "I",
	["ic"]     = "I·C",
	["ix"]     = "I·X",
	["R"]      = "R",
	["Rc"]     = "R·C",
	["Rx"]     = "R·X",
	["Rv"]     = "V·R",
	["Rvc"]    = "RVC",
	["Rvx"]    = "RVX",
	["c"]      = "C",
	["cv"]     = "EX",
	["ce"]     = "EX",
	["r"]      = "R",
	["rm"]     = "M",
	["r?"]     = "C",
	["!"]      = "SH",
	["t"]      = "T",
}

local function short_mode()
	return mode_map[vim.api.nvim_get_mode().mode] or "?"
end

local lualine_cfg = {
	options = {
		icons_enabled = true,
		theme = colorscheme.lualine,
		component_separators = "|",
		section_separators = "",
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 200,
			tabline = 200,
			winbar = 200,
		},
	},
	sections = {
		lualine_a = { short_mode },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{ "filename", path = 1 },
		},
		lualine_x = { "encoding", file_format, "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	config = function()
		require("mini.icons").setup()
		require("mini.icons").mock_nvim_web_devicons()

		require("lualine").setup(lualine_cfg)
	end,
}
