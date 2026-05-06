{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/home/system.nix
    ../../modules/agenix/default.nix
  ];

  system.stateVersion = "26.05";
}
