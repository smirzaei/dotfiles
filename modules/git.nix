{ ... }:
{
    programs.git = {
        enable = true;
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
}
