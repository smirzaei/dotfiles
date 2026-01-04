{
  description = "Soroush's personal Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private = {
      url = "git+ssh://git@github.com/smirzaei/nix-private.git";
    };
  };

  outputs = { self, nixpkgs, home-manager, private, ... }: {
      # Arch
      homeConfigurations.soroush = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              "copilot-language-server"
            ];
          };
        };
        extraSpecialArgs = { inherit private; };
        modules = [ ./hosts/arch-linux/home.nix ];
      };
  };
}
