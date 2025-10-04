{ config, pkgs, ... }:

{
    home.username = "soroush";
    home.homeDirectory = "/home/soroush";

    home.packages = with pkgs; [
        bat         # better cat
        delta       # better git diff, replace with difftastic?
        dust        # better du
        difftastic  # better diff
        eza         # better ls
        fd          # better find
        fx          # Interactive JSON viewer
        hexyl       # better xxd
        ripgrep     # better grep
        # Disabling this because it brings a bunch of dependencies which I
        # don't necessarily need.
        # ripgrep-all # ripgrep with pdf, docx, etc support
    ];

    programs.starship = {
        enable = true;
        enableZshIntegration = true;
    };
    # `programs.starship.settings` won't handle escape characters properly
    xdg.configFile."starship.toml".source = ../../home/.config/starship.toml;

    xdg.configFile."delta/themes.gitconfig".source = ../../home/.config/delta/themes.gitconfig;

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
