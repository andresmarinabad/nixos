{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../config/common/system.nix
    ../../config/agenix/default.nix
  ];

  system.stateVersion = "26.05";
}
