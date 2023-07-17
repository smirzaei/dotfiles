local builtin = require("telescope.builtin")

require("telescope").setup({

})

local opts = {}

-- Telescope
vim.keymap.set("n", "<C-p>", builtin.find_files, opts)
vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
vim.keymap.set("n", "<leader>gs", builtin.grep_string, opts)
vim.keymap.set("n", "<leader>lg", builtin.live_grep, opts)

