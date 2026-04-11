local lspconfig = vim.deepcopy(vim.lsp.config.rust_analyzer or {})

require("lang.rust_clone_analysis").setup({})
require("lang.rust_symbol_focus").setup({})

local targets = {
	linux = "x86_64-unknown-linux-gnu",
	macos = "aarch64-apple-darwin",
	windows = "x86_64-pc-windows-msvc",
}

local default_on_attach = lspconfig.on_attach
local on_attach = function(client, bufnr)
	if default_on_attach then
		default_on_attach(client, bufnr)
	end

	-- Usage: :RustTarget {linux|macos|windows}
	vim.api.nvim_create_user_command("RustTarget", function(opts)
		local platform = opts.args
		local target_triple = targets[platform]
		if target_triple == nil then
			vim.notify("Invalid platform: " .. platform, vim.log.levels.ERROR)
			return
		end
		vim.notify("Switching Rust target to " .. target_triple, vim.log.levels.INFO)
		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					cargo = {
						target = target_triple,
					},
				},
			},
		})

		vim.cmd("LspRestart rust_analyzer")
	end, {
		nargs = 1,
		complete = function()
			return { "linux", "macos", "windows" }
		end,
	})
end

lspconfig.on_attach = on_attach

vim.lsp.config("rust_analyzer", lspconfig)
vim.lsp.enable("rust_analyzer")
