{ pkgs, config, ... }:
{
  imports = [
    ../common.nix
    ../../agenix
  ];

  # Usuario extra solo para casa
  users.users.sara = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" ];
    description = "Sara";
    hashedPasswordFile = config.age.secrets.pass-sara.path;
  };

  # Configuración específica de Hardware/Seguridad para casa
  services.trezord.enable = true;
  services.udev.packages = with pkgs; [ trezor-udev-rules ];

  environment.shellAliases = {
    nr = "sudo nixos-rebuild switch --flake .#home";
    ncg = "sudo nix-collect-garbage -d";
  };
}