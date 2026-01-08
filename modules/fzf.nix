{ ... }:
{
    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        defaultOptions = [
            "--height 40%"
            "--layout=reverse"
            "--border"
            "--inline-info"
        ];
        changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git"; # ALT-C
        changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
        fileWidgetCommand = "fd --type f --hidden --follow --exclude .git"; # ALT-T
        fileWidgetOptions = [ "--preview 'bat --style=numbers --color=always --line-range :500 {}'" ];
        tmux = {
            enableShellIntegration = true;
            shellIntegrationOptions = [ "--height 40%" "--layout=reverse" "--border" "--inline-info" ];
        };
    };
}
