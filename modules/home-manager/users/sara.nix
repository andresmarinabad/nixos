{ pkgs, ... }:
{
  imports = [ ../common.nix ];

  home.username = "sara";
  home.homeDirectory = "/home/sara";

  home.packages = with pkgs; [
    spotify
  ];

  programs.google-chrome = {
    enable = true;
    commandLineArgs = [ "--restore-last-session" ];
  };

  programs.chromium = {
    enable = true;
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
      general = { family = "Inter"; pointSize = 10; };
      fixedWidth = { family = "JetBrainsMono Nerd Font"; pointSize = 10; };
      windowTitle = { family = "Kanit"; pointSize = 11; };
    };

  };

  home.stateVersion = "26.05"; 

}
