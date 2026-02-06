{ pkgs, ... }:
{
  # Herramientas para todos los perfiles
  home.packages = with pkgs; [
    bitwarden-desktop
    gnomeExtensions.dash-to-dock
    gnome-tweaks
    nil
    nixpkgs-fmt
  ];

  # Dock estilo ubuntu
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-fixed = true; # Esto hace que no se oculte
      extend-height = false; # Que no ocupe todo el espacio
      dock-position = "BOTTOM"; # Abajo como en mac
      dash-max-icon-size = 45; # Tamaño de iconos
      show-mounts = true; # Mostrar pendrives/discos
      pressure-threshold = 10;
      autohide = false;
      custom-theme-shrink = true;
      click-action = "previews";
      scroll-action = "cycle-windows";
      multi-monitor = true;
      transparency-mode = "FIXED";
      background-opacity = 0.0;
      customize-alphas = true;
      min-alpha = 0.0;
      max-alpha = 0.0;
    };
  };

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
