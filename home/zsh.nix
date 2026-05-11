{ config, lib, ... }:
{
  programs.zsh.enable = true;
  home.file.".config/zsh/dotfiles.zshrc".source = ../zsh/.zshrc;
  programs.zsh.initContent = lib.mkOrder 11000 ''
    [[ -r "${config.xdg.configHome}/zsh/dotfiles.zshrc" ]] \
      && source "${config.xdg.configHome}/zsh/dotfiles.zshrc"
  '';
}
