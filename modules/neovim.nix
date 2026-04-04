{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.neovim;
in
{
    options.dotfiles.neovim = {
        enable = lib.mkEnableOption "Neovim configuration";

        package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = pkgs.neovim;
            defaultText = lib.literalExpression "pkgs.neovim";
            description = "Neovim package to install. Set to null to use a native Neovim binary.";
        };

        strict = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Fail activation if `nvim` is missing from PATH.";
        };

        nativeInstallHint = lib.mkOption {
            type = lib.types.lines;
            default = "Install `nvim` with your system package manager.";
            description = "Hint shown when the Neovim binary is missing.";
        };
    };

    config = lib.mkIf cfg.enable {
        home.packages = lib.optional (cfg.package != null) cfg.package;
        xdg.configFile."nvim".source = ../home/.config/nvim;

        home.activation.checkNeovimBinary = lib.hm.dag.entryAfter [ "installPackages" ] ''
            PATH="${config.home.profileDirectory}/bin:${"$"}PATH"

            if ! command -v nvim >/dev/null 2>&1; then
                echo "Neovim check failed: \`nvim\` was not found in PATH."
                printf '%s\n' ${lib.escapeShellArg cfg.nativeInstallHint}

                ${lib.optionalString (!cfg.strict) ''
                    echo "Continuing because dotfiles.neovim.strict = false"
                ''}

                ${lib.optionalString cfg.strict "exit 1"}
            fi
        '';
    };
}
