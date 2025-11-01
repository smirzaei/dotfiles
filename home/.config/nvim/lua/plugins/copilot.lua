local copilot_conf = {
	suggestion = { enabled = false },
	panel = { enabled = false },
}

return {
	"fang2hou/blink-copilot",
	opts = {},
	dependencies = {
		"zbirenbaum/copilot.lua",
		opts = copilot_conf,
	},
}
