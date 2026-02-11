{
  description = "Mi configuracion de NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      agenix,
      ...
    }:
    {
      nixosConfigurations.linux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/linux/configuration.nix
          {
            nixpkgs.config.permittedInsecurePackages = [
              "python3.13-ecdsa-0.19.1"
            ];
          }
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.andres = import ./modules/users/home.nix;
            home-manager.users.gandalf = import ./modules/users/work.nix;
            # home-manager.users.sara = import ./modules/users/sara.nix;
          }
        ];
      };
    };
}
