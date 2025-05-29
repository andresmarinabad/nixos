{ pkgs, ... }: {
  imports = [ developer.nix ]; 

  home.username = "andres";
  home.homeDirectory = "/home/andres";
  home.stateVersion = "23.11";

  home.activation = {
    setupFlatpak = ''
      # Añadir el repositorio de Flathub si no existe (a nivel de usuario)
      ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      
      # Instalar Bambu Studio desde Flathub
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

  systemd.user.services.megasync = {
    Unit = { Description = "MegaSync Client"; };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = {
        ExecStart = "${pkgs.megasync}/bin/megasync";
        Restart = "on-failure";
    };
  };
}