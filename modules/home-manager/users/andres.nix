{
  pkgs,
  lib,
  hostName ? "home",
  ...
}:

let
  # Settings compartidos VSCode y Cursor
  codeSettings = {
    "editor.fontSize" = 14;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
    "editor.fontLigatures" = true;
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Default High Contrast";
    "window.autoDetectColorScheme" = false;
    "editor.formatOnSave" = true;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "git.autofetch" = true;
    "python.defaultInterpreterPath" = "./.venv/bin/python";
    # Nix: LSP nil + formatear al guardar
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.formatterPath" = "nixpkgs-fmt";
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };
    # Otros format-on-save por lenguaje
    "[json]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[yaml]" = {
      "editor.defaultFormatter" = "redhat.vscode-yaml";
    };
  };

  vscodeExtensions = with pkgs.vscode-extensions; [
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

  num_panels = if hostName == "work" then 3 else 1;

  calibrePkg = pkgs.callPackage ../../../pkgs/calibre.nix { };
in
{
  imports = [
    ../common.nix
    (import ../../desktop/plasma.nix {
      inherit
        pkgs
        lib
        num_panels
        ;
    })
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.packages = with pkgs; [
    spotify
    megasync
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
    calibrePkg
    wl-clipboard
    xclip
    bruno
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.kubectl
    ])
    chatgpt

  ];

  home.activation.visualSwitch = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    WALLPAPER_DIR="$HOME/.local/share/wallpapers"

    TIMESTAMP=$(date +%s)
    WALLPAPER_FILE="$WALLPAPER_DIR/switch-$TIMESTAMP.jpg"
    LOG_FILE="$WALLPAPER_DIR/wallpaper-switch.log"

    mkdir -p "$WALLPAPER_DIR"

    echo "🎨 Iniciando descarga de fondo..." > "$LOG_FILE"

    if ${pkgs.curl}/bin/curl -sL --max-time 10 "https://picsum.photos/3840/2160?random=$RANDOM" -o "$WALLPAPER_FILE"; then
      echo "✅ Imagen descargada correctamente." >> "$LOG_FILE"
      
      export XDG_RUNTIME_DIR="/run/user/$(id -u)"
      export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
      export WAYLAND_DISPLAY="wayland-0"
      export DISPLAY=":0"
      
      echo "🖥️ Enviando orden directa a Plasma..." >> "$LOG_FILE"
      
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage "$WALLPAPER_FILE" >> "$LOG_FILE" 2>&1
      
      echo "🎉 Proceso terminado." >> "$LOG_FILE"
    else
      echo "❌ Fallo al descargar la imagen." >> "$LOG_FILE"
    fi
  '';

  home.activation = {
    setupFlatpak = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

      if ! ${pkgs.flatpak}/bin/flatpak info --user com.bambulab.BambuStudio > /dev/null 2>&1; then
        echo "📥 Instalando Bambu Studio vía Flatpak por primera vez..."
        ${pkgs.flatpak}/bin/flatpak install --user --noninteractive flathub com.bambulab.BambuStudio
      else
        echo "✅ Bambu Studio ya está instalado. Saltando..."
      fi
    '';
  };

  # Marcadores Brave: basado en marcadores.html + carpeta NixOS.
  xdg.configFile."BraveSoftware/Brave-Browser/Default/Bookmarks" = {
    force = true; # sobrescribir si ya existe (gestionado por Nix)
    text =
      let
        ts = "13304473600000000";
        bookmarksList = [
          {
            name = "Personal";
            folder = true;
            children = [
              {
                name = "Mail";
                url = "https://mail.proton.me/u/0/inbox";
              }
              {
                name = "GitHub";
                url = "https://github.com/andresmarinabad?tab=repositories";
              }
            ];
          }
          {
            name = "NixOS";
            folder = true;
            children = [
              {
                name = "NixOS";
                url = "https://nixos.org";
              }
              {
                name = "Search NixOS pkgs";
                url = "https://search.nixos.org/packages";
              }
              {
                name = "MyNixOSSS";
                url = "https://mynixos.com/";
              }
            ];
          }
          {
            name = "3D";
            folder = true;
            children = [
              {
                name = "Thingivers";
                url = "https://www.thingiverse.com/";
              }
              {
                name = "MakerWorld";
                url = "https://makerworld.com/es";
              }
              {
                name = "Printables";
                url = "https://www.printables.com/store";
              }
              {
                name = "Tinkercad";
                url = "https://www.tinkercad.com/";
              }
            ];
          }
        ];
        processItem =
          item: id:
          if item ? url then
            {
              node = {
                id = toString id;
                type = "url";
                name = item.name;
                url = item.url;
                date_added = ts;
                date_modified = ts;
              };
              nextId = id + 1;
            }
          else
            let
              processed =
                lib.foldl
                  (
                    acc: child:
                    let
                      r = processItem child acc.nextId;
                    in
                    {
                      nodes = acc.nodes ++ [ r.node ];
                      nextId = r.nextId;
                    }
                  )
                  {
                    nodes = [ ];
                    nextId = id + 1;
                  }
                  item.children;
            in
            {
              node = {
                id = toString id;
                type = "folder";
                name = item.name;
                date_added = ts;
                date_modified = ts;
                children = processed.nodes;
              };
              nextId = processed.nextId;
            };
        barProcessed =
          lib.foldl
            (
              acc: item:
              let
                r = processItem item acc.nextId;
              in
              {
                nodes = acc.nodes ++ [ r.node ];
                nextId = r.nextId;
              }
            )
            {
              nodes = [ ];
              nextId = 10;
            }
            bookmarksList;
        roots = {
          bookmark_bar = {
            id = "1";
            type = "folder";
            name = "Bookmarks bar";
            date_added = ts;
            date_modified = ts;
            children = barProcessed.nodes;
          };
          other = {
            id = "2";
            type = "folder";
            name = "Other Bookmarks";
            date_added = ts;
            date_modified = ts;
            children = [ ];
          };
          synced = {
            id = "3";
            type = "folder";
            name = "Mobile bookmarks";
            date_added = ts;
            date_modified = ts;
            children = [ ];
          };
        };
      in
      builtins.toJSON {
        version = 1;
        roots = roots;
      };
  };

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

    settings = {
      core = {
        editor = "vim";
      };

    };

    includes = [
      {
        # Bloque PERSONAL
        condition = "gitdir:~/code/personal/";
        contents = {
          user = {
            name = "Andrés";
            email = "andresmarinabad@protonmail.com";
          };
          url."git@github.com:".insteadOf = "https://github.com/";
        };
      }
    ];
  };

  # GitHub Public Key
  home.file.".ssh/andres.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqImXgnyR1mINurbZY0xV5EJmKUQWGv6BxQihpsgxiD";

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
        identitiesOnly = true;
      };

      # Work
      # "github.com" = {
      #   hostname = "github.com";
      #   user = "git";
      #   identityFile = "~/.ssh/gandalf";
      #   identitiesOnly = true;
      # };
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

      tg = "terragrunt";
      tgi = "terragrunt init --terragrunt-non-interactive";
      tgp = "terragrunt plan --terragrunt-non-interactive";
      tga = "terragrunt apply --terragrunt-non-interactive";
      tgd = "terragrunt destroy";

      # Alias para comandos "run-all"
      tgia = "terragrunt run-all init --terragrunt-non-interactive";
      tgpa = "terragrunt run-all plan --terragrunt-non-interactive";
      tgaa = "terragrunt run-all apply --terragrunt-non-interactive";

    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "sudo"
        "python"
        "opentofu"
        "docker-compose"
        "extract"
        "copypath"
        "copyfile"
        "z"

      ];
    };
  };

  # Starchip prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;

      # 1. El símbolo del prompt (cambia de color si el comando anterior falló)
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      # 2. ¡Imprescindible en NixOS! Te avisa cuando entras en un nix-shell o devShell
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \\($name\\))]($style) ";
      };

      # 3. Tiempo de ejecución: Te dice cuánto tardó un comando si pasa de los 2 segundos (ideal para builds o OpenTofu)
      cmd_duration = {
        min_time = 2000;
        format = "⏱ [$duration]($style) ";
      };

      # 4. Git vitaminado: Símbolos visuales para saber exactamente el estado de tu repo
      git_branch = {
        symbol = "🌱 ";
      };
      git_status = {
        conflicted = "⚔️";
        ahead = "🚀";
        behind = "🐢";
        diverged = "😵";
        untracked = "🤷";
        modified = "📝";
        staged = "✅";
        deleted = "🗑️";
        renamed = "🔄";
        stashed = "📦";
      };

      # 5. Tus herramientas del día a día
      python = {
        symbol = "🐍 ";
        format = "via [$symbol$version (\\($virtualenv\\))]($style) ";
      };

      docker_context = {
        symbol = "🐳 ";
      };

      terraform = {
        symbol = "🏗️ "; # Este módulo también detecta OpenTofu automáticamente
      };

      aws = {
        symbol = "☁️ ";
        disabled = false; # Cambia a true si no quieres ver tu perfil de AWS todo el rato
      };

      # 6. Limpieza: Oculta cosas que hacen ruido visual
      package = {
        disabled = true; # Oculta la versión de Node/Rust/etc en cada directorio para que no moleste
      };

    };
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # VSCode con extensiones y misma config
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = vscodeExtensions;
      userSettings = codeSettings;
    };
  };

  home.stateVersion = "26.05";

}
