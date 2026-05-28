{ ... }:
let
  shellAliases = import ./aliases.nix;
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    inherit shellAliases;
    profileExtra = ''
      [[ -f "$HOME/.profile" ]] && . "$HOME/.profile"
    '';
    initExtra = ''
      if [[ $TERM != "dumb" && -n "''${DOTFILES_STARSHIP:-}" ]]; then
        eval "$(PATH= "$DOTFILES_STARSHIP" init bash --print-full-init)"
      fi
    '';
  };
}
