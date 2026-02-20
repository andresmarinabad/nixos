{
  pkgs,
  lib,
  num_panels,
  wallpaperPath ? ../../assets/img/wallpaper/desierto.jpeg,
  ...
}:

{
  home.packages = with pkgs; [
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.kcalc
    kdePackages.partitionmanager
    kdePackages.filelight
    kdePackages.kate
    papirus-icon-theme
    fastfetch
  ];

  programs.plasma = {
    enable = true;

    configFile.kdeglobals.General = {
      TerminalApplication = "kitty";
      TerminalService = "kitty.desktop";
    };

    # Workspace settings
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      theme = "breeze-dark";
      cursor.theme = "Breeze";
      iconTheme = "Papirus-Dark";
      wallpaper = wallpaperPath;
    };

    kwin = {
      virtualDesktops = {
        rows = 2;
        number = 4;
        names = [
          "Desktop 1"
          "Desktop 2"
          "Desktop 3"
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

    # Shortcuts
    shortcuts = {
      "services/kitty.desktop" = {
        "_launch" = [
          "Ctrl+Alt+T"
        ];
      };
      "services/org.kde.spectacle.desktop" = {
        "RectangularRegionScreenShot" = [
          "Print"
          "Meta+Shift+S"
        ];
      };
    };

    # Panel configuration (un panel por pantalla: 0, 1, 2 en aistech; 1 en home)
    panels = lib.genList (i: {
      location = "bottom";
      screen = i;
      height = 46;
      floating = true;
      widgets = [
        "org.kde.plasma.kickoff"
        {
          name = "org.kde.plasma.pager";
          config = {
            General.showOnlyCurrentScreen = true;
            General.showWindowIcons = false;
          };
        }
        "org.kde.plasma.taskmanager"
        "org.kde.plasma.marginsseparator"
        "org.kde.plasma.systemtray"
        {
          name = "org.kde.plasma.digitalclock";
          config = {
            Appearance = {
              firstDayOfWeek = "monday";
              showWeekNumbers = true;
              showSeconds = "Always";
            };
          };
        }
        "org.kde.plasma.showdesktop"
      ];
    }) num_panels;

    # Window rules
    window-rules = [
    ];

    configFile."kwinrc"."Plugins"."magiclampEnabled" = true;
    configFile."kwinrc"."Effect-magiclamp"."AnimationDuration" = 250;

    configFile."kwinrc"."Effect-Blur"."BlurRadius" = 12;
    configFile."kwinrc"."Effect-Blur"."NoiseStrength" = 10;

  };

  programs.kitty = {
    enable = true;
    themeFile = "Monokai";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };
  };

  programs.konsole.enable = false;

  home.stateVersion = "26.05";
}
