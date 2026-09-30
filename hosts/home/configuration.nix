{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../config/system/home.nix
    ../../config/agenix/default.nix
  ];

  system.stateVersion = "26.05";
}
