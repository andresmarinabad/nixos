{ pkgs, ... }:
{

  # Herramientas para todos los perfiles
  home.packages = with pkgs; [
    bitwarden-desktop
    nil
    nixpkgs-fmt
  ];

  # Varaibles para el usuario
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # Teclado
  home.keyboard = {
    layout = "es";
  };

  home.stateVersion = "26.05";
}
