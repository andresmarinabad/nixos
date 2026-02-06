{ pkgs, ... }: {
  imports = [ ./roles/developer.nix ]; 

  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";

  home.packages = with pkgs; [
    pkgs.google-cloud-sdk
    pkgs.code-cursor
  ];

  programs.git = {
    enable = true;
    userName = "Gandalf";
    userEmail = "andres.marin@aistechspace.com";
  };

  # GitHub Public Key
  home.file.".ssh/gandalf.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICi4Cx3fx7uXitvSOTBzTRsi1ATKLI8dDs0RZy8iKp5c andres.marin@aistechspace.com";

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
