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

		local rust_analyzer_clients = vim.lsp.get_clients({ name = "rust_analyzer" })
		if #rust_analyzer_clients > 0 then
			vim.lsp.enable("rust_analyzer", false)
			vim.lsp.enable("rust_analyzer")
		end
	end, {
		nargs = 1,
		complete = function()
			return { "linux", "macos", "windows" }
		end,
	})

	-- Usage: :RustEnableFeature {feature}
	vim.api.nvim_create_user_command("RustEnableFeature", function(opts)
		local feature = vim.trim(opts.args)
		if feature == "" then
			vim.notify("Feature name is required", vim.log.levels.ERROR)
			return
		end

		local rust_analyzer = vim.lsp.config.rust_analyzer or {}
		local existing_features = vim.tbl_get(rust_analyzer, "settings", "rust-analyzer", "cargo", "features")
		if existing_features == "all" then
			vim.notify("All Rust features are already enabled", vim.log.levels.INFO)

			local rust_analyzer_clients = vim.lsp.get_clients({ name = "rust_analyzer" })
			if #rust_analyzer_clients > 0 then
				vim.lsp.enable("rust_analyzer", false)
				vim.lsp.enable("rust_analyzer")
			end

			return
		end

		local features
		local already_enabled = false
		if feature == "all" then
			features = "all"
		else
			features = {}
			if type(existing_features) == "table" then
				features = vim.deepcopy(existing_features)
			end

			for _, enabled in ipairs(features) do
				if enabled == feature then
					already_enabled = true
					break
				end
			end

			if not already_enabled then
				features[#features + 1] = feature
			end
		end

		if already_enabled then
			vim.notify("Rust feature already enabled: " .. feature, vim.log.levels.INFO)
		else
			vim.notify("Enabling Rust feature: " .. feature, vim.log.levels.INFO)
		end

		vim.lsp.config("rust_analyzer", {
			settings = {
				["rust-analyzer"] = {
					cargo = {
						features = features,
					},
				},
			},
		})

		local rust_analyzer_clients = vim.lsp.get_clients({ name = "rust_analyzer" })
		if #rust_analyzer_clients > 0 then
			vim.lsp.enable("rust_analyzer", false)
			vim.lsp.enable("rust_analyzer")
		end
	end, {
		nargs = 1,
		complete = function()
			return { "all" }
		end,
	})
end

lspconfig.on_attach = on_attach

vim.lsp.config("rust_analyzer", lspconfig)
vim.lsp.enable("rust_analyzer")
