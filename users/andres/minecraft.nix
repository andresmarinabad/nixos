{ pkgs, inputs, ... }:

let
  prismPkgs = pkgs.extend inputs.prismnix.overlays.default;
  serversDat = pkgs.runCommand "minecraft-servers.dat" { } ''
    printf '%s' 'CgAACQAHc2VydmVycwoAAAABCAACaXAAD2xvY2FsaG9zdDoyNTU2MwgABG5hbWUAFVNlcnZpZG9yIGRlIE1pbmVjcmFmdAAA' \
      | ${pkgs.coreutils}/bin/base64 --decode > "$out"
  '';
in
{
  imports = [
    inputs.prismnix.homeModules.prismnix
  ];

  programs.prismnix = {
    enable = true;

    instances."Minecraft 1.21.4" = {
      file."servers.dat" = {
        source = serversDat;
        target = "servers.dat";
        copy = true;
      };

      minecraft = {
        enable = true;
        version = "1.21.4";

        mod-loader = {
          enable = true;
          loader = "fabric";
        };

        shader-loader = {
          enable = true;
          loader = "iris";
        };

        packages = [
          # Dependencias
          prismPkgs.prismnix.fabric-api
          prismPkgs.prismnix.architectury-api
          prismPkgs.prismnix.cloth-config
          prismPkgs.prismnix.fabric-language-kotlin
          prismPkgs.prismnix.libipn
          prismPkgs.prismnix.balm

          # Rendimiento
          prismPkgs.prismnix.sodium
          prismPkgs.prismnix.lithium
          prismPkgs.prismnix.ferrite-core
          prismPkgs.prismnix.entityculling
          prismPkgs.prismnix.immediatelyfast

          # Recetas e información
          prismPkgs.prismnix.rei
          prismPkgs.prismnix.jade
          prismPkgs.prismnix.appleskin
          prismPkgs.prismnix.mouse-tweaks

          # Inventario
          prismPkgs.prismnix.inventory-profiles-next

          # Mapas
          prismPkgs.prismnix.xaeros-minimap
          prismPkgs.prismnix.xaeros-world-map

          # Exploración
          prismPkgs.prismnix.dungeons-and-taverns
          prismPkgs.prismnix.waystones

          # Shaders
          prismPkgs.prismnix.complementary-reimagined
        ];

        default-links.enable = true;
        allowed-symlinks.enable = true;
      };

      config.memory = {
        override = true;
        min = 2048;
        max = 4096;
      };
    };
  };
}
