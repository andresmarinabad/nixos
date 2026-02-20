{ ... }:
{
  imports = [
    ../common.nix
    ../../agenix
  ];

  # Añadir trabajo
  environment.shellAliases = {
    nr = "sudo nixos-rebuild switch --flake .#aistech";
  };

}
