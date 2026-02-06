{ pkgs, ... }: {
  imports = [ ./roles/developer.nix ]; 

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.activation = {
    setupFlatpak = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      ${pkgs.flatpak}/bin/flatpak install --user --noninteractive flathub com.bambulab.BambuStudio
    '';
  };

  home.packages = with pkgs; [
    spotify
    calibre
    megasync
  ];

  # GIT
  programs.git = {
    enable = true;
    userName = "Andres";
    userEmail = "andres.marin.abad+git@gmail.com";
  };

  # GitHub Public Key
  home.file.".ssh/andres.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqImXgnyR1mINurbZY0xV5EJmKUQWGv6BxQihpsgxiD andres.marin.abad+git@gmail.com";

  # SSH
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/andres";
      };
    };
  };

  # MEGA (para calibre sobretodo)
  systemd.user.services.megasync = {
    Unit = { Description = "MegaSync Client"; };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
        ExecStart = "${pkgs.megasync}/bin/megasync";
        Restart = "on-failure";
    };
  };
  
}
