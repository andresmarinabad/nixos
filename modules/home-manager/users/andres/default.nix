{
  pkgs,
  lib,
  ...
}:

let
  calibrePkg = pkgs.callPackage ../../../../pkgs/calibre.nix { };
in
{
  imports = [
    ../../common.nix
    ./git.nix
    ./shell.nix
    ./vscode.nix
    ./browsers.nix
    ../../../desktop/plasma.nix
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.packages = with pkgs; [
    spotify
    megasync
    telegram-desktop
    trezor-suite
    trezorctl
    bat
    ripgrep
    curl
    wget
    btop
    fzf
    obs-studio
    gimp
    calibrePkg
    wl-clipboard
    xclip
    bruno
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.kubectl
    ])
  ];

  home.activation.visualSwitch = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    WALLPAPER_DIR="$HOME/.local/share/wallpapers"
    TIMESTAMP=$(date +%s)
    WALLPAPER_FILE="$WALLPAPER_DIR/switch-$TIMESTAMP.jpg"
    LOG_FILE="$WALLPAPER_DIR/wallpaper-switch.log"

    mkdir -p "$WALLPAPER_DIR"
    echo "Iniciando descarga de fondo..." > "$LOG_FILE"

    if ${pkgs.curl}/bin/curl -sL --max-time 10 "https://picsum.photos/3840/2160?random=$RANDOM" -o "$WALLPAPER_FILE"; then
      echo "Imagen descargada correctamente." >> "$LOG_FILE"

      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
      export WAYLAND_DISPLAY="wayland-0"
      export DISPLAY=":0"

      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage "$WALLPAPER_FILE" >> "$LOG_FILE" 2>&1
      echo "Proceso terminado." >> "$LOG_FILE"
    else
      echo "Fallo al descargar la imagen." >> "$LOG_FILE"
    fi
  '';

  home.activation.setupFlatpak = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    if ! ${pkgs.flatpak}/bin/flatpak info --user com.bambulab.BambuStudio > /dev/null 2>&1; then
      echo "Instalando Bambu Studio via Flatpak..."
      ${pkgs.flatpak}/bin/flatpak install --user --noninteractive flathub com.bambulab.BambuStudio
    fi
  '';

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
}
