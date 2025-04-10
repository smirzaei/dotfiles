require("options")
require("keybindings")
require("autocmds")
require("bracket_escape")
require("init_lazy")

require("lazy").setup({
	{ import = "plugins" },
})

-- Playing around with colorscheme and Lush
require("colorscheme")

-- Custom Commands
local function format_then_write()
	vim.cmd.Format()
	vim.cmd.write()
end

vim.api.nvim_create_user_command("FW", format_then_write, {})
