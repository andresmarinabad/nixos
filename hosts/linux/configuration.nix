{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common.nix 
    ../../modules/agenix/default.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc.automatic = true;
  nix.settings.auto-optimise-store = true;
  programs.command-not-found.enable = false;

  system.stateVersion = "26.05";
}