local M = {}

local ns = vim.api.nvim_create_namespace("rust_symbol_focus")
local group = vim.api.nvim_create_augroup("rust_symbol_focus", { clear = true })

local dim_hl_group = "RustSymbolFocusDim"
local default_dim_strength = 0.22

local defaults = {
	dim_priority = 210,
	reference_priority = 260,
	request_timeout_ms = 800,
	dim_strength = default_dim_strength,
}

local config = vim.deepcopy(defaults)
local state = {}
local setup_done = false

local function clamp_dim_strength(value)
	if type(value) ~= "number" then
		return defaults.dim_strength
	end

	return math.max(0, math.min(value, 1))
end

local function get_state(bufnr)
	local buf_state = state[bufnr]
	if buf_state then
		return buf_state
	end

	buf_state = { active = false }
	state[bufnr] = buf_state
	return buf_state
end

local function get_hl(name)
	if not name or name == "" or vim.fn.hlexists(name) == 0 then
		return nil
	end

	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if not ok or type(hl) ~= "table" or vim.tbl_isempty(hl) then
		return nil
	end

	return hl
end

local function split_rgb(color)
	if type(color) ~= "number" then
		return nil
	end

	local r = math.floor(color / 65536) % 256
	local g = math.floor(color / 256) % 256
	local b = color % 256
	return r, g, b
end

local function join_rgb(r, g, b)
	return r * 65536 + g * 256 + b
end

local function blend_rgb(left, right, amount)
	local lr, lg, lb = split_rgb(left)
	local rr, rg, rb = split_rgb(right)
	if not lr or not rr then
		return left
	end

	local mix = function(a, b)
		return math.floor((a * (1 - amount)) + (b * amount) + 0.5)
	end

	return join_rgb(mix(lr, rr), mix(lg, rg), mix(lb, rb))
end

local function fallback_bg_color()
	if vim.o.background == "light" then
		return 0xFFFFFF
	end

	return 0x000000
end

local function refresh_dim_highlight()
	local normal = get_hl("Normal") or {}
	local comment = get_hl("@comment") or get_hl("Comment") or {}

	local normal_fg = normal.fg or comment.fg

	if not normal_fg then
		vim.api.nvim_set_hl(0, dim_hl_group, { link = "Comment", nocombine = true })
		return
	end

	local normal_bg = normal.bg or fallback_bg_color()

	vim.api.nvim_set_hl(0, dim_hl_group, {
		fg = blend_rgb(normal_fg, normal_bg, config.dim_strength),
		nocombine = true,
	})
end

local function supports_document_highlight(client, bufnr)
	if client.server_capabilities and client.server_capabilities.documentHighlightProvider then
		return true
	end

	local ok_num, supported_num = pcall(client.supports_method, client, "textDocument/documentHighlight", bufnr)
	if ok_num and supported_num then
		return true
	end

	local ok_tbl, supported_tbl =
		pcall(client.supports_method, client, "textDocument/documentHighlight", { bufnr = bufnr })
	return ok_tbl and supported_tbl
end

