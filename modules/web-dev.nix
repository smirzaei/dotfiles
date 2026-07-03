{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.webDev;
in
{
    options.dotfiles.webDev = {
        enable = lib.mkEnableOption "web development tooling";
    };

    config = lib.mkIf cfg.enable {
        dotfiles.lspTools.nixPkgs = [
            "tailwindcss-language-server"
            "vscode-langservers-extracted"
            "vtsls"
        ];

        home.packages = [
            pkgs.tailwindcss_4
        ];
    };
}
