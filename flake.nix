{
  description = "Soroush's personal Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private = {
      url = "git+ssh://git@github.com/smirzaei/nix-private.git";
    };
  };

  outputs = { self, nixpkgs, home-manager, private, ... }: {
      # Arch
      homeConfigurations.soroush = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit private; };
        modules = [ ./hosts/arch-linux/home.nix ];
      };
  };
}
