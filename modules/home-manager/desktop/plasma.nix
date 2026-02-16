# home.nix
{ pkgs, ... }:

{
  # Apps y Estética
  home.packages = with pkgs; [
    inter kanit-font
    kdePackages.spectacle kdePackages.ark kdePackages.gwenview
    kdePackages.kcalc kdePackages.partitionmanager kdePackages.filelight
    kdePackages.kate kdePackages.qtstyleplugin-kvantum
    papirus-icon-theme fastfetch klassy
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

    # 1. Forzamos a KWin a usar Klassy como decorador de ventanas
    configFile."kwinrc"."org.kde.kdecoration2"."library" = "org.kde.klassy";
    configFile."kwinrc"."org.kde.kdecoration2"."theme" = "org.kde.klassy";

    # 2. Configuración "Chula" de Klassy (Efectos Visuales)
    configFile."klassyrc"."Common"."CornerRadius" = 12; # Esquinas bien redondeadas
    configFile."klassyrc"."Common"."ThinWindowFrames" = true; # Bordes finos y elegantes
    
    # 3. Botones "Top" (Tamaño y Estilo)
    # Aquí puedes poner "Breeze", "macOS", "Windos", etc.
    configFile."klassyrc"."Common"."ButtonIconStyle" = "Breeze"; 
    configFile."klassyrc"."Common"."ButtonSize" = 2; # 2 es "Large", más fácil de clicar
    configFile."klassyrc"."Common"."ButtonSpacing" = 4; # Más espacio entre botones para que respiren
    
    # 4. Color del borde (Para que resalten las ventanas)
    configFile."klassyrc"."WindEco"."ActiveWindowFrameColor" = "AccentColor";
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