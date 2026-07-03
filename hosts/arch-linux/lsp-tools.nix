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
            "buf"
            "golangci-lint"
            "gopls"
            "tree-sitter-cli"
        ];
        nativeInstallHint = ''
            Install native LSP packages with pacman, for example:
              sudo pacman -S --needed buf gopls golangci-lint tree-sitter-cli
        '';
    };
}
