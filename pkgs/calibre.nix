{
  pkgs,
  writeShellScriptBin,
  symlinkJoin,
  ...
}:

let
  calibre-safe = writeShellScriptBin "calibre" ''
    MEGA_COUNT=$(${pkgs.procps}/bin/pgrep -i -c "megasync")

    if [ "$MEGA_COUNT" -eq 0 ]; then
      ${pkgs.kdePackages.kdialog}/bin/kdialog \
        --title "Protección de Calibre" \
        --error "MEGA no se está ejecutando.\n\nPor seguridad, Calibre no se abrirá para evitar desincronizar tu biblioteca.\n\n(Procesos encontrados: $MEGA_COUNT)"
      exit 1
    fi

    export CALIBRE_CONFIG_DIRECTORY="/home/andres/MEGA/Calibre/Config"
    export OSCRYPTO_LIBCRYPTO_PATH="${pkgs.openssl.out}/lib/libcrypto.so"
    export OSCRYPTO_LIBSSL_PATH="${pkgs.openssl.out}/lib/libssl.so"

    exec ${pkgs.calibre}/bin/calibre "$@"
  '';

in
symlinkJoin {
  name = "calibre-safe";
  paths = [
    calibre-safe
    pkgs.calibre
  ];
}
