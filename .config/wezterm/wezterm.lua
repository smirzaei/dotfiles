local wezterm = require 'wezterm'

return {
  default_cursor_style = "SteadyBar",
  audible_bell = "Disabled",
  -- color_scheme = "nordic",
  -- color_scheme = "Everforest Dark (Gogh)",
  -- color_scheme = "GitHub Dark",
  color_scheme = "Gruvbox Material (Gogh)",
  -- color_scheme = "AyuDark (Gogh)",
  font = wezterm.font_with_fallback {
    {
      -- family = "Cascadia Code PL",
      family = "CaskaydiaCove Nerd Font",
      weight = "Bold",
      harfbuzz_features = { "calt=1", "liga=1", "ss02=1", "ss19=1" },
      -- harfbuzz_features = { "calt=1", "liga=1", "ss01=1", "ss02=1", "ss19=1" },
    },
  },
  font_size = 14.0,
  hide_tab_bar_if_only_one_tab = true,
}
