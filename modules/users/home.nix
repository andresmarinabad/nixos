{ pkgs, ... }:
{
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
    telegram-desktop
    feather
    protonvpn-gui
    xmrig
  ];

  # GIT
  programs.git = {
    enable = true;
    settings.user.name = "Andres";
    settings.user.email = "andresmarinabad@protonmail.com";
  };

  # GitHub Public Key
  home.file.".ssh/andres.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqImXgnyR1mINurbZY0xV5EJmKUQWGv6BxQihpsgxiD";

  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/andres";
      };
    };
  };

  # MEGA (para calibre sobretodo)
  home.file.".config/autostart/megasync.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=Megasync
    Comment=MegaSync Client
    Exec=${pkgs.megasync}/bin/megasync --tray
    Icon=megasync
    Terminal=false
    Categories=Network;System;
    StartupNotify=false
    X-GNOME-Autostart-enabled=true
  '';

  # XMRig para Monero
  home.file.".local/bin/tomine.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      # Este script lanza el minero con prioridad baja para no molestar
      nice -n 19 xmrig \
        -o gulf.moneroocean.stream:20128 \
        -u 88dEzih2X518UiiwBdWezwa6d4Cvu1ve646opRiuyiBv7kuDGKsetk6ZG8cK2WfDPKZCRzVPg5cYwM5bECKsWnzgVFfFR6m \
        -p andres \
        --tls \
        --cpu-max-threads-hint=100
    '';
  };

}
