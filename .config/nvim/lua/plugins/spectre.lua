return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function ()
      vim.keymap.set('n', '<leader>fo', '<cmd>lua require("spectre").toggle()<CR>', {
        desc = "[F]ind and replace t[o]ggle (Spectre)"
      })
      vim.keymap.set('n', '<leader>fw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "[F]ind and replace current [w]ord"
      })
      vim.keymap.set('v', '<leader>fw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = "[F]ind and replace current [w]ord"
      })
      vim.keymap.set('n', '<leader>ff', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        desc = "[F]ind and replace on current [f]ile"
      })
    end
  }
}
