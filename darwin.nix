{ pkgs, ... }:

{
  nix.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.te = {
    home = "/Users/te";
  };

  system.stateVersion = 4;
}

