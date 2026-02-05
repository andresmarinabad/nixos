{ pkgs, ... }: {
  imports = [ ./common.nix ]; 

  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";

  home.packages = with pkgs; [
    pkgs.google-cloud-sdk
  ];

  programs.git = {
    enable = true;
    userName = "Gandalf";
    userEmail = "andres.marin@aistechspace.com";
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/gandalf"; 
      };
    };
  };
}
