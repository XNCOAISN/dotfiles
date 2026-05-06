{ pkgs, ... }:

{
  home.username = "yourname";
  home.homeDirectory = "/Users/yourname";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    git
    neovim
    tmux
    ripgrep
    fd
    jq
    gh
    direnv
  ];

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "you@example.com";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}