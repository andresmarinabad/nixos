{ pkgs, ... }: {
  # Herramientas para todos los perfiles
  home.packages = with pkgs; [
    htop
    curl
    wget
    docker-compose
    docker
    postman
    zsh
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    bitwarden-desktop
    gnomeExtensions.dash-to-dock
    gnome-tweaks
    nil 
    nixpkgs-fmt
  ];

  # Dock estilo ubuntu
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-fixed = true;               # Esto hace que no se oculte
      extend-height = false;           # Que no ocupe todo el espacio
      dock-position = "BOTTOM";        # Abajo como en mac
      dash-max-icon-size = 45;         # Tamaño de iconos
      show-mounts = true;              # Mostrar pendrives/discos
      pressure-threshold = 10;
      autohide = false;
      custom-theme-shrink = true;
      click-action = "previews";
      scroll-action = "cycle-windows";
    };
  };

  # Configuración de Brave
  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Extensión de Bitwarden para el navegador
    ];
  };

  # Varaibles para el usuario
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "brave";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # Teclado
  home.keyboard = {
    layout = "es";
  };

  # VIM
  programs.vim = {
  enable = true;
  plugins = with pkgs.vimPlugins; [
    vim-nix
    vim-airline
    nerdtree
    vim-gitgutter
    fzf-vim
    indentLine
  ];
  extraConfig = ''
    set relativenumber
    set shiftwidth=2
    set expandtab
    set number              " Mostrar números de línea
    set mouse=a             " Poder usar el ratón para hacer scroll
    set cursorline          " Resaltar la línea actual
    syntax enable           " Activar colores
    " Abrir NERDTree automáticamente con Ctrl+n
    map <C-n> :NERDTreeToggle<CR> 
  '';
};

  programs.git = {
    enable = true;
    extraConfig = {
        core.editor = "vim";
    };
  };

  # ZSH con OMZ
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .#linux";
      v = "vim";
      ns = "nix-shell -p";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "git" 
        "docker" 
        "sudo" 
        "python"
        "opentofu"
      ];
    };
  };

  # Starchip prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; 
    enableZshIntegration = true; 
  };

  # VSCode
  programs.vscode = {
    enable = true;
    package = pkgs.vscode; 

    # Extensiones para vscode
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide 
      mkhl.direnv 
      christian-kohler.path-intellisense
      naumovs.color-highlight
      eamodio.gitlens
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      pkief.material-icon-theme
      zhuangtongfa.material-theme
      redhat.ansible
      github.vscode-github-actions
      hashicorp.terraform
      esbenp.prettier-vscode
      ms-python.python
      davidanson.vscode-markdownlint
      ritwickdey.liveserver
      redhat.vscode-yaml
    ];

    # Configuración de settings.json
    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
      "editor.fontLigatures" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil"; # Un LSP rápido para Nix
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "git.autofetch" = true;
      "python.defaultInterpreterPath" = "./.venv/bin/python";
      "workbench.colorTheme" = "Default Dark+"; # Quiet Light
      "window.autoDetectColorScheme" = false;
    };
  };

  home.stateVersion = "26.05";
}
