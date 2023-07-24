local conf = {
  options = {
    themeable = true,
    indicator = {
      style = 'underline',
    },
    diagnostics = 'nvim_lsp',
    show_buffer_icons = true,
    show_tab_indicators = true,
    separator_style = 'slant',
  }

}


return {
  {
    {
      'akinsho/bufferline.nvim',
      dependencies = 'nvim-tree/nvim-web-devicons',
      opts = conf,
    },
  }
}
