{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "cursor";
  version = "3.1.15";

  src = fetchurl {
    # Usamos la URL exacta de la versión 3.1.15 para evitar fallos de DNS con el redireccionador
    url = "https://downloads.cursor.com/production/3a67af7b780e0bfc8d32aefa96b8ff1cb8817f88/linux/x64/Cursor-${version}-x86_64.AppImage";
    hash = "sha256-7Lgrb0SAkkm8+LZInhXLrQHoDLJa63+KvGStp03jepc=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Librerías esenciales para que Cursor (basado en Electron) no falle
  extraPkgs =
    pkgs: with pkgs; [
      libsecret
      libxkbcommon
      icu
      openssl
      zlib
      at-spi2-atk
      mesa
    ];

  extraInstallCommands = ''
    # Instalamos el icono para que aparezca en el menú de Plasma
    install -m 444 -D ${appimageContents}/cursor.desktop $out/share/applications/cursor.desktop

    # Corregimos la ruta del ejecutable en el acceso directo
    substituteInPlace $out/share/applications/cursor.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname} --no-sandbox'

    # Copiamos los iconos a la carpeta del sistema
    cp -r ${appimageContents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "AI-powered code editor built on VS Code";
    homepage = "https://cursor.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cursor";
  };
}
