{ config, pkgs, private, ... }:

{
    home.username = "soroush";
    home.homeDirectory = "/home/soroush";

    home.packages = with pkgs; [
        bat         # better cat
        difftastic  # better diff
        eza         # better ls
        fd          # better find
        fx          # interactive JSON viewer
        hexyl       # better xxd
        kubectl     # k8s CLI
        kubectx     # k8 context and namespace switcher
        ripgrep     # Better grep
        # Disabling this because it brings a bunch of dependencies which I
        # don't necessarily need.
        # ripgrep-all # ripgrep with pdf, docx, etc support
        shellcheck  # shell script analyzer
        shfmt       # shell script formatter
        stylua      # Lua formatter
        wabt        # WebAssembly tools
    ];

    programs.zsh = {
        enable = true;
        # Don’t forget to add `environment.pathsToLink = [ "/share/zsh" ];`
        # to your system configuration to get completion for system packages (e.g. systemd).
        enableCompletion = true;
        autosuggestion = {
            enable = true;
        };
        syntaxHighlighting = {
            enable = true;
        };
        history = {
            append = true;
            expireDuplicatesFirst = true;
            ignoreDups = true; # Do not enter command lines into the history list if they are duplicates of the previous event.
            save = 100000; # Number of history lines to save.
            size = 100000; # Number of history lines to keep.
            saveNoDups = true; # Do not write duplicate entries into the history file.
            share = true; # Share command history between zsh sessions.
        };
        shellAliases = {
            ll = "exa -lah --color=always --group-directories-first";
            l = "exa -lah --color=always --group-directories-first";
            c = "clear";
            g = "git";
            ga = "git add";
            gst = "git status";
            gd = "git diff";
            gc = "git commit";
            gp = "git push";
            gl = "git pull";
            k = "kubectl";
            kns = "kubens";
            kctx = "kubectx";
            fk = ''kill -9 $(ps aux | fzf | awk "{print \$2}")'';
            fp = "ps aux | fzf";
        };
    };

    programs.git = {
        enable = true;
        userEmail = private.personalEmail;
        userName = "Soroush Mirzaei";
        signing = {
            signByDefault = true;
            key = private.gitSigningKey;
        };
        aliases = {
            tree = "log --graph --decorate --pretty=oneline --abbrev-commit";
        };
        difftastic = {
            enable = true;
            enableAsDifftool = true;
        };
        extraConfig = {
            core = {
                editor = "nvim";
            };
            difftool = {
                prompt = false;
            };
        };
    };

    programs.starship = {
        enable = true;
        enableZshIntegration = true;
    };
    # `programs.starship.settings` won't handle escape characters properly
    xdg.configFile."starship.toml".source = ../../home/.config/starship.toml;

    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
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
