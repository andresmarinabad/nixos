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
    ./plasma.nix
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.packages = with pkgs; [
    spotify
    megasync
    gnome-disk-utility
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
    inkscape
    calibrePkg
    wl-clipboard
    xclip
    bruno
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.kubectl
    ])
  ];

  home.activation.visualSwitch =
    let
      wallpapersDir = ../../../../assets/wallpapers;
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      LOG_FILE="$HOME/.local/share/wallpapers/wallpaper-switch.log"
      mkdir -p "$(dirname "$LOG_FILE")"

      WALLPAPER_FILE=$(ls ${wallpapersDir}/*.jpg | ${pkgs.coreutils}/bin/shuf -n1)
      echo "Fondo seleccionado: $WALLPAPER_FILE" > "$LOG_FILE"

      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
      export WAYLAND_DISPLAY="wayland-0"
      export DISPLAY=":0"

      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage "$WALLPAPER_FILE" >> "$LOG_FILE" 2>&1
      echo "Proceso terminado." >> "$LOG_FILE"
    '';

  home.activation.setupFlatpak = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    if ! ${pkgs.flatpak}/bin/flatpak info --user com.bambulab.BambuStudio > /dev/null 2>&1; then
      echo "Instalando Bambu Studio via Flatpak..."
      ${pkgs.flatpak}/bin/flatpak install --user --noninteractive flathub com.bambulab.BambuStudio
    fi
  '';

}
