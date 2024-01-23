return {
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      show_end_of_line = true,
      show_current_context_start = true,
      show_current_context = true,
      indent_blankline_show_current_context = true,
      indent_blankline_use_treesitter_scope = true,
      indent_blankline_use_treesitter = true,
    },
    config = function ()
      vim.cmd([[highlight IndentBlanklineContextStart guisp=#8FBCBB gui=underline]])
    end
  },
  {
    'Darazaki/indent-o-matic',
    opts = {
      max_lines = 1024,
      standard_widths = { 2, 4 },
      skip_multiline = true,
    }
  },
}
