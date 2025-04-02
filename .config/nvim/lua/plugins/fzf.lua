return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	dependencies = { "echasnovski/mini.icons" },
	opts = {},
	-- TODO: Add more commands for LSP related searches. Like Search symbols, etc.
	keys = {
		{
			"<leader><leader>",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Find existing buffers",
		},
		{
			"<leader>sB",
			function()
				require("fzf-lua").builtin()
			end,
			desc = "[S]earch [B]uiltin fzf functions",
		},
		{
			"<leader>sf",
			function()
				require("fzf-lua").files()
			end,
			desc = "[S]earch [f]iles in the current project",
		},
		{
			"<leader>sg",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "[S]earch by [g]repping in the current project",
		},
		{
			"<leader>sw",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "[S]earch by grepping the current [w]ord under the cursor",
		},
		{
			"<leader>sW",
			function()
				require("fzf-lua").grep_cWORD()
			end,
			desc = "[S]earch by grepping the current [W]ORD under the cursor",
		},
		{
			"<leader>sr",
			function()
				require("fzf-lua").resume()
			end,
			desc = "[S]earch [r]esume",
		},
		{
			"<leader>so",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "[S]earch [o]ld files (history)",
		},
		{
			"<leader>/",
			function()
				require("fzf-lua").lgrep_curbuf()
			end,
			desc = "[/] Live grep the current buffer",
		},
		-- Git
		{
			"<leader>gs",
			function()
				require("fzf-lua").git_status()
			end,
			desc = "Show [g]it [s]tatus",
		},
		{
			"<leader>gb",
			function()
				require("fzf-lua").git_branches()
			end,
			desc = "Show [g]it [b]ranches",
		},
		{
			"<leader>gpc",
			function()
				require("fzf-lua").git_commits()
			end,
			desc = "Show [g]it [p]roject [c]ommits",
		},
		{
			"<leader>gu",
			function()
				require("fzf-lua").git_bcommits()
			end,
			desc = "Show [g]it b[u]ffer commits",
		},
		{
			"<leader>gl",
			function()
				require("fzf-lua").git_blame()
			end,
			desc = "Show [g]it [b]lame",
		},
		-- Neovim Config
		{
			"<leader>sh",
			function()
				require("fzf-lua").helptags()
			end,
			desc = "[S]earch in [h]elp",
		},
		{
			"<leader>sk",
			function()
				require("fzf-lua").keymaps()
			end,
			desc = "[S]earch [k]eymaps",
		},
		{
			"<leader>snc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [n]eovim [c]onfig files",
		},
	},
}
