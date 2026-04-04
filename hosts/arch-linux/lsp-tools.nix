{ ... }:
{
    dotfiles.lspTools = {
        enable = true;
        nixPkgs = [
            "bash-language-server"
            "copilot-language-server"
            "golangci-lint-langserver"
            "helm-ls"
            "lua-language-server"
            "nil"
            "yaml-language-server"
        ];
        nativePkgs = [
            "golangci-lint"
            "gopls"
        ];
        nativeInstallHint = ''
            Install native LSP packages with pacman, for example:
              sudo pacman -S --needed gopls golangci-lint
        '';
    };
}
