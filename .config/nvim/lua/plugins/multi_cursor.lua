return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'smoka7/hydra.nvim',
  },
  opts = {},
  keys = {
    {
      '<Leader>d',
      '<cmd>MCstart<cr>',
      desc = 'Create a selection for word under the cursor'
    },
    {
      '<Leader>v',
      '<cmd>MCvisual<cr>',
      desc = 'Create a selection for last visual selection'
    }

  }
}
