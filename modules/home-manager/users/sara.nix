{ pkgs, lib, ... }:
{
  imports = [ ../common.nix ];

  home.username = "sara";
  home.homeDirectory = "/home/sara";

  home.packages = with pkgs; [
    spotify
  ];

  # Marcadores Chromium. Edita bookmarksList abajo y aplica con home-manager switch.
  xdg.configFile."chromium/Default/Bookmarks" = {
    force = true;
    text =
      let
        ts = "13304473600000000";
        bookmarksList = [
          {
            name = "Google";
            url = "https://www.google.com";
          }
          {
            name = "YouTube";
            url = "https://www.youtube.com";
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

  # Un solo navegador: Chromium con Bitwarden y restaurar sesión
  programs.chromium = {
    enable = true;
    commandLineArgs = [ "--restore-last-session" ];
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };

  programs.plasma = {
    enable = true;

    configFile.kdeglobals.General = {
      TerminalApplication = "kitty";
      TerminalService = "kitty.desktop";
    };

    # Workspace settings
    workspace = {
      lookAndFeel = "org.kde.breeze.desktop";
      colorScheme = "BreezeClassic";
      theme = "breeze";
      cursor.theme = "Breeze";
      iconTheme = "Breeze";
      wallpaper = ../../../assets/img/wallpaper/tren.jpg;
    };

    kwin = {
      virtualDesktops = {
        rows = 1;
        number = 2;
        names = [
          "Cole"
          "Personal"
        ];
      };
    };

    input.keyboard = {
      numlockOnStartup = "on";
    };

    # Fonts configuration
    fonts = {
      general = {
        family = "Inter";
        pointSize = 10;
      };
      fixedWidth = {
        family = "JetBrainsMono Nerd Font";
        pointSize = 10;
      };
      windowTitle = {
        family = "Kanit";
        pointSize = 11;
      };
    };

  };

  home.stateVersion = "26.05";

}
