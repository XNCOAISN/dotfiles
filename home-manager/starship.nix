{ pkgs, lib, ... }:
{
  home.sessionVariables.DOTFILES_STARSHIP = lib.getExe pkgs.starship;

  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings = {
      nix_shell = {
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "❄️ ";
      };
    };
  };
}
