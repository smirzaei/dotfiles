{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.ghostty;
in
{
    options.dotfiles.ghostty = {
        enable = lib.mkEnableOption "Ghostty configuration";

        package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = pkgs.ghostty;
            defaultText = lib.literalExpression "pkgs.ghostty";
            description = "Ghostty package to install. Set to null to manage only the config file.";
        };
    };

    config = lib.mkIf cfg.enable {
        home.packages = lib.optional (cfg.package != null) cfg.package;
        xdg.configFile."ghostty/config".source = ../home/.config/ghostty/config;
    };
}
