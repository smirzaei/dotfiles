{ config, pkgs, private, ... }:

let
    monoFont = "CaskaydiaCove Nerd Font";
    theme = {
        red = "#ffc0b9";
        green = "#c4ffd3";
        blue = "#b6f0ff";
        gray1 = "#565a60";
        gray2 = "#a7a9ae";
        gray3 = "#16181d";
        gray4 = "#65696f";
    };
in
{
    imports = [
        ../../modules/fzf.nix
        ../../modules/git.nix
        ../../modules/starship.nix
        ../../modules/zsh.nix
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
        kubectl                   #
        kubectx                   #
        neovim                    #
        ripgrep                   # Better grep
        # Disabling this because it brings a bunch of dependencies which I
        # don't necessarily need.
        # ripgrep-all # ripgrep with pdf, docx, etc support
        shellcheck                # shell script analyzer
        shfmt                     # shell script formatter
        stylua                    # Lua formatter
        wabt                      # WebAssembly tools
        nerd-fonts.caskaydia-cove #

        # LSPs
        lua-language-server
        copilot-language-server
        yaml-language-server
        bash-language-server
        gopls
        golangci-lint
        golangci-lint-langserver
        nil
        helm-ls
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

    programs.k9s = {
        enable = true;
    };

    programs.kubecolor = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
            zima = private.ssh.hosts.zima;
        };
    };

    programs.ghostty = {
        enable = true;
        enableZshIntegration = true;
        installBatSyntax = true;
        installVimSyntax = true;
        settings = {
            # Don't ask for confirmation when exiting
            confirm-close-surface = false;

            # General look and feel
            theme = "Nvim Dark";
            window-decoration = true;

            # Font
            font-size = 10;
            font-family = monoFont;
            font-family-bold = monoFont;
            font-family-italic = monoFont;
            font-family-bold-italic = monoFont;
            font-feature = "calt=1,liga=1,ss01=0,ss02=1,ss19=1";
            window-title-font-family = monoFont;

            # Cell (char and line) space adjustment
            adjust-cell-width = 0;
            adjust-cell-height = 10;

            # Cursor
            cursor-style = "block";
            cursor-style-blink = false;

            # Linux
            gtk-single-instance = false;
            gtk-titlebar = false;

            # Mouse
            mouse-hide-while-typing = true;

            shell-integration-features = "no-cursor,title";

            keybind = [
                "ctrl+shift+i=inspector:toggle"
            ];
        };
    };

    programs.tmux = {
        enable = true;
        terminal = "screen-256color";
        focusEvents = true;
        baseIndex = 1; # Window index starts at 1
        mouse = true; # Enable mouse - useful for scrolling and pane resizing
        historyLimit = 100000; # Increase scrollback buffer
        keyMode = "vi"; # Enable vi keybindings in copy mode
        escapeTime = 0; # Disable escape time for faster key response

        extraConfig = ''
            # Reload config with prefix + r
            bind r source-file ${pkgs.tmux}/share/tmux/tmux.conf

            # Enable true color
            set -ga terminal-overrides ",*256col*:Tc"

            # Enable apps like nvim to bind to all? key combinations
            set -s extended-keys on

            # Pane index starts at 1
            set -g pane-base-index 1

            # Automatically renumber windows when one is closed
            set -g renumber-windows on

            # Set window titles
            set -g set-titles on
            set -g set-titles-string "#{pane_title}" # Set window title to current command

            # Custom keybinds
            bind | split-window -h # Vertical split
            bind - split-window -v # Horizontal split

            bind c new-window -c "#{pane_current_path}" # Create new window in current directory
            bind '"' split-window -c "#{pane_current_path}" # Create a vertical split in current directory
            bind % split-window -h -c "#{pane_current_path}" # Create a horizontal split in current directory

            # Vi-style pane navigation
            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R

            # Overall
            set -g status-style bg=${theme.gray3},fg=${theme.gray2}

            # Left
            set -g status-left "#[bg=${theme.gray1},fg=${theme.gray2}]   #S #[default]      "
            set -g status-left-length 100 # Allow the left side to grow

            ## Window
            setw -g window-status-separator " "

            # Inactive window
            setw -g window-status-format " #I:#W#F "

            # Active window
            setw -g window-status-current-format " #I:#W#F "
            setw -g window-status-current-style bold,bg=${theme.green},fg=${theme.gray3}

            # Right
            set -g status-right ""
        '';
    };

    # gpg-agent for agent forwarding
    services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        enableSshSupport = true;
    };

    # It's much easier to manage neovim through Lua
    xdg.configFile."nvim".source = ../../home/.config/nvim;

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
