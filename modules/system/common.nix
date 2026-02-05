{ pkgs, ... }: {
  # Bootloader y Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Red y Tiempo
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Madrid"; # Ajusta a tu zona
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Habilitar zsh
  programs.zsh.enable = true;

  # NerdFonts para Starship
  fonts.packages = with pkgs; [
    jetbrains-mono
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu
  ];

  # Usuarios con su shell
  users.users.andres = {
    isNormalUser = true;
    shell = pkgs.zsh; 
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  users.users.gandalf = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "docker" "wheel" ];
  };

  # Habilitar el entorno de escritorio (ejemplo con GNOME)
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Configuración para la terminal (TTY)
  console.keyMap = "es";

  # Habilitar flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Sonido con Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Permitir software privativo (Spotify, VS Code, etc)
  nixpkgs.config.allowUnfree = true;

  # Habilitar Flakes permanentemente
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Variables
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Quitar nano
  programs.nano.enable = false;

  # Poner vim
  environment.systemPackages = with pkgs; [
    vim
  ];
}
