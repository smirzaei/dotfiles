vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name ~= "nvim-treesitter" then
			return
		end

		if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
			return
		end

		if not ev.data.active then
			vim.cmd.packadd("nvim-treesitter")
		end

		vim.cmd("TSUpdate")
	end,
})

vim.pack.add({
	"https://github.com/echasnovski/mini.align",
	"https://github.com/windwp/nvim-autopairs",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/fang2hou/blink-copilot",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/catgoose/nvim-colorizer.lua",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/folke/lazydev.nvim",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/NeogitOrg/neogit",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/RRethy/vim-illuminate",
	"https://github.com/Darazaki/indent-o-matic",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	"https://github.com/folke/which-key.nvim",

	-- "https://github.com/sainnhe/gruvbox-material",
}, {
	load = function(plugin)
		vim.cmd.packadd(plugin.spec.name)
	end,
	confirm = false,
})

require("plugins.align")
require("plugins.autopair")
require("plugins.blink")
require("plugins.colorizer")
require("plugins.comment")
require("plugins.conform")
require("plugins.copilot")
require("plugins.fidget")
require("plugins.fzf")
require("plugins.git")
require("plugins.highlight")
require("plugins.indent")
require("plugins.lazydev")
require("plugins.oil")
require("plugins.statusline")
require("plugins.surround")
require("plugins.todo")
require("plugins.treesitter")
require("plugins.treesitter_textobjects")
require("plugins.which_key")

-- require("plugins.colorscheme")
