# modules/system-common.nix
{ pkgs, config, ... }:

let
  user = "andres";
  imagen = ../home-manager/profile/andres.png;
in

{
  # Bootloader, Red, Reloj, Locales, Fonts, Docker, GNOME, Sonido, etc.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = "loose";

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8"; LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8"; LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8"; LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8"; LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  programs.zsh.enable = true;
  fonts.packages = with pkgs; [
    jetbrains-mono fira-code fira-code-symbols
    nerd-fonts.jetbrains-mono nerd-fonts.ubuntu-mono nerd-fonts.ubuntu
  ];

  # Usuarios base que están en ambos PCs
  users.users.andres = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    description = "Andrés";
    hashedPasswordFile = config.age.secrets.pass-andres.path;
  };

  virtualisation.docker.enable = true;
  services.xserver.enable = true;

  services.xserver.excludePackages = with pkgs; [ xterm ];
  services.xserver.xkb = { layout = "es"; variant = ""; };

  services.openssh = { enable = true; settings.PasswordAuthentication = false; };
  console.keyMap = "es";

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  security.rtkit.enable = true;
  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nano.enable = false;
  programs.vim.enable = true;

  system.activationScripts.script.text = ''
    mkdir -p /var/lib/AccountsService/{icons,users}
    cp ${imagen} /var/lib/AccountsService/icons/${user}
    echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${user}" > /var/lib/AccountsService/users/${user}
    chown root:root /var/lib/AccountsService/users/${user}
    chmod 0600 /var/lib/AccountsService/users/${user}
    chown root:root /var/lib/AccountsService/icons/${user}
    chmod 0444 /var/lib/AccountsService/icons/${user}
  '';

  environment.shellAliases = {
    ngc = "sudo nix-collect-garbage -d";
  };
}