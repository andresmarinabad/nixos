{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ../modules/home-manager/users/sara/browsers.nix
    ../modules/home-manager/users/sara/plasma.nix
  ];

  home.username = "sara";
  home.homeDirectory = "/home/sara";

  home.packages = with pkgs; [
    spotify
  ];
}
