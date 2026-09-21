{
  description = "NixOS - Multi-host configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # MEGAsync se mantiene estable para no recompilarlo con cada actualización
    # del nixpkgs principal. Para actualizarlo, cambia esta revisión a mano.
    nixpkgs-megasync.url = "github:nixos/nixpkgs/9ae611a455b90cf061d8f332b977e387bda8e1ca";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    prismnix = {
      url = "github:qacow37/prismnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      plasma-manager,
      agenix,
      nix-index-database,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      # Función para configurar el sistema y HM
      mkHost =
        {
          hostName,
          systemModules,
          users,
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs hostName; };
          modules = [
            home-manager.nixosModules.home-manager
            nix-index-database.nixosModules.nix-index

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs hostName self; };
              # Mapeamos los usuarios
              home-manager.users = lib.mapAttrs (name: path: {
                imports = [
                  path
                  plasma-manager.homeModules.plasma-manager
                ];
              }) users;
            }
          ]
          ++ systemModules;
        };
    in
    {
      nixosConfigurations = {

        # PC DE CASA (home)
        home = mkHost {
          hostName = "home";

          systemModules = [
            ./hosts/home/configuration.nix
            agenix.nixosModules.default
          ];
          users = {
            andres =
              { ... }:
              {
                imports = [ ./modules/home-manager/users/andres ];
              };
            sara =
              { ... }:
              {
                imports = [ ./modules/home-manager/users/sara ];
              };
          };
        };
      };

      formatter.x86_64-linux = treefmt-nix.lib.mkWrapper pkgs {
        programs.nixfmt.enable = true;
      };

    };
}
