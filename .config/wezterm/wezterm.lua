local wezterm = require 'wezterm'

return {
  audible_bell = "Disabled",
  color_scheme = "nordic",
  font = wezterm.font_with_fallback {
    {
      family = "Cascadia Code PL",
      weight = "Bold",
      harfbuzz_features = { "calt=1", "liga=1", "ss01=1", "ss02=1", "ss19=1" },
    },
  },
  font_size = 14.0,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {
      key = "r",
      mods = "CTRL",
      action = wezterm.action.ReloadConfiguration,
    }
  }
}
