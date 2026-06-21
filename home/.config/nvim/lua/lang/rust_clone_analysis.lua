local M = {}

local ns = vim.api.nvim_create_namespace("rust_clone_analysis")
local group = vim.api.nvim_create_augroup("rust_clone_analysis", { clear = true })

local ok_query, query = pcall(vim.treesitter.query.parse, "rust", [[
((call_expression
   function: (field_expression
     value: (_) @field.receiver
     field: (field_identifier) @field.clone))
 (#eq? @field.clone "clone"))

((call_expression
   function: (scoped_identifier
     path: (_) @scoped.path
     name: (identifier) @scoped.clone))
 (#eq? @scoped.clone "clone"))
]])

if not ok_query then
	query = nil
end

local capture = {}
if query then
	for id, name in ipairs(query.captures) do
		capture[name] = id
	end
end

local default_cheap_clone_types = {
	"alloc::sync::Arc",
	"alloc::rc::Rc",
	"std::sync::Arc",
	"std::rc::Rc",
	"alloc::sync::Weak",
	"alloc::rc::Weak",
	"std::sync::Weak",
	"std::rc::Weak",
	"std::sync::mpsc::Sender",
	"std::sync::mpsc::SyncSender",
	"std::task::Waker",
	"core::task::Waker",
	"std::thread::Thread",
	"bytes::Bytes",
	"bytes::bytes::Bytes",
	"crossbeam_channel::Sender",
	"crossbeam_channel::Receiver",
	"crossbeam_deque::Stealer",
	"crossbeam_epoch::Collector",
	"crossbeam_utils::sync::WaitGroup",
	"crossbeam::channel::Sender",
	"crossbeam::channel::Receiver",
	"crossbeam::deque::Stealer",
	"crossbeam::epoch::Collector",
	"crossbeam::sync::WaitGroup",
	"tokio::runtime::Handle",
	"tokio::sync::mpsc::Sender",
	"tokio::sync::mpsc::UnboundedSender",
	"tokio::sync::mpsc::WeakSender",
	"tokio::sync::mpsc::WeakUnboundedSender",
	"tokio::sync::broadcast::Sender",
	"tokio::sync::broadcast::WeakSender",
	"tokio::sync::watch::Sender",
	"tokio::sync::watch::Receiver",
	"tokio_util::sync::CancellationToken",
	"sqlx::Pool",
	"sqlx::PgPool",
	"tonic::transport::Channel",
	"tonic::transport::channel::Channel",
}

local defaults = {
	cheap_clone_types = default_cheap_clone_types,
	neutral_hl_group = "@function.method.call",
	highlight_priority = 300,
	max_pending_requests = 12,
	debounce_ms = 120,
}

local config = vim.deepcopy(defaults)
local neutral_overlay_hl = "RustCloneAnalysisNeutral"
local lookup = { exact = {}, suffix = {}, leaf = {} }
local state = {}
local setup_done = false

local function rebuild_lookup()
	lookup.exact = {}
	lookup.suffix = {}
	lookup.leaf = {}

	for _, item in ipairs(config.cheap_clone_types) do
		local name = (item or ""):gsub("%s+", ""):gsub("^::", "")
		if name ~= "" then
			lookup.exact[name] = true

			local parts = vim.split(name, "::", { plain = true, trimempty = true })
			if #parts > 0 then
				lookup.leaf[parts[#parts]] = true
			end

			if #parts > 1 then
				for i = 2, #parts do
					lookup.suffix[table.concat(parts, "::", i)] = true
				end
			end
		end
	end
end

local function first_node(entry)
	if type(entry) == "table" then
		return entry[1]
	end

	return entry
end

local function normalize(text)
	return (text or ""):gsub("%s+", "")
end

local function strip_generics(text)
	local depth = 0
	local out = {}

	for i = 1, #text do
		local ch = text:sub(i, i)
		if ch == "<" then
			depth = depth + 1
		elseif ch == ">" then
			if depth > 0 then
				depth = depth - 1
			else
				out[#out + 1] = ch
			end
		elseif depth == 0 then
			out[#out + 1] = ch
		end
	end

	return table.concat(out)
end

local function is_cheap_type_path(type_path)
	local path = strip_generics(normalize(type_path))
	path = path:gsub("^::", "")

	if path == "" then
		return false
	end

	if lookup.exact[path] or lookup.suffix[path] then
		return true
	end

	local leaf = path:match("([^:]+)$")
	return leaf ~= nil and lookup.leaf[leaf] == true
end

local function hover_contents_to_text(contents)
	if type(contents) == "string" then
		return contents
	end

	if type(contents) ~= "table" then
		return ""
	end

	if contents.value and type(contents.value) == "string" then
		return contents.value
	end

	local pieces = {}
	for _, item in ipairs(contents) do
		pieces[#pieces + 1] = hover_contents_to_text(item)
	end

	return table.concat(pieces, "\n")
end

local function is_cheap_hover_result(result)
	if type(result) ~= "table" or result.contents == nil then
		return nil
	end

	local text = strip_generics(normalize(hover_contents_to_text(result.contents)))
	if text == "" then
		return nil
	end

	for token in text:gmatch("[A-Za-z_][A-Za-z0-9_:]*") do
		if is_cheap_type_path(token) then
			return true
		end
	end

	return false
end

local function get_state(bufnr)
	local buf_state = state[bufnr]
	if buf_state then
		return buf_state
	end

	buf_state = {
		attached = false,
		cache = {},
		pending = {},
		pending_count = 0,
		tick = -1,
		version = 0,
		timer = nil,
	}

	state[bufnr] = buf_state
	return buf_state
end

local function stop_timer(buf_state)
	if not buf_state.timer then
		return
	end

	pcall(buf_state.timer.stop, buf_state.timer)
	pcall(buf_state.timer.close, buf_state.timer)
	buf_state.timer = nil
end

local function cleanup_buffer(bufnr)
	local buf_state = state[bufnr]
	if not buf_state then
		return
	end

	stop_timer(buf_state)
	state[bufnr] = nil
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	pcall(vim.api.nvim_del_augroup_by_name, "rust_clone_analysis_" .. bufnr)
end

local function get_hl_definition(name)
	if not name or name == "" or vim.fn.hlexists(name) == 0 then
		return nil
	end

	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
	if not ok or type(hl) ~= "table" or vim.tbl_isempty(hl) then
		return nil
	end

	return hl
end

local function refresh_neutral_hl()
	local hl = get_hl_definition(config.neutral_hl_group)
		or get_hl_definition("@function.call")
		or get_hl_definition("Function")
		or get_hl_definition("Normal")
		or {}

	hl.nocombine = true
	hl.reverse = false
	hl.bold = false
	hl.italic = false
	hl.underline = false
	hl.undercurl = false
	hl.strikethrough = false
	hl.standout = false

	vim.api.nvim_set_hl(0, neutral_overlay_hl, hl)
end

local function set_neutral_highlight(bufnr, range)
	if vim.fn.hlexists(neutral_overlay_hl) == 0 then
		refresh_neutral_hl()
	end

	vim.api.nvim_buf_set_extmark(bufnr, ns, range[1], range[2], {
		end_row = range[3],
		end_col = range[4],
		hl_group = neutral_overlay_hl,
		hl_mode = "replace",
		priority = config.highlight_priority,
	})
end

local function get_visible_range(bufnr)
	local wins = vim.fn.win_findbuf(bufnr)
	if #wins == 0 then
		return nil, nil
	end

	local min_row = nil
	local max_row = nil

	for _, win in ipairs(wins) do
		local top = vim.fn.line("w0", win) - 1
		local bottom = vim.fn.line("w$", win)
		if min_row == nil or top < min_row then
			min_row = top
		end
		if max_row == nil or bottom > max_row then
			max_row = bottom
		end
	end

	return min_row, max_row
end

local function supports_hover(client, bufnr)
	if client.server_capabilities and client.server_capabilities.hoverProvider then
		return true
	end

	local ok_num, supported_num = pcall(client.supports_method, client, "textDocument/hover", bufnr)
	if ok_num and supported_num then
		return true
	end

	local ok_tbl, supported_tbl = pcall(client.supports_method, client, "textDocument/hover", { bufnr = bufnr })
	return ok_tbl and supported_tbl
end

local function get_hover_client(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
	for _, client in ipairs(clients) do
		if supports_hover(client, bufnr) then
			return client
		end
	end

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if supports_hover(client, bufnr) then
			return client
		end
	end

	return nil
end

local function to_utf16_col(bufnr, row, byte_col)
	local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
	local col = math.max(0, math.min(byte_col, #line))
	local _, utf16_col = vim.str_utfindex(line, col)
	return utf16_col
end

local function request_hover(bufnr, receiver_node, callback)
	local client = get_hover_client(bufnr)
	if not client then
		return false
	end

	local _, _, end_row, end_col = receiver_node:range()
	local row = end_row
	local col = math.max(end_col - 1, 0)

	local params = {
		textDocument = vim.lsp.util.make_text_document_params(bufnr),
		position = {
			line = row,
			character = to_utf16_col(bufnr, row, col),
		},
	}

	local ok = client:request("textDocument/hover", params, function(err, result)
		if err then
			callback(nil)
			return
		end

		callback(is_cheap_hover_result(result))
	end, bufnr)

	return ok
end

local function refresh(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "rust" then
		return
	end

	if not query then
		return
	end

	local start_row, end_row = get_visible_range(bufnr)
	if not start_row or not end_row then
		return
	end

	local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr, "rust")
	if not ok_parser then
		return
	end

	local trees = parser:parse()
	if not trees or not trees[1] then
		return
	end

	local root = trees[1]:root()
	local buf_state = get_state(bufnr)
	local tick = vim.api.nvim_buf_get_changedtick(bufnr)
	if buf_state.tick ~= tick then
		buf_state.tick = tick
		buf_state.version = buf_state.version + 1
		buf_state.cache = {}
		buf_state.pending = {}
		buf_state.pending_count = 0
	end

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	for _, match in query:iter_matches(root, bufnr, start_row, end_row + 1) do
		local scoped_clone = first_node(match[capture["scoped.clone"]])
		if scoped_clone then
			local path_node = first_node(match[capture["scoped.path"]])
			if path_node and is_cheap_type_path(vim.treesitter.get_node_text(path_node, bufnr)) then
				set_neutral_highlight(bufnr, { scoped_clone:range() })
			end
		else
			local field_clone = first_node(match[capture["field.clone"]])
			if field_clone then
				local range = { field_clone:range() }
				local key = table.concat(range, ":")
				local cached = buf_state.cache[key]

				if cached == true then
					set_neutral_highlight(bufnr, range)
				elseif cached == nil and not buf_state.pending[key] and buf_state.pending_count < config.max_pending_requests then
					local receiver = first_node(match[capture["field.receiver"]])
					if receiver then
						local version = buf_state.version
						local requested = request_hover(bufnr, receiver, function(is_cheap)
							local current = state[bufnr]
							if not current or current.version ~= version then
								return
							end

							if current.pending[key] then
								current.pending[key] = nil
								current.pending_count = math.max(current.pending_count - 1, 0)
							end

							if is_cheap == nil then
								return
							end

							current.cache[key] = is_cheap
							if is_cheap and vim.api.nvim_buf_is_valid(bufnr) then
								set_neutral_highlight(bufnr, range)
							end
						end)

						if requested then
							buf_state.pending[key] = true
							buf_state.pending_count = buf_state.pending_count + 1
						end
					end
				end
			end
		end
	end
end

local function schedule_refresh(bufnr, delay_ms)
	local buf_state = get_state(bufnr)
	stop_timer(buf_state)

	local timer = vim.uv.new_timer()
	buf_state.timer = timer
	timer:start(delay_ms or config.debounce_ms, 0, vim.schedule_wrap(function()
		if buf_state.timer == timer then
			buf_state.timer = nil
		end
		pcall(timer.close, timer)
		refresh(bufnr)
	end))
end

local function attach_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "rust" then
		return
	end

	local buf_state = get_state(bufnr)
	if buf_state.attached then
		return
	end

	buf_state.attached = true

	local buf_group = vim.api.nvim_create_augroup("rust_clone_analysis_" .. bufnr, { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave", "TextChanged" }, {
		group = buf_group,
		buffer = bufnr,
		callback = function()
			schedule_refresh(bufnr)
		end,
	})

	vim.api.nvim_create_autocmd("BufWipeout", {
		group = buf_group,
		buffer = bufnr,
		callback = function()
			cleanup_buffer(bufnr)
		end,
	})

	schedule_refresh(bufnr, 0)
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", {}, defaults, opts or {})
	rebuild_lookup()
	refresh_neutral_hl()

	if setup_done then
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "rust" then
				schedule_refresh(bufnr, 0)
			end
		end
		return
	end

	setup_done = true

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "rust",
		callback = function(args)
			attach_buffer(args.buf)
		end,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = group,
		callback = function(args)
			if vim.bo[args.buf].filetype == "rust" then
				attach_buffer(args.buf)
				schedule_refresh(args.buf, 0)
			end
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			refresh_neutral_hl()
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "rust" then
					schedule_refresh(bufnr, 0)
				end
			end
		end,
	})

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "rust" then
			attach_buffer(bufnr)
		end
	end
end

return M
