{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/aistech/system.nix
    # ../../modules/desktop/gnome.nix
    ../../modules/desktop/plasma.nix
    ../../modules/agenix/default.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  programs.command-not-found.enable = false;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Monero 
  # boot.kernelParams = [ "msr.allow_writes=on" ];
  # boot.kernelModules = [ "msr" ];
  # boot.kernel.sysctl = {
  #   "vm.nr_hugepages" = 1280;
  # };

  system.stateVersion = "26.05";
}
