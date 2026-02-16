# home.nix
{ pkgs, ... }:

{
  # Apps y Estética
  home.packages = with pkgs; [
    inter kanit-font
    kdePackages.spectacle kdePackages.ark kdePackages.gwenview
    kdePackages.kcalc kdePackages.partitionmanager kdePackages.filelight
    kdePackages.kate kdePackages.qtstyleplugin-kvantum
    catppuccin-kde papirus-icon-theme fastfetch
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      cursorTheme = "Breeze";
      theme = "breeze-dark";
      iconTheme = "Papirus-Dark";
      colorScheme = "BreezeDark";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patina/contents/images/5120x2880.jpg";
    };

    fonts = {
      general = { family = "Inter"; pointSize = 10; };
      fixedWidth = { family = "JetBrainsMono Nerd Font"; pointSize = 10; };
      windowTitle = { family = "Kanit"; pointSize = 11; };
    };

    kwin = {
      effects = {
        blur.enable = true;
        translucency.enable = true;
      };
      scripts.polonium.enable = false;
    };

    configFile."kwinrc"."Plugins"."magiclampEnabled" = true;

    panels = [
      {
        location = "bottom";
        height = 44;
        floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks" 
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };

  # Forzar estética Kvantum para transparencias
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  programs.konsole = {
    enable = true;
    defaultProfile = "NixConfig";
    profiles.NixConfig = {
      colorScheme = "Breeze";
      font.name = "JetBrainsMono Nerd Font";
      font.size = 11;
    };
  };

  # Esto asegura que las variables de entorno fuercen el modo oscuro
  home.sessionVariables = {
    "COLORTERM" = "truecolor";
  };
}