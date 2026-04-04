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
}

local ts = require("nvim-treesitter")

-- See `:help nvim-treesitter`
ts.setup({})

-- Keep parser set synced with the languages used in this config.
ts.install(langs)

local function enable_treesitter(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return
	end

	local ok = pcall(vim.treesitter.start, bufnr)
	if not ok then
		return
	end

	-- Treesitter-based indentation is still provided by nvim-treesitter.
	vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local ts_group = vim.api.nvim_create_augroup("dotfiles_treesitter", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = ts_group,
	callback = function(args)
		enable_treesitter(args.buf)
	end,
})
