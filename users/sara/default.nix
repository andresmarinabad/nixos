{ pkgs, ... }:

{
  imports = [
    ../../config/common/user.nix
    ./brave.nix
    ./plasma.nix
  ];

  home.username = "sara";
  home.homeDirectory = "/home/sara";

  home.packages = with pkgs; [
    spotify
  ];
}
