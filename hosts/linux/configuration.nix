{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/common.nix 
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}