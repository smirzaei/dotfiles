{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.zed;
in
{
    options.dotfiles.zed = {
        enable = lib.mkEnableOption "Zed keymap configuration";

        package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Zed package to install. Set to null to manage only the keymap file.";
        };
    };

    config = lib.mkIf cfg.enable {
        home.packages = lib.optional (cfg.package != null) cfg.package;
        xdg.configFile."zed/keymap.json".source = ../home/.config/zed/keymap.json;
    };
}
