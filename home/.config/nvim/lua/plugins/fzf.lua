local fzf = require("fzf-lua")

fzf.register_ui_select()

-- Disable window navigation keymaps while fzf's terminal UI is focused.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "fzf",
	callback = function()
		local opts = { buffer = true, nowait = true }

		vim.keymap.set("t", "<C-h>", "<Nop>", opts)
		vim.keymap.set("t", "<C-j>", "<Nop>", opts)
		vim.keymap.set("t", "<C-k>", "<Nop>", opts)
		vim.keymap.set("t", "<C-l>", "<Nop>", opts)
	end,
})

local map = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { desc = desc })
end

map("<leader><leader>", fzf.global, "Open global search")
map("<leader>sB", fzf.builtin, "[S]earch [B]uiltin fzf functions")
map("<leader>sf", fzf.files, "[S]earch [f]iles in the current project")
map("<leader>sg", fzf.live_grep, "[S]earch by [g]repping in the current project")
map("<leader>sw", fzf.grep_cword, "[S]earch by grepping the current [w]ord under the cursor")
map("<leader>sW", fzf.grep_cWORD, "[S]earch by grepping the current [W]ORD under the cursor")
map("<leader>sr", fzf.resume, "[S]earch [r]esume")
map("<leader>so", fzf.oldfiles, "[S]earch [o]ld files (history)")
map("<leader>sdb", fzf.diagnostics_document, "[S]earch [d]iagnostics for the current [b]uffer")
map("<leader>sdw", fzf.diagnostics_workspace, "[S]earch [d]iagnostics for [w]orkspace")
map("<leader>/", fzf.lgrep_curbuf, "[/] Live grep the current buffer")

-- Git
map("<leader>gs", fzf.git_status, "Show [g]it [s]tatus")
map("<leader>gb", fzf.git_branches, "Show [g]it [b]ranches")
map("<leader>gpc", fzf.git_commits, "Show [g]it [p]roject [c]ommits")
map("<leader>gu", fzf.git_bcommits, "Show [g]it b[u]ffer commits")
map("<leader>gl", fzf.git_blame, "Show [g]it [b]lame")

-- Neovim config
map("<leader>sh", fzf.helptags, "[S]earch in [h]elp")
map("<leader>sk", fzf.keymaps, "[S]earch [k]eymaps")
map("<leader>snc", function()
	fzf.files({ cwd = vim.fn.stdpath("config") })
end, "[S]earch [n]eovim [c]onfig files")
map("<leader>cs", fzf.colorschemes, "[C]olor [S]chemes")
