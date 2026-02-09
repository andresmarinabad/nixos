{ pkgs, config, ... }:
{
  # Bootloader y Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Red
  networking.networkmanager.enable = true;

  # Reloj
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    description = "Andrés";
    hashedPasswordFile = config.age.secrets.pass-andres.path;
  };

  users.users.gandalf = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "docker"
      "wheel"
    ];
    description = "Gandalf";
    hashedPasswordFile = config.age.secrets.pass-gandalf.path;
  };

  # users.users.sara = {
  #   isNormalUser = true;
  #   shell = pkgs.bash;
  #   extraGroups = [ "networkmanager" ];
  #   description = "Sara";
  #   hashedPasswordFile = config.age.secrets.pass-sara.path;
  # };

  # Habilitar el entorno de escritorio (ejemplo con GNOME)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Quitar default apps
  services.xserver.excludePackages = with pkgs; [ xterm ];
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    yelp
    gnome-contacts
    gnome-weather
  ];

  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    # Esto asegura que se generen las llaves de host si no existen
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
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Quitar nano del sistema
  programs.nano.enable = false;
  
  # VIM Global (en configuration.nix)
  environment.systemPackages = [
    (pkgs.vim-full.customize {
      name = "vim";
      # Aquí va tu configuración (el antiguo extraConfig)
      vimrcConfig.customRC = ''
        " set relativenumber
        set shiftwidth=2
        set expandtab
        set number              " Mostrar números de línea
        set mouse=a             " Poder usar el ratón para hacer scroll
        set cursorline          " Resaltar la línea actual
        syntax enable           " Activar colores

        " Abrir NERDTree automáticamente con Ctrl+n
        map <C-n> :NERDTreeToggle<CR> 
        " Busqueda con fzf
        map <C-p> :Files<CR>
      '';

      # Aquí van los plugins
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ 
          vim-nix
          vim-airline
          nerdtree
          vim-gitgutter
          fzf-vim
          indentLine
        ];
      };
    })
  ];

  # Esto asegura que este Vim sea el editor por defecto
  environment.variables.EDITOR = "vim";
}
