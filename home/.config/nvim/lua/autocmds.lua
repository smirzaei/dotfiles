-- Highlight yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- resize splits if window got resized
local resize_group = vim.api.nvim_create_augroup("Resize", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
	group = resize_group,
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- show a column at 80 characters as a guide for long lines
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd("Filetype", { pattern = "rust", command = "set colorcolumn=100" })

--  Associate .tpl files with helm
local helmTplGroup = vim.api.nvim_create_augroup("FileTypeHelmTpl", { clear = true })
vim.api.nvim_create_autocmd(
	{ "BufNewFile", "BufRead" },
	{ pattern = "*.tpl", group = helmTplGroup, command = "setlocal filetype=helm" }
)
