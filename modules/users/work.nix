{ pkgs, ... }: {
  imports = [ developer.nix ]; 

  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    
  ];

  programs.git = {
    enable = true;
    userName = "Gandalf";
    userEmail = "andres.marin@aistechspace.com";
  };
}