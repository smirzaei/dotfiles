vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-highlight-group", {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.supports_method("textDocument/documentHighlight", args.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			-- Highlight references when cursor holds still
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = args.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			-- Clear highlights when cursor moves
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = args.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- Clear highlights when LSP detaches
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event.buf })
				end,
			})

			-- Inside LspAttach
			if client.supports_method("textDocument/codeLens", args.buf) then
				vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
					buffer = args.buf,
					callback = vim.lsp.codelens.refresh,
				})
			end
		end
	end,
})
