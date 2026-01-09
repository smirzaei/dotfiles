local copilot_conf = {
	suggestion = {
		enabled = true,
		auto_trigger = false,
	},
	panel = { enabled = false },
	filetypes = {
		["*"] = true,
	},
	nes = {
		enabled = false,
		auto_trigger = false,
	},
}

return {
	"fang2hou/blink-copilot",
	opts = {},
	dependencies = {
		{
			"zbirenbaum/copilot.lua",
			opts = copilot_conf,
			-- dependencies = {
			-- 	"copilotlsp-nvim/copilot-lsp",
			-- 	init = function()
			-- 		vim.g.copilot_nes_debounce = 500
			-- 		-- Enable copilot_ls only for configured filetypes
			-- 		vim.api.nvim_create_autocmd("FileType", {
			-- 			pattern = { "lua", "go", "rust", "nix" },
			-- 			callback = function()
			-- 				vim.lsp.enable("copilot_ls")
			-- 			end,
			-- 		})
			--
			-- 		vim.keymap.set("n", "<tab>", function()
			-- 			local bufnr = vim.api.nvim_get_current_buf()
			-- 			local state = vim.b[bufnr].nes_state
			-- 			if state then
			-- 				-- Try to jump to the start of the suggestion edit.
			-- 				-- If already at the start, then apply the pending suggestion and jump to the end of the edit.
			-- 				local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
			-- 					or (
			-- 						require("copilot-lsp.nes").apply_pending_nes()
			-- 						and require("copilot-lsp.nes").walk_cursor_end_edit()
			-- 					)
			-- 				return nil
			-- 			else
			-- 				-- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
			-- 				return "<C-i>"
			-- 			end
			-- 		end, { desc = "Accept Copilot NES suggestion", expr = true })
			--
			-- 		-- Clear copilot suggestion with Esc if visible
			-- 		vim.keymap.set("n", "<esc>", function()
			-- 			require("copilot-lsp.nes").clear()
			-- 		end, { desc = "Clear Copilot suggestion or fallback" })
			--
			-- 		-- Manual trigger for Copilot suggestions (since auto_trigger is false)
			-- 		vim.keymap.set("i", "<M-\\>", function()
			-- 			require("copilot.suggestion").next()
			-- 		end, { desc = "Trigger Copilot suggestion" })
			-- 	end,
			-- },
		},
	},
}
