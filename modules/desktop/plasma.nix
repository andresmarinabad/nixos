{ pkgs, ... }:

{
  # 1. Escritorio y Gestor de Sesión (SDDM + Plasma 6)
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # 2. Fuentes Pro (Inter para UI, Kanit para títulos)
  fonts.packages = with pkgs; [
    inter
    kanit-font
  ];

  # 3. Aplicaciones y Herramientas Visuales (Ecosistema Pro)
  environment.systemPackages = with pkgs; [
    # Utilidades que pediste
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.kcalc
    kdePackages.partitionmanager
    kdePackages.filelight
    kdePackages.kate
    
    # Herramientas de personalización estética
    kdePackages.qtstyleplugin-kvantum # Motor para transparencias pro
    catppuccin-kde                    # Temas de colores modernos
    papirus-icon-theme                # Pack de iconos muy completo
    catppuccin-papirus-folders        # Variantes de color para los iconos
    fastfetch                         # Para fardar de sistema en la terminal
  ];

  # 4. Limpieza: Quitar lo que no necesitas
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa               # Reproductor de música
    konqueror           # Navegador antiguo
  ];

  # 5. Integración de Portales (KDE Edition)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.plasma.default = [ "kde" ];
  };

  # 6. Soporte Estético y Compatibilidad
  programs.dconf.enable = true;
  
  # Forzamos Kvantum para permitir efectos de transparencia avanzados
  qt = {
    enable = true;
    platformTheme = "kde";
    style = "kvantum";
  };

  # Optimización para que las apps GTK (Gnome) se vean bien en Plasma
  environment.variables.GDK_BACKEND = "wayland,x11";
}