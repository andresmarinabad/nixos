{
  description = "NixOS - Multi-host configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, agenix, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      # Función para configurar el sistema y HM
      mkHost = { hostName, systemModules, users }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs hostName; };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs hostName; };
            # Mapeamos los usuarios
            home-manager.users = lib.mapAttrs
              (name: path: {
                imports = [
                  path
                  plasma-manager.homeModules.plasma-manager
                ];
              })
              users;
          }
        ] ++ systemModules;
      };
    in
    {
      nixosConfigurations = {

        # PC DE TRABAJO (aistech)
        aistech = mkHost {
          hostName = "aistech";
          systemModules = [
            ./hosts/aistech/configuration.nix
            agenix.nixosModules.default
          ];
          users = {
            andres = { ... }: {
              imports = [ ./modules/home-manager/users/andres.nix ];
              _module.args.num_panels = 3;
            };
          };
        };

        # PC DE CASA (home)
        home = mkHost {
          hostName = "home";
          systemModules = [
            ./hosts/home/configuration.nix
            agenix.nixosModules.default
          ];
          users = {
            andres = { ... }: {
              imports = [ ./modules/home-manager/users/andres.nix ];
              _module.args.num_panels = 1;
            };
            sara = { ... }: {
              imports = [ ./modules/home-manager/users/sara.nix ];
            };
          };
        };

      };
    };
}
