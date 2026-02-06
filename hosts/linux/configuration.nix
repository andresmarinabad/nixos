{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common.nix
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

  system.stateVersion = "26.05";
}
