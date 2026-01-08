{ ... }:
{
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
        initContent = builtins.readFile ../home/.zshrc;
    };
}
