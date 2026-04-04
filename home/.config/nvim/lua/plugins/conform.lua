local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		go = { "goimports", "gofumpt" },
		lua = { "stylua" },
		-- Conform runs multiple formatters sequentially.
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform runs the first available formatter.
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go", "*.rs", "*.zig", "*.lua", "*.py", "*.js", "*.ts" },
	callback = function(args)
		conform.format({ bufnr = args.buf })
	end,
})

vim.keymap.set("n", "<leader>fc", function()
	conform.format({ lsp_format = "fallback" })
end, { desc = "[F]ormat [C]ode" })
