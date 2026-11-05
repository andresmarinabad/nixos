{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # MEGAsync se mantiene estable para evitar recompilaciones
    nixpkgs-megasync.url = "github:nixos/nixpkgs/9ae611a455b90cf061d8f332b977e387bda8e1ca";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      system = "x86_64-linux";
      hostName = "Nix";

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs hostName;
        };

        modules = [
          ./hosts/home/configuration.nix

          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          nix-index-database.nixosModules.nix-index

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = {
                inherit inputs self hostName;
              };

              users.andres = {
                imports = [
                  ./users/andres
                  plasma-manager.homeModules.plasma-manager
                ];
              };
            };
          }
        ];
      };

      formatter.${system} = treefmt-nix.lib.mkWrapper pkgs {
        programs.nixfmt.enable = true;
      };
    };
}
