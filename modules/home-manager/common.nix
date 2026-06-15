{ pkgs, ... }:
{

  # Herramientas para todos los perfiles
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];

  # Variables para el usuario
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # Teclado
  home.keyboard = {
    layout = "es";
  };

  home.stateVersion = "26.05";

  programs.plasma.powerdevil = {
    AC = {
      displayBrightness              = 100;
      autoSuspend.action             = "sleep";
      autoSuspend.idleTimeout        = 900;   # 15 min
      dimDisplay.enable              = true;
      dimDisplay.idleTimeout         = 300;   # 5 min
      turnOffDisplay.idleTimeout     = 600;   # 10 min
      turnOffDisplay.idleTimeoutWhenLocked = 60; # 1 min
      powerButtonAction              = "sleep";
      whenLaptopLidClosed            = "doNothing";
      powerProfile                   = "balanced";
    };
    battery = {
      displayBrightness              = 75;
      autoSuspend.action             = "sleep";
      autoSuspend.idleTimeout        = 300;   # 5 min
      dimDisplay.enable              = true;
      dimDisplay.idleTimeout         = 120;   # 2 min
      turnOffDisplay.idleTimeout     = 300;   # 5 min
      turnOffDisplay.idleTimeoutWhenLocked = 60; # 1 min
      powerButtonAction              = "sleep";
      whenLaptopLidClosed            = "sleep";
      powerProfile                   = "balanced";
    };
    lowBattery = {
      displayBrightness              = 50;
      autoSuspend.action             = "sleep";
      autoSuspend.idleTimeout        = 300;   # 5 min
      dimDisplay.enable              = true;
      dimDisplay.idleTimeout         = 60;    # 1 min
      turnOffDisplay.idleTimeout     = 120;   # 2 min
      turnOffDisplay.idleTimeoutWhenLocked = 60; # 1 min
      powerButtonAction              = "sleep";
      whenLaptopLidClosed            = "sleep";
      powerProfile                   = "powerSaving";
    };
  };
}
