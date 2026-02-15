# modules/gnome.nix
{ pkgs, ... }:
{
  # El gestor de entrada (GDM es muy de GNOME, Plasma prefiere SDDM)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Servicios específicos de integración
  services.gnome.gnome-keyring.enable = true;

  # Limpieza de morralla de GNOME
  environment.gnome.excludePackages = with pkgs; [ 
    gnome-tour yelp gnome-contacts gnome-weather 
  ];

  # Portal específico para GTK
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}