local targets = {
	linux = "x86_64-unknown-linux-gnu",
	macos = "aarch64-apple-darwin",
	windows = "x86_64-pc-windows-msvc",
}

local function set_rust_target(platform)
	local target_triple = targets[platform]
	if target_triple == nil then
		vim.notify("Invalid platform: " .. platform, vim.log.levels.ERROR)
		return
	end

	local cmd = string.format(
		"RustAnalyzer config { cargo = { target = '%s' }, check = { targets = { '%s' } } }",
		target_triple,
		target_triple
	)
	vim.cmd(cmd)

	vim.notify("Switching Rust target to " .. target_triple, vim.log.levels.INFO)
	vim.cmd("RustAnalyzer restart")
end

-- Usage: :RustTarget {linux|macos|windows}
vim.api.nvim_create_user_command("RustTarget", function(opts)
	set_rust_target(opts.args)
end, {
	nargs = 1,
	complete = function()
		return { "linux", "macos", "windows" }
	end,
})
