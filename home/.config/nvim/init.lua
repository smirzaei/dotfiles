require("options")
require("keybindings")
require("diagnostics")
require("autocmds")
require("bracket_escape")
require("init_lazy")
require("lsp")

require("lazy").setup({
	import = "plugins",
}, {
	lockfile = vim.fn.stdpath("data") .. "/lazy/lazy-lock.json",
})

-- Language specific
require("lang.lua")
require("lang.rust")
require("lang.nix")
require("lang.yaml")
require("lang.bash")
require("lang.go")
require("lang.helm")

local colorscheme = require("colorscheme")
colorscheme.apply()

-- Custom Commands
local function format_then_write()
	vim.cmd.Format()
	vim.cmd.write()
end

vim.api.nvim_create_user_command("FW", format_then_write, {})
