{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/desktop-plasma.nix
    ../../modules/system/aistech/system.nix
    ../../modules/agenix/default.nix
  ];

  system.stateVersion = "26.05";
}
