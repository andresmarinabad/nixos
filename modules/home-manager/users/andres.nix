{ pkgs, ... }:

let
  codeSettings = {
    "editor.fontSize" = 14;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
    "editor.fontLigatures" = true;
    "workbench.iconTheme" = "material-icon-theme";
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "editor.formatOnSave" = true;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "git.autofetch" = true;
    "python.defaultInterpreterPath" = "./.venv/bin/python";
    "workbench.colorTheme" = "Default Dark+";
    "window.autoDetectColorScheme" = false;
  };
in

{
  imports = [ ../common.nix ../desktop/plasma.nix ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.activation = {
    setupFlatpak = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      ${pkgs.flatpak}/bin/flatpak install --user --noninteractive flathub com.bambulab.BambuStudio
    '';
  };

  home.packages = with pkgs; [
    spotify
    calibre
    megasync
    telegram-desktop
    trezor-suite
    trezorctl
    code-cursor
    lens
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.kubectl
    ])
    bottom
    bat
    ripgrep
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
    nixfmt
    fzf
    protonvpn-gui
    protonmail-desktop
  ];

  # Configuración de Brave
  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };

  # GIT
  programs.git = {
    enable = true;
    settings.user.name = "Andres";
    settings.user.email = "andresmarinabad@protonmail.com";
    settings.core.editor = "vim";

    extraConfig = {
      includeIf."gitdir:~/code/work/" = {
        path = "~/code/work/.gitconfig-work";
      };
    };
  };

  home.file."code/work/.gitconfig-work".text = ''
    [user]
      name = "Gandalf"
      email = "andres.marin@aistechspace.com"
  '';

  # GitHub Public Key
  home.file.".ssh/andres.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqImXgnyR1mINurbZY0xV5EJmKUQWGv6BxQihpsgxiD";

  # Aistech GitHub Public Key
  home.file.".ssh/gandalf.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICi4Cx3fx7uXitvSOTBzTRsi1ATKLI8dDs0RZy8iKp5c andres.marin@aistechspace.com";


  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      # Personal
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/andres";
      };

      # Aistech
      "as.github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/gandalf";
      };
    };
  };

  # MEGA (para calibre sobretodo)
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

  # ZSH con OMZ
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
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
      add_newline = true;
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
    profiles.default.extensions = with pkgs.vscode-extensions; [
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
    profiles.default.userSettings = codeSettings;
  };

  # Sinc settigns de vscode con cursor
  xdg.configFile."Cursor/User/settings.json".text = builtins.toJSON codeSettings;

  home.stateVersion = "26.05"; 

}

