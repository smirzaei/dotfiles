{
  description = "Soroush's personal Nix configuration";

  inputs = {
    agents = {
      url = "git+ssh://git@github.com/smirzaei/agents.git";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private = {
      url = "git+ssh://git@github.com/smirzaei/nix-private.git";
    };
  };

  outputs =
    {
      self,
      agents,
      nixpkgs,
      home-manager,
      private,
      ...
    }:
    {
      # Arch
      homeConfigurations.soroush = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfreePredicate =
              pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "copilot-language-server"
              ];
          };
        };
        extraSpecialArgs = { inherit agents private; };
        modules = [ ./hosts/arch-linux/home.nix ];
      };
    };
}
