# modules/plasma.nix
{ ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };
  services.desktopManager.plasma6.enable = true;
  
  # Necesario para que Home Manager pueda tocar la config de Plasma
  programs.dconf.enable = true;
}