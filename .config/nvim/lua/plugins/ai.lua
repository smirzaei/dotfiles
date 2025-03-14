local copilot_conf = {
	suggestion = {
		enabled = false,
		auto_trigger = false,
	},
	panel = { enabled = false },
	filetypes = {
		-- rust = true,
		-- zig = true,
		-- go = true,
		-- lua = true,
		["*"] = true,
	},
}

return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		opts = {
			copilot = {
				-- endpoint = "https://api.githubcopilot.com/",
				model = "claude-3.7-sonnet",
				proxy = nil, -- [protocol://]host[:port] Use this proxy
				allow_insecure = false, -- Allow insecure server connections
				timeout = 30000, -- Timeout in milliseconds
				temperature = 0,
				max_tokens = 8192,
			},
			-- add any opts here
			-- for example
			-- provider = "openai",
			-- openai = {
			--     endpoint = "https://api.openai.com/v1",
			--     model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
			--     timeout = 30000, -- timeout in milliseconds
			--     temperature = 0, -- adjust if needed
			--     max_tokens = 4096,
			--     -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
			-- },
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			{
				"zbirenbaum/copilot-cmp",
				opts = {},
				dependencies = {
					"zbirenbaum/copilot.lua",
					cmd = "Copilot",
					event = "InsertEnter",
					opts = copilot_conf,
				},
			},
			-- {
			--     -- support for image pasting
			--     "HakonHarnes/img-clip.nvim",
			--     event = "VeryLazy",
			--     opts = {
			--         -- recommended settings
			--         default = {
			--             embed_image_as_base64 = false,
			--             prompt_for_file_name = false,
			--             drag_and_drop = {
			--                 insert_mode = true,
			--             },
			--             -- required for Windows users
			--             use_absolute_path = true,
			--         },
			--     },
			-- },
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
