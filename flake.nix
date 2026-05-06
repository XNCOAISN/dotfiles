{
  description = "My minimal Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      username = "yourname";
      homeDirectory = "/Users/yourname";
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };

          modules = [
            ./home.nix
          ];
        };
    };
}