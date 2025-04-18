return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "main",
				dark_variant = "main",
				styles = {
					italic = false,
				},
			})

			-- vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		"vague2k/vague.nvim",
		config = function()
			require("vague").setup({
				style = {
					comments = "none",
					strings = "none",
				},
			})

			-- vim.cmd.colorscheme("vague")
		end,
	},
	{
		"RRethy/base16-nvim",
	},
	{
		"mellow-theme/mellow.nvim",
	},
	{
		"projekt0n/github-nvim-theme",
	},
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	config = function()
	-- 		local configuration = vim.fn["gruvbox_material#get_configuration"]()
	--
	-- 		-- This is what's available in the palette
	-- 		-- {
	-- 		--     aqua = { "#89b482", "108" },
	-- 		--     bg0 = { "#282828", "235" },
	-- 		--     bg1 = { "#32302f", "236" },
	-- 		--     bg2 = { "#32302f", "236" },
	-- 		--     bg3 = { "#45403d", "237" },
	-- 		--     bg4 = { "#45403d", "237" },
	-- 		--     bg5 = { "#5a524c", "239" },
	-- 		--     bg_current_word = { "#3c3836", "237" },
	-- 		--     bg_diff_blue = { "#0e363e", "17" },
	-- 		--     bg_diff_green = { "#34381b", "22" },
	-- 		--     bg_diff_red = { "#402120", "52" },
	-- 		--     bg_dim = { "#1b1b1b", "233" },
	-- 		--     bg_green = { "#a9b665", "142" },
	-- 		--     bg_red = { "#ea6962", "167" },
	-- 		--     bg_statusline1 = { "#32302f", "236" },
	-- 		--     bg_statusline2 = { "#3a3735", "236" },
	-- 		--     bg_statusline3 = { "#504945", "240" },
	-- 		--     bg_visual_blue = { "#374141", "17" },
	-- 		--     bg_visual_green = { "#3b4439", "22" },
	-- 		--     bg_visual_red = { "#4c3432", "52" },
	-- 		--     bg_visual_yellow = { "#4f422e", "94" },
	-- 		--     bg_yellow = { "#d8a657", "214" },
	-- 		--     blue = { "#7daea3", "109" },
	-- 		--     fg0 = { "#d4be98", "223" },
	-- 		--     fg1 = { "#ddc7a1", "223" },
	-- 		--     green = { "#a9b665", "142" },
	-- 		--     grey0 = { "#7c6f64", "243" },
	-- 		--     grey1 = { "#928374", "245" },
	-- 		--     grey2 = { "#a89984", "246" },
	-- 		--     none = { "NONE", "NONE" },
	-- 		--     orange = { "#e78a4e", "208" },
	-- 		--     purple = { "#d3869b", "175" },
	-- 		--     red = { "#ea6962", "167" },
	-- 		--     yellow = { "#d8a657", "214" },
	-- 		-- }
	--
	-- 		local palette = vim.fn["gruvbox_material#get_palette"](
	-- 			configuration.background,
	-- 			configuration.foreground,
	-- 			configuration.colors_override
	-- 		)
	--
	-- 		local function get_color(name)
	-- 			for _, v in pairs(palette[name]) do
	-- 				return v
	-- 			end
	-- 		end
	--
	-- 		vim.g.gruvbox_material_background = "hard"
	-- 		vim.g.gruvbox_material_disable_italic_comment = 1
	-- 		vim.g.gruvbox_material_diagnostic_text_highlight = 1
	-- 		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
	-- 		vim.cmd.colorscheme("gruvbox-material")
	--
	-- 		-- To get a list of available highlight groups run:
	-- 		-- :h nvim-tree-highlight
	-- 		-- vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = get_color("fg0") })
	-- 		-- vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = get_color("blue") })
	-- 		-- vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = get_color("green") })
	-- 		-- vim.api.nvim_set_hl(0, "DiagnosticError", { fg = get_color("red") })
	-- 		-- vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = get_color("yellow") })
	-- 	end,
	-- },
}
