local langs = {
	"c",
	"rust",
	"zig",
	"go",
	"gomod",
	"gosum",
	"lua",
	"luadoc",
	"vimdoc",
	"vim",
	"markdown",
	"markdown_inline",
	"python",
	"ruby",
	"javascript",
	"typescript",
	"html",
	"css",
	"json",
	"proto",
	"sql",
	"bash",
	"csv",
	"nix",
	"dockerfile",
	"yaml",
	"toml",
	"helm",
	"ini",
	"diff",
	"terraform",
	"editorconfig",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"nix",
}

local config_treesitter = function()
	-- See `:help nvim-treesitter`
	require("nvim-treesitter.configs").setup({
		-- Add languages to be installed here that you want installed for treesitter
		ensure_installed = langs,

		-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
		auto_install = true,

		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<Enter>",
				node_incremental = "<Enter>",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				-- swap_next = {
				--   ["<leader>a"] = "@parameter.inner",
				-- },
				-- swap_previous = {
				--   ["<leader>A"] = "@parameter.inner",
				-- },
			},
		},
	})
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = config_treesitter,
	},
}
