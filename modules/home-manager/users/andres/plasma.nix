{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.desktop.plasma.numPanels = lib.mkOption {
    type = lib.types.int;
    default = 1;
    description = "Number of taskbar panels, one per screen.";
  };

  config = {
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
        TerminalApplication = "ghostty";
        TerminalService = "ghostty.desktop";
      };

      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        colorScheme = "BreezeDark";
        theme = "breeze-dark";
        cursor.theme = "Breeze";
        iconTheme = "Papirus-Dark";
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

      shortcuts = {
        "services/ghostty.desktop" = {
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
          {
            name = "org.kde.plasma.taskmanager";
            config = {
              General.launchers = lib.concatStringsSep "," [
                "applications:org.kde.dolphin.desktop"
                "applications:ghostty.desktop"
                "applications:brave-browser.desktop"
                "applications:code.desktop"
              ];
            };
          }
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
      }) config.desktop.plasma.numPanels;

      window-rules = [ ];

      configFile."kwinrc"."Plugins"."magiclampEnabled" = true;
      configFile."kwinrc"."Effect-magiclamp"."AnimationDuration" = 250;
      configFile."kwinrc"."Plugins"."translucencyEnabled" = true;

      configFile."kwinrc"."Effect-Blur"."BlurRadius" = 12;
      configFile."kwinrc"."Effect-Blur"."NoiseStrength" = 10;
    };

    programs.ghostty = {
      enable = true;

      settings = {
        theme = "Doom One";

        font-family = "JetBrainsMono Nerd Font";
        font-size = 14;

        background-opacity = 0.95;
        background-blur = true;

        shell-integration = "zsh";

        keybind = [
          "ctrl+backspace=text:\\x15"
        ];
      };
    };

    programs.konsole.enable = false;
  };
}
