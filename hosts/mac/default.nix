{ ... }:
{
  imports = [
    ../../home-manager
    ../../home-manager/darwin.nix
  ];

  home.username = "te";
  home.homeDirectory = "/Users/te";
  home.stateVersion = "24.11";
}
