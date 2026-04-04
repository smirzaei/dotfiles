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

require("copilot").setup(copilot_conf)

local ok, blink_copilot = pcall(require, "blink-copilot")
if ok and blink_copilot.setup then
	blink_copilot.setup({})
end
