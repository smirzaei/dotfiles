{ ... }:
{
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
    };

    # `programs.starship.settings` won't handle escape characters properly
    xdg.configFile."starship.toml".source = ../home/.config/starship.toml;
}
