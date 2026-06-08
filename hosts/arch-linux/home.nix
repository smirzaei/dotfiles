{ config, pkgs, private, ... }:
{
    imports = [
        ../../modules/fzf.nix
        ../../modules/git.nix
        ../../modules/ghostty.nix
        ../../modules/k8s.nix
        ../../modules/lsp-tools.nix
        ../../modules/neovim.nix
        ../../modules/starship.nix
        ../../modules/tmux.nix
        ../../modules/zed.nix
        ../../modules/zsh.nix
        ./lsp-tools.nix
    ];

    home.username = "soroush";
    home.homeDirectory = "/home/soroush";

    home.packages = with pkgs; [
        bat                       # better cat
        difftastic                # better diff
        eza                       # better ls
        fd                        # better find
        fx                        # interactive JSON viewer
        hexyl                     # better xxd
        ripgrep                   # Better grep
        # Disabling this because it brings a bunch of dependencies which I
        # don't necessarily need.
        # ripgrep-all # ripgrep with pdf, docx, etc support
        shellcheck                # shell script analyzer
        shfmt                     # shell script formatter
        stylua                    # Lua formatter
        wabt                      # WebAssembly tools

        # Fonts
        nerd-fonts.hack
        nerd-fonts.sauce-code-pro
        nerd-fonts.caskaydia-cove
        nerd-fonts.caskaydia-mono
    ];

    programs.git = {
        userEmail = private.git.personalEmail;
        userName = "Soroush Mirzaei";
        signing = {
            signByDefault = true;
            key = private.git.signingKey;
        };
    };

    # Github CLI
    programs.gh = {
        enable = true;
        settings = {
            git_protocol = "ssh";
        };
    };

    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
            zima = private.ssh.hosts.zima;
        };
    };

    dotfiles.ghostty = {
        enable = true;
        package = null;
    };

    dotfiles.tmux = {
        enable = true;
        package = null;
    };

    dotfiles.neovim = {
        enable = true;
        package = null;
        nativeInstallHint = ''
            Install Neovim with pacman, for example:
              sudo pacman -S --needed neovim
        '';
    };

    dotfiles.zed = {
        enable = true;
        package = null;
    };

    services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        enableSshSupport = false;
        pinentry.package = pkgs.pinentry-curses;
    };

    services.ssh-agent = {
        enable = true;
    };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
