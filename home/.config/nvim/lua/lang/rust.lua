local default_lsp_cfg_path = vim.api.nvim_get_runtime_file("lsp/rust_analyzer.lua", false)[1]
if not default_lsp_cfg_path then
	vim.notify("Default Rust Analyzer config not found", vim.log.levels.ERROR)
	return
end

local chunk, err = loadfile(default_lsp_cfg_path)
if not chunk then
	vim.notify("Failed to load default Rust Analyzer config: " .. err, vim.log.levels.ERROR)
	return
end

local success, lspconfig = pcall(chunk)
if not success then
	vim.notify("Error executing Rust Analyzer config: " .. lspconfig, vim.log.levels.ERROR)
	return
end

local targets = {
	linux = "x86_64-unknown-linux-gnu",
	macos = "aarch64-apple-darwin",
	windows = "x86_64-pc-windows-msvc",
}

local default_on_attach = lspconfig.on_attach
local on_attach = function(client, bufnr)
	vim.print("Rust Analyzer attached")
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
		vim.notify("Target switched", vim.log.levels.INFO)
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
