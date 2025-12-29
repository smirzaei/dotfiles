require("options")
require("keybindings")
require("diagnostics")
require("autocmds")
require("bracket_escape")
require("init_lazy")

require("lazy").setup({
	{ import = "plugins" },
})

-- Language specific
require("lang.lua")

local colorscheme = require("colorscheme")
colorscheme.apply()

-- Custom Commands
local function format_then_write()
	vim.cmd.Format()
	vim.cmd.write()
end

vim.api.nvim_create_user_command("FW", format_then_write, {})
