{ pkgs, ... }: {
  imports = [ ./developer.nix ]; 

  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";
  home.stateVersion = "23.11";

  # home.packages = with pkgs; [
    
  # ];

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
