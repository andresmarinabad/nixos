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
          home-manager.users = lib.mapAttrs (name: path: {
            imports = [ 
              path 
              plasma-manager.homeModules.plasma-manager 
            ];
          }) users;
        }
      ] ++ systemModules;
    };
  in {
    nixosConfigurations = {
      
      # PC DE TRABAJO (aistech)
      aistech = mkHost {
        hostName = "aistech";
        systemModules = [
          ./hosts/aistech/configuration.nix
          ./modules/system/aistech/system.nix
          agenix.nixosModules.default 
        ];
        users = {
          andres = import ./modules/home-manager/users/andres-aistech.nix;
          gandalf = import ./modules/home-manager/users/work.nix;
        };
      };

      # PC DE CASA (home)
      home = mkHost {
        hostName = "home";
        systemModules = [
          ./hosts/home/configuration.nix
          # el paquete de trazor tiene una vulnerabilidad
          {
            nixpkgs.config.permittedInsecurePackages = [
              "python3.13-ecdsa-0.19.1"
            ];
          }
          ./modules/system/andres/system.nix
          agenix.nixosModules.default
        ];
        users = {
          andres = import ./modules/home-manager/users/andres.nix;
          gandalf = import ./modules/home-manager/users/work.nix;
          sara = import ./modules/home-manager/users/sara.nix;
        };
      };
      
    };
  };
}