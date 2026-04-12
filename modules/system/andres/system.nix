{ pkgs, config, ... }:

let
  user = "sara";
  imagen = ../../../assets/img/profiles/sara.png;
in

{
  imports = [
    ../common.nix
    ../../agenix
  ];

  environment.shellAliases = {
    nr = "nh os switch -H home";
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/2017c0df-b719-4f90-bd32-a7e63856e22e";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

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

  # Script con nombre distinto para no sobrescribir el de common.nix (andres)
  system.activationScripts.accountsServiceSara = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${imagen} /var/lib/AccountsService/icons/${user}
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${user}" > /var/lib/AccountsService/users/${user}
    chown root:root /var/lib/AccountsService/users/${user}
    chmod 0600 /var/lib/AccountsService/users/${user}
    chown root:root /var/lib/AccountsService/icons/${user}
    chmod 0444 /var/lib/AccountsService/icons/${user}
  '';
}
