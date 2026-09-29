{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ../modules/home-manager/programs/brave-sara.nix
    ../modules/home-manager/desktop/plasma-sara.nix
  ];

  home.username = "sara";
  home.homeDirectory = "/home/sara";

  home.packages = with pkgs; [
    spotify
  ];
}
