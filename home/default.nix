{ pkgs, lib, ... }:
{
  imports = [
    ./bash.nix
    ./zsh.nix
  ];

  home.username = "te";
  home.homeDirectory = "/Users/te";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  xdg.configFile."starship.toml".source = ../starship/starship.toml;
  home.sessionVariables.DOTFILES_STARSHIP = lib.getExe pkgs.starship;

  home.packages = with pkgs; [
    neovim
    fd
    fzf
    tmux
    git
    gh
    jq
    bat
    eza
    tree
    zsh
    starship
  ] ++ lib.optionals pkgs.stdenv.isDarwin [ vscode ];
}
