vim.api.nvim_create_autocmd('BufEnter', {
  callback = function ()
    -- Disable auto: comment on new line
    vim.opt_local.formatoptions:remove({ 'r', 'o' })

    vim.opt.laststatus = 3  -- show a global status line
  end
})


vim.opt.completeopt = "menu,menuone,preview,noselect"
vim.opt.confirm = true -- confirm before exit
vim.opt.cursorline = true -- highlight the current line
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.formatoptions = "tcqnljp" -- text format and line breaks. see :h formatoptions
vim.opt.grepprg = "rg --vimgrep" -- use ripgrep
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.laststatus = 3  -- show a global status line
vim.list = false -- Don't show hidden characters
vim.opt.mouse = "" -- disable mouse
vim.opt.number = true -- Show line numbers
vim.opt.pumblend = 0 -- popup transparency 0-100
vim.opt.pumheight = 12 -- limit popup height
vim.opt.relativenumber = true
vim.opt.scrolloff = 15 -- how many lines to keep above and below the cursor
vim.opt.shiftround = true -- round indent to multiple of shiftwidth
vim.opt.shiftwidth = 4 -- number of spaces for indent
vim.opt.shortmess:append({x = true})
vim.opt.showmode = false -- we use a status line
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true -- don't ignore case with capitals
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.spelllang = "en_us"
vim.opt.splitbelow = true -- put new splits below the current
vim.opt.splitright = true -- put new splits to the right of the current
vim.opt.tabstop = 4 -- number of spaces for each tab
vim.opt.termguicolors = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = false -- disable line wrap
vim.opt.smoothscroll = true -- available in neovim 0.10
vim.opt.colorcolumn = "80,100"
vim.opt.vb = true -- don't make the terminal beep

-- "borrowed from https://github.com/jonhoo/configs/blob/475d6cfa5caf4cab910c74023a16b11f582bd3df/editor/.config/nvim/init.lua"
-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append('iwhite')
--- and using a smarter algorithm
--- https://vimways.org/2018/the-power-of-diff/
--- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
--- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')
-- show a column at 80 characters as a guide for long lines
--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
