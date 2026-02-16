# modules/plasma.nix
{ ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
  # Necesario para que Home Manager pueda tocar la config de Plasma
  programs.dconf.enable = true; 
}