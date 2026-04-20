{
  pkgs,
  writeShellScriptBin,
  symlinkJoin,
  ...
}:

let
  calibre-custom = pkgs.calibre.overrideAttrs (oldAttrs: {
    qtWrapperArgs = (oldAttrs.qtWrapperArgs or [ ]) ++ [
      "--set"
      "CALIBRE_CONFIG_DIRECTORY"
      "/home/andres/MEGA/Calibre/Config"
      "--set"
      "OSCRYPTO_LIBCRYPTO_PATH"
      "${pkgs.openssl.out}/lib/libcrypto.so"
      "--set"
      "OSCRYPTO_LIBSSL_PATH"
      "${pkgs.openssl.out}/lib/libssl.so"
    ];
  });

  calibre-safe = writeShellScriptBin "calibre" ''
    MEGA_COUNT=$(${pkgs.procps}/bin/pgrep -i -c "megasync")

    if [ "$MEGA_COUNT" -eq 0 ]; then
      ${pkgs.kdePackages.kdialog}/bin/kdialog \
        --title "Protección de Calibre" \
        --error "MEGA no se está ejecutando.\n\nPor seguridad, Calibre no se abrirá para evitar desincronizar tu biblioteca.\n\n(Procesos encontrados: $MEGA_COUNT)"
      exit 1
    fi

    exec ${calibre-custom}/bin/calibre "$@"
  '';

in
symlinkJoin {
  name = "calibre-safe";
  paths = [
    calibre-safe
    calibre-custom
  ];
}
