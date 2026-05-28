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
        system: module:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [ module ];
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
      x86_64Linux = "x86_64-linux";
      aarch64Linux = "aarch64-linux";
    in
    {
      homeConfigurations = {
        "te@mac" = mkHome aarch64 ./hosts/mac/default.nix;
        "te@mac-intel" = mkHome x86_64Darwin ./hosts/mac/default.nix;
        "vscode@devcontainer" = mkHome x86_64Linux ./hosts/dev/default.nix;
        "vscode@devcontainer-arm64" = mkHome aarch64Linux ./hosts/dev/default.nix;
      };

      apps.${aarch64} = {
        switch = mkSwitchApp aarch64 "te@mac";
        default = mkSwitchApp aarch64 "te@mac";
      };

      apps.${x86_64Darwin} = {
        switch = mkSwitchApp x86_64Darwin "te@mac-intel";
        default = mkSwitchApp x86_64Darwin "te@mac-intel";
      };

      apps.${x86_64Linux} = {
        switch = mkSwitchApp x86_64Linux "vscode@devcontainer";
        default = mkSwitchApp x86_64Linux "vscode@devcontainer";
      };

      apps.${aarch64Linux} = {
        switch = mkSwitchApp aarch64Linux "vscode@devcontainer-arm64";
        default = mkSwitchApp aarch64Linux "vscode@devcontainer-arm64";
      };
    };
}
