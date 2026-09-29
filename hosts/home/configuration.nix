{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/home.nix
    ../../modules/agenix/default.nix
  ];

  system.stateVersion = "26.05";
}
