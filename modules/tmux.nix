{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.tmux;
in
{
    options.dotfiles.tmux = {
        enable = lib.mkEnableOption "tmux configuration";

        package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = pkgs.tmux;
            defaultText = lib.literalExpression "pkgs.tmux";
            description = "tmux package to install. Set to null to manage only the config file.";
        };
    };

    config = lib.mkIf cfg.enable {
        home.packages = lib.optional (cfg.package != null) cfg.package;
        xdg.configFile."tmux/tmux.conf".source = ../home/.config/tmux/tmux.conf;
    };
}
