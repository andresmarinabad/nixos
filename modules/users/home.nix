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

  programs.git = {
    enable = true;
    userName = "Andres";
    userEmail = "andres.marin.abad+git@gmail.com";
  };

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

  systemd.user.services.megasync = {
    Unit = { Description = "MegaSync Client"; };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
        ExecStart = "${pkgs.megasync}/bin/megasync";
        Restart = "on-failure";
    };
  };
}