local function has_highlight_provider(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if supports_document_highlight(client, bufnr) then
			return true
		end
	end

	return false
end

local function to_byte_col(bufnr, row, col, encoding)
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
	if encoding == "utf-8" then
		return math.max(0, math.min(col, #line))
	end

	local ok, byte_col = pcall(vim.str_byteindex, line, encoding or "utf-16", col, false)
	if not ok then
		return math.max(0, math.min(col, #line))
	end

	return math.max(0, math.min(byte_col, #line))
end

local function get_last_row(range)
	local last_row = range["end"].line
	if range["end"].character == 0 and last_row > range.start.line then
		last_row = last_row - 1
	end

	return last_row
end

local function collect_document_highlights(bufnr)
	local params = vim.lsp.util.make_position_params(0)
	local responses =
		vim.lsp.buf_request_sync(bufnr, "textDocument/documentHighlight", params, config.request_timeout_ms)
	if type(responses) ~= "table" then
		return {}
	end

	local seen = {}
	local items = {}

	for client_id, response in pairs(responses) do
		if type(response) == "table" and type(response.result) == "table" then
			local client = vim.lsp.get_client_by_id(client_id)
			local encoding = client and client.offset_encoding or "utf-16"

			for _, item in ipairs(response.result) do
				local range = item and item.range
				local range_start = range and range.start
				local range_end = range and range["end"]
				if range_start and range_end then
					local key = table.concat({
						range_start.line,
						range_start.character,
						range_end.line,
						range_end.character,
						item.kind or 1,
						encoding,
					}, ":")

					if not seen[key] then
						seen[key] = true
						items[#items + 1] = {
							range = range,
							kind = item.kind,
							encoding = encoding,
						}
					end
				end
			end
		end
	end

	return items
end

local function highlight_group_for_kind(kind)
	local fallback = { "IlluminatedWordText", "IlluminatedWordRead", "Visual" }
	local candidates = fallback
	local highlight_kinds = vim.lsp.protocol.DocumentHighlightKind or {}

	if kind == highlight_kinds.Write then
		candidates = { "IlluminatedWordWrite", "IlluminatedWordRead", "IlluminatedWordText", "Visual" }
	elseif kind == highlight_kinds.Read then
		candidates = { "IlluminatedWordRead", "IlluminatedWordText", "Visual" }
	end

	for _, name in ipairs(candidates) do
		if vim.fn.hlexists(name) == 1 then
			return name
		end
	end

	return "Visual"
end

local function set_focus_state(bufnr, active)
	local buf_state = get_state(bufnr)
	buf_state.active = active
	vim.b[bufnr].rust_symbol_focus_active = active
end

local function set_illuminate_paused(paused)
	local ok, illuminate = pcall(require, "illuminate")
	if ok then
		local fn = paused and illuminate.pause_buf or illuminate.resume_buf
		if type(fn) == "function" then
			local success = pcall(fn)
			if success then
				return
			end
		end
	end

	if paused then
		vim.cmd("silent! IlluminatePauseBuf")
	else
		vim.cmd("silent! IlluminateResumeBuf")
	end
end

local function apply_focus(bufnr, highlights)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local line_count = vim.api.nvim_buf_line_count(bufnr)
	if line_count == 0 then
		return
	end

	local keep_lines = {}
	for _, item in ipairs(highlights) do
		local range = item.range
		local first_row = math.max(0, math.min(range.start.line, line_count - 1))
		local last_row = math.max(0, math.min(get_last_row(range), line_count - 1))

		for row = first_row, last_row do
			keep_lines[row] = true
		end
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	for i, line in ipairs(lines) do
		local row = i - 1
		if not keep_lines[row] and line:find("%S") then
			vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
				end_row = row,
				end_col = #line,
				hl_group = dim_hl_group,
				hl_eol = true,
				priority = config.dim_priority,
				strict = false,
			})
		end
	end

	for _, item in ipairs(highlights) do
		local range = item.range
		local first_row = math.max(0, math.min(range.start.line, line_count - 1))
		local last_row = math.max(0, math.min(range["end"].line, line_count - 1))
		local first_col = to_byte_col(bufnr, first_row, range.start.character, item.encoding)
		local last_col = to_byte_col(bufnr, last_row, range["end"].character, item.encoding)

		if last_row == first_row and last_col <= first_col then
			last_col = math.min(first_col + 1, #(lines[first_row + 1] or ""))
		end

		vim.api.nvim_buf_set_extmark(bufnr, ns, first_row, first_col, {
			end_row = last_row,
			end_col = last_col,
			hl_group = highlight_group_for_kind(item.kind),
			priority = config.reference_priority,
			strict = false,
		})
	end
end

local function cleanup_buffer(bufnr)
	state[bufnr] = nil
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
		vim.b[bufnr].rust_symbol_focus_active = false
	end
end

function M.is_active(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local buf_state = state[bufnr]
	return buf_state ~= nil and buf_state.active == true
end

function M.clear(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	set_focus_state(bufnr, false)

	if bufnr == vim.api.nvim_get_current_buf() then
		pcall(vim.lsp.buf.clear_references)
		set_illuminate_paused(false)
	end
end

function M.focus_symbol(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "rust" then
		return
	end

	if not has_highlight_provider(bufnr) then
		return
	end

	local highlights = collect_document_highlights(bufnr)
	if #highlights == 0 then
		M.clear(bufnr)
		return
	end

	set_focus_state(bufnr, true)
	apply_focus(bufnr, highlights)

	if bufnr == vim.api.nvim_get_current_buf() then
		pcall(vim.lsp.buf.clear_references)
		set_illuminate_paused(true)
	end
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", {}, defaults, opts or {})
	config.dim_strength = clamp_dim_strength(config.dim_strength)

	refresh_dim_highlight()

	if setup_done then
		return
	end

	setup_done = true

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "rust",
		callback = function(args)
			if vim.b[args.buf].rust_symbol_focus_mapped then
				return
			end

			vim.b[args.buf].rust_symbol_focus_mapped = true

			vim.keymap.set("n", "<leader>hv", function()
				M.focus_symbol(args.buf)
			end, {
				buffer = args.buf,
				silent = true,
				desc = "Rust: focus variable usage",
			})

			vim.keymap.set("n", "<Esc>", function()
				if M.is_active(args.buf) then
					M.clear(args.buf)
				end

				vim.cmd("noh")
			end, {
				buffer = args.buf,
				silent = true,
				desc = "Clear search and rust focus",
			})
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		callback = function(args)
			if vim.bo[args.buf].filetype == "rust" then
				M.clear(args.buf)
			end
		end,
	})

	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		callback = function(args)
			cleanup_buffer(args.buf)
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			refresh_dim_highlight()
		end,
	})
end

return M
