{ pkgs, config, ... }:

let
  user = "sara";
  imagen = ../../home-manager/profile/sara.png;
in

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
  };

  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${imagen} /var/lib/AccountsService/icons/${user}
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${user}" > /var/lib/AccountsService/users/${user}
    chown root:root /var/lib/AccountsService/users/${user}
    chmod 0600 /var/lib/AccountsService/users/${user}
    chown root:root /var/lib/AccountsService/icons/${user}
    chmod 0444 /var/lib/AccountsService/icons/${user}
  '';
}