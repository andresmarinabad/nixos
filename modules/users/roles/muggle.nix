{ pkgs, ... }: {
  # Herramientas para muggles
  imports = [ ./basic.nix ]; 

  # Configuración de Chrome
  programs.google-chrome = {
    enable = true;
  };

  home.stateVersion = "26.05";
}
