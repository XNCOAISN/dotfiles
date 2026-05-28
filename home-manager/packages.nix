{ pkgs, ... }:
{
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
  ];
}
