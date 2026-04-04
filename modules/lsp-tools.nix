{ config, lib, pkgs, ... }:

let
    cfg = config.dotfiles.lspTools;

    pkgCatalog = {
        "bash-language-server" = {
            package = pkgs.bash-language-server;
            binary = "bash-language-server";
        };
        "copilot-language-server" = {
            package = pkgs.copilot-language-server;
            binary = "copilot-language-server";
        };
        "golangci-lint" = {
            package = pkgs.golangci-lint;
            binary = "golangci-lint";
        };
        "golangci-lint-langserver" = {
            package = pkgs.golangci-lint-langserver;
            binary = "golangci-lint-langserver";
        };
        gopls = {
            package = pkgs.gopls;
            binary = "gopls";
        };
        "helm-ls" = {
            package = pkgs.helm-ls;
            binary = "helm_ls";
        };
        "lua-language-server" = {
            package = pkgs.lua-language-server;
            binary = "lua-language-server";
        };
        nil = {
            package = pkgs.nil;
            binary = "nil";
        };
        "tree-sitter-cli" = {
            package = pkgs.tree-sitter;
            binary = "tree-sitter";
        };
        "yaml-language-server" = {
            package = pkgs.yaml-language-server;
            binary = "yaml-language-server";
        };
    };

    nixPkgs = lib.unique cfg.nixPkgs;
    nativePkgs = lib.unique cfg.nativePkgs;
    allPkgs = lib.unique (nixPkgs ++ nativePkgs);

    unknownNixPkgs = builtins.filter (name: !(builtins.hasAttr name pkgCatalog)) nixPkgs;
    unknownNativePkgs = builtins.filter (name: !(builtins.hasAttr name pkgCatalog)) nativePkgs;

    knownNixPkgs = builtins.filter (name: builtins.hasAttr name pkgCatalog) nixPkgs;
    knownAllPkgs = builtins.filter (name: builtins.hasAttr name pkgCatalog) allPkgs;

    nixManagedToolPackages = builtins.map (name: pkgCatalog.${name}.package) knownNixPkgs;

    toolsCheckScript = lib.concatMapStringsSep "\n" (
        name:
        let
            binary = pkgCatalog.${name}.binary;
        in
        ''
            if ! command -v ${lib.escapeShellArg binary} >/dev/null 2>&1; then
                missing_pkgs="${"$"}missing_pkgs ${name}"
            fi
        ''
    ) knownAllPkgs;
in
{
    options.dotfiles.lspTools = {
        enable = lib.mkEnableOption "LSP and editor tooling";

        nixPkgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Packages to install with Nix for editor tooling.";
        };

        nativePkgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Packages expected to be installed by the host native package manager.";
        };

        strict = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Fail activation if any required package binary is missing.";
        };

        nativeInstallHint = lib.mkOption {
            type = lib.types.lines;
            default = "Install the missing packages with your system package manager or move them to `dotfiles.lspTools.nixPkgs`.";
            description = "Hint shown when required package binaries are missing.";
        };
    };

    config = lib.mkIf cfg.enable {
        assertions = [
            {
                assertion = unknownNixPkgs == [ ];
                message = "dotfiles.lspTools.nixPkgs contains unknown packages: ${lib.concatStringsSep ", " unknownNixPkgs}";
            }
            {
                assertion = unknownNativePkgs == [ ];
                message = "dotfiles.lspTools.nativePkgs contains unknown packages: ${lib.concatStringsSep ", " unknownNativePkgs}";
            }
        ];

        home.packages = nixManagedToolPackages;

        home.activation.checkLspTooling = lib.hm.dag.entryAfter [ "installPackages" ] ''
            PATH="${config.home.profileDirectory}/bin:${"$"}PATH"
            missing_pkgs=""

            ${toolsCheckScript}

            if [ -n "${"$"}missing_pkgs" ]; then
                echo "LSP/tooling check failed. Missing package binaries for:"
                for pkg in ${"$"}missing_pkgs; do
                    echo "  - ${"$"}pkg"
                done
                echo
                printf '%s\n' ${lib.escapeShellArg cfg.nativeInstallHint}

                ${lib.optionalString (!cfg.strict) ''
                    echo "Continuing because dotfiles.lspTools.strict = false"
                ''}

                ${lib.optionalString cfg.strict "exit 1"}
            fi
        '';
    };
}
