{ pkgs, ... }:
{
  # Herramientas para muggles
  imports = [ ../common.nix ];

  # Configuración de Chrome
  programs.google-chrome = {
    enable = true;
  };

  home.stateVersion = "26.05";
}
