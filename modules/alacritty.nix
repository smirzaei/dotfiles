{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.alacritty;
in
{
    options.dotfiles.alacritty = {
        enable = lib.mkEnableOption "Alacritty configuration";

        package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = pkgs.alacritty;
            defaultText = lib.literalExpression "pkgs.alacritty";
            description = "Alacritty package to install. Set to null to manage only the config file.";
        };
    };

    config = lib.mkIf cfg.enable {
        home.packages = lib.optional (cfg.package != null) cfg.package;
        xdg.configFile."alacritty/alacritty.toml".source = ../home/.config/alacritty/alacritty.toml;
    };
}
