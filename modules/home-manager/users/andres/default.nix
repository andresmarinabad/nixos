{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  calibrePkg = pkgs.callPackage ../../../../pkgs/calibre.nix { };
  wallpapersDir = ../../../../assets/wallpapers;
  randomWallpaperScript = pkgs.writeShellScript "random-wallpaper" ''
    wallpaper="$(${pkgs.findutils}/bin/find ${wallpapersDir} -maxdepth 1 -type f -name '*.jpg' | ${pkgs.coreutils}/bin/shuf -n 1)"
    if [ -n "$wallpaper" ]; then
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage "$wallpaper"
    fi
  '';
  megasyncPkg =
    (import inputs.nixpkgs-megasync {
      system = pkgs.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    }).megasync;
in
{
  imports = [
    ../../common.nix
    ./git.nix
    ./shell.nix
    ./vscode.nix
    ./browsers.nix
    ./plasma.nix
    ./minecraft.nix
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.packages = with pkgs; [
    megasyncPkg
    gnome-disk-utility
    telegram-desktop
    trezor-suite

    # CLI / terminal
    bat
    ripgrep
    fd
    curl
    wget
    btop
    fzf
    jq
    yq-go

    # DevOps
    opentofu
    terragrunt
    k9s
    shellcheck
    lazydocker
    lazygit

    # Files
    yazi

    # Desktop
    obs-studio
    gimp
    inkscape
    calibrePkg
    wl-clipboard
    xclip
    bruno
  ];

  home.activation.randomWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ${pkgs.systemd}/bin/systemctl --user --quiet is-active plasma-workspace.target; then
      $DRY_RUN_CMD ${randomWallpaperScript}
    fi
  '';

}
