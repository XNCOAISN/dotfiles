{
  description = "Personal tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f (import nixpkgs { inherit system; })
        );
    in {
      packages = forAllSystems (pkgs:
        let
          personalPackages = with pkgs; [
            neovim
            ripgrep
            fd
            fzf
            tmux
            git
            gh
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            vscode
          ];
        in {
          default = pkgs.buildEnv {
            name = "personal-tools";
            paths = personalPackages;
          };
        });
    };
}
