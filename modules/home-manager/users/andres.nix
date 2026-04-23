{
  pkgs,
  lib,
  hostName ? "home",
  self ? null,
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

  extensionIds = lib.concatMapStringsSep " " (ext: ext.vscodeExtUniqueId) vscodeExtensions;

  num_panels = if hostName == "aistech" then 3 else 1;

  wallpaperPath =
    if self != null then
      self + "/assets/img/wallpaper/desierto.jpeg"
    else
      ../../assets/img/wallpaper/desierto.jpeg;

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
        wallpaperPath
        ;
    })
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.packages =
    with pkgs;
    [
      spotify
      megasync
      telegram-desktop
      trezor-suite
      trezorctl
      bat
      ripgrep
      curl
      wget
      docker-compose
      btop
      fzf
      obs-studio
      gimp
      calibrePkg
      code-cursor
      bambu-studio

      (pkgs.writeShellScriptBin "cursor-sync-extensions" ''
        echo "Sincronizando extensiones de Cursor..."

        for ext in ${extensionIds}; do
          echo "Instalando: $ext"
          # Usamos el comando oficial de cursor
          cursor --install-extension "$ext" --force
        done

        echo "¡Sincronización completada!"
      '')
    ]
    ++ lib.optionals (hostName == "aistech") [
      k9s
      bruno
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.kubectl
      ])
    ];

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
            name = "Aistech";
            folder = true;
            children = [
              {
                name = "Mail";
                url = "https://mail.google.com/mail/u/0/#inbox";
              }
              {
                name = "Calendar";
                url = "https://calendar.google.com/calendar/u/0/r?pli=1";
              }
              {
                name = "GitHub";
                url = "https://github.com/orgs/aistechspace/repositories";
              }
              {
                name = "Jira";
                url = "https://aistechspace.atlassian.net/jira/software/c/projects/DIB/boards/306";
              }
              {
                name = "Odoo";
                url = "https://aistech-space-sl.odoo.com/odoo";
              }
              {
                name = "Bitwarden EU";
                url = "https://vault.bitwarden.eu/#/vault?organizationId=d9120928-f044-4e03-8124-b354009c7015&itemId=70759b4d-318e-48d3-9969-b38000a6df6f&action=view";
              }
              {
                name = "Hexagonal Architecture";
                url = "https://medium.com/@pthtantai97/hexagonal-architecture-with-golang-part-1-7f82a364b29";
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
          url."git@p.github.com:".insteadOf = "https://github.com/";
        };
      }
      {
        # Bloque TRABAJO
        condition = "gitdir:~/code/work/";
        contents = {
          user = {
            name = "Gandalf";
            email = "andres.marin@aistechspace.com";
          };
          url."git@github.com:".insteadOf = "https://github.com/";
        };
      }
    ];
  };

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
      "p.github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/andres";
        identitiesOnly = true;
      };

      # Aistech
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/gandalf";
        identitiesOnly = true;
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
        "copydir"
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
        ahead = "🏎💨";
        behind = "🐢";
        diverged = "😵";
        untracked = "🤷";
        modified = "📝";
        staged = "✅";
        deleted = "🗑️ ";
        renamed = "🔄 ";
        stashed = "📦 ";
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

  # Cursor: mismos settings y extensiones (mismo motor que VSCode)
  xdg.configFile."Cursor/User/settings.json".text = builtins.toJSON codeSettings;

  home.stateVersion = "26.05";

}
