{ pkgs, ... }:
{
  imports = [ ./roles/developer.nix ];

  home.username = "gandalf";
  home.homeDirectory = "/home/gandalf";

  home.packages = with pkgs; [
    code-cursor
    lens
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.kubectl
    ])
  ];

  programs.git = {
    enable = true;
    settings.user.name = "Gandalf";
    settings.user.email = "andres.marin@aistechspace.com";
  };

  # GitHub Public Key
  home.file.".ssh/gandalf.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICi4Cx3fx7uXitvSOTBzTRsi1ATKLI8dDs0RZy8iKp5c andres.marin@aistechspace.com";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/gandalf";
      };
    };
  };

}
