{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.opencode;
in
{
    options.dotfiles.opencode = {
        enable = lib.mkEnableOption "opencode TUI configuration";

        package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "opencode package to install. Set to null to manage only the TUI configuration.";
        };
    };

    config = lib.mkIf cfg.enable {
        home.packages = lib.optional (cfg.package != null) cfg.package;
        xdg.configFile."opencode/opencode.json".source = ../home/.config/opencode/opencode.json;
        xdg.configFile."opencode/tui.json".source = ../home/.config/opencode/tui.json;
        xdg.configFile."opencode/themes/soroush.json".source = ../home/.config/opencode/themes/soroush.json;
    };
}
