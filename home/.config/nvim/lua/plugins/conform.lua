vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go", "*.rs", "*.zig", "*.lua", "*.py", "*.js", "*.ts" },
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			go = { "goimports", "gofumpt" },
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	},
	keys = {
		{
			"<leader>fc",
			function()
				require("conform").format({ lsp_format = "fallback" })
			end,
			desc = "[F]ormat [C]ode",
		},
	},
}
