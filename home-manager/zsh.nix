{ config, lib, ... }:
let
  shellAliases = import ./aliases.nix;
in
{
  programs.zsh = {
    enable = true;
    inherit shellAliases;
    initContent = lib.mkAfter ''
      if [[ $TERM != "dumb" && -n "''${DOTFILES_STARSHIP:-}" ]]; then
        eval "$(PATH= "$DOTFILES_STARSHIP" init zsh)"
      fi
    '';
  };
}
