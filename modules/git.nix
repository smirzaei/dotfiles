{ ... }:
{
    programs.git = {
        enable = true;
        settings = {
            alias.tree = "log --graph --decorate --pretty=oneline --abbrev-commit";
            core = {
                editor = "nvim";
            };
            difftool = {
                prompt = false;
            };
        };
    };

    programs.difftastic = {
        enable = true;
        git = {
            enable = true;
            mode = "both";
        };
        options = {
            background = "light";
            color = "auto";
            display = "side-by-side";
        };
    };
}
