{ config, pkgs, ... }:

{
  # Habilitar GNOME
  services.xserver.desktopManager.gnome.enable = true;

  # Habilitar el servidor gráfico
  services.xserver.enable = true;
  services.xserver.layout = "es"; 
  services.xserver.displayManager.gdm.enable = true;

}
