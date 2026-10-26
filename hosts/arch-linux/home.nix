{ agents, config, lib, pkgs, private, ... }:
{
    imports = [
        ../../modules/alacritty.nix
        ../../modules/fzf.nix
        ../../modules/git.nix
        ../../modules/ghostty.nix
        ../../modules/k8s.nix
        ../../modules/lsp-tools.nix
        ../../modules/neovim.nix
        ../../modules/opencode.nix
        ../../modules/starship.nix
        ../../modules/tmux.nix
        ../../modules/web-dev.nix
        ../../modules/zed.nix
        ../../modules/zsh.nix
        ./lsp-tools.nix
    ];

    home.username = "soroush";
    home.homeDirectory = "/home/soroush";

    home.file.".agents".source = "${agents.outPath}/.agents";

    home.packages = with pkgs; [
        bat                       # better cat
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
        nerd-fonts.meslo-lg
        nerd-fonts.jetbrains-mono
        nerd-fonts.sauce-code-pro
        nerd-fonts.caskaydia-cove
        nerd-fonts.caskaydia-mono
    ];

    fonts.fontconfig.enable = true;

    programs.git = {
        package = null;
        lfs.package = null;
        settings.user = {
            email = private.git.personalEmail;
            name = "Soroush Mirzaei";
        };
        signing = {
            signByDefault = true;
            key = private.git.signingKey;
        };
    };

    home.activation.checkGitPackages = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
        if ! /usr/bin/pacman -Q git git-lfs >/dev/null; then
            echo "Git setup requires git and git-lfs to be installed with pacman." >&2
            echo "  sudo pacman -S --needed git git-lfs" >&2
            exit 1
        fi
    '';

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
        settings = private.ssh.hosts;
    };

    dotfiles.alacritty = {
        enable = true;
        package = null;
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

    dotfiles.webDev.enable = true;

    dotfiles.opencode = {
        enable = true;
        package = null;
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
