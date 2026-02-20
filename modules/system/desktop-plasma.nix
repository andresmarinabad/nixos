# Módulo común: SDDM, Plasma 6, Nix y GC para hosts con escritorio
{ ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };

  services.desktopManager.plasma6.enable = true;
  programs.dconf.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  programs.command-not-found.enable = false;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
