{
  description = "Personal dotfiles (Home Manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, ... }:
    let
      mkPkgs = system: import nixpkgs { inherit system; config.allowUnfree = true; };

      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [ ./home/default.nix ];
        };

      mkSwitchApp =
        system: homeAttr:
        let
          pkgs = mkPkgs system;
          hm = home-manager.packages.${system}.home-manager;
        in
        {
          type = "app";
          program = "${pkgs.writeShellApplication {
            name = "dotfiles-switch";
            runtimeInputs = [ hm ];
            text = ''
              exec home-manager switch -b hm-backup --flake "path:${self.outPath}#${homeAttr}" "$@"
            '';
          }}/bin/dotfiles-switch";
        };

      aarch64 = "aarch64-darwin";
      x86_64Darwin = "x86_64-darwin";
    in
    {
      homeConfigurations = {
        "te@mac" = mkHome aarch64;
        "te@mac-intel" = mkHome x86_64Darwin;
      };

      apps.${aarch64} = {
        switch = mkSwitchApp aarch64 "te@mac";
        default = mkSwitchApp aarch64 "te@mac";
      };

      apps.${x86_64Darwin} = {
        switch = mkSwitchApp x86_64Darwin "te@mac-intel";
        default = mkSwitchApp x86_64Darwin "te@mac-intel";
      };
    };
}
