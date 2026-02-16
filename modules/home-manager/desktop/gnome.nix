{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnome-tweaks
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

  home.stateVersion = "26.05";
}
