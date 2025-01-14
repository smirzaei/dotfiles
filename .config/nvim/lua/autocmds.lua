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

-- Hide line numbers in terminal
local term_group = vim.api.nvim_create_augroup("Terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.print(vim.env.SHELL)
  end,
})

-- show a column at 80 characters as a guide for long lines
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd("Filetype", { pattern = "rust", command = "set colorcolumn=100" })
