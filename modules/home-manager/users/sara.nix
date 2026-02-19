{ pkgs, ... }:
{
  imports = [ ../common.nix ];

  home.username = "sara";
  home.homeDirectory = "/home/sara";

  home.packages = with pkgs; [
    spotify
  ];

  programs.google-chrome = {
    enable = true;
    commandLineArgs = [ "--restore-last-session" ];
  };

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };

  home.stateVersion = "26.05"; 

}
