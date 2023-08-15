return {
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    "norcalli/nvim-colorizer.lua",
    opts = {
      'css',
      'javascript',
      'html',
      'lua',
    }
  },
}
