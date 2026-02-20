{
  pkgs,
  lib,
  num_panels,
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
    "workbench.colorTheme" = "Default Dark+";
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
in

{
  imports = [
    ../common.nix
    (import ../../desktop/plasma.nix { inherit pkgs lib num_panels; })
  ];

  home.username = "andres";
  home.homeDirectory = "/home/andres";

  home.activation = {
    setupFlatpak = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      ${pkgs.flatpak}/bin/flatpak install --user --noninteractive flathub com.bambulab.BambuStudio
    '';
  };

  home.packages =
    with pkgs;
    [
      spotify
      calibre
      megasync
      telegram-desktop
      trezor-suite
      trezorctl
      code-cursor
      bat
      ripgrep
      curl
      wget
      docker-compose
      btop
      fzf
      protonvpn-gui
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
                name = "Home Manager";
                url = "https://nix-community.github.io/home-manager/";
              }
              {
                name = "Search NixOS pkgs";
                url = "https://search.nixos.org/packages";
              }
              {
                name = "Nixpkgs";
                url = "https://github.com/nixos/nixpkgs";
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
    settings.user.name = "Andres";
    settings.user.email = "andresmarinabad@protonmail.com";
    settings.core.editor = "vim";

    settings = {
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
  home.activation.installCursorExtensions = ''
    CURSOR="${pkgs.code-cursor}/bin/cursor"
    for ext in jnoortheen.nix-ide mkhl.direnv christian-kohler.path-intellisense naumovs.color-highlight eamodio.gitlens ms-azuretools.vscode-docker ms-vscode-remote.remote-ssh pkief.material-icon-theme zhuangtongfa.material-theme redhat.ansible github.vscode-github-actions hashicorp.terraform esbenp.prettier-vscode ms-python.python davidanson.vscode-markdownlint ritwickdey.liveserver redhat.vscode-yaml; do
      $CURSOR --install-extension "$ext" 2>/dev/null || true
    done
  '';

  home.stateVersion = "26.05";

}
