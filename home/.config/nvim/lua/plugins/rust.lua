return {
	"mrcjkb/rustaceanvim",
	lazy = false, -- this plugin is already lazy
	config = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
						check = {
							targets = {
								"x86_64-unknown-linux-gnu",
								"aarch64-apple-darwin",
								"x86_64-pc-windows-msvc",
							},
							command = "clippy",
						},
					},
				},
			},
		}
	end,
}
