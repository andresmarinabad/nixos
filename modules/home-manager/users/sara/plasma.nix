{ ... }:

{
  programs.plasma = {
    enable = true;

    configFile.kdeglobals.General = {
      TerminalApplication = "kitty";
      TerminalService = "kitty.desktop";
    };

    workspace = {
      lookAndFeel = "org.kde.breeze.desktop";
      colorScheme = "BreezeClassic";
      theme = "breeze";
      cursor.theme = "Breeze";
      iconTheme = "Breeze";
      wallpaperPictureOfTheDay = {
        provider = "bing";
      };
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
}
