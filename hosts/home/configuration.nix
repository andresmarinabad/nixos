{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/andres/system.nix
    ../../modules/agenix/default.nix
  ];

  system.stateVersion = "26.05";
}
