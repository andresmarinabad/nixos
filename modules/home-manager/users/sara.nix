{ pkgs, ... }:
{
  imports = [ ../muggle.nix ];

  home.username = "sara";
  home.homeDirectory = "/home/sara";

  home.packages = with pkgs; [
    spotify
  ];

}
