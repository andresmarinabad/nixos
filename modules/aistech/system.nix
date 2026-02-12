{ ... }:
{
  imports = [
    ../system/common.nix
    ../agenix 
  ];
  
  # Añadir trabajo
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake .#aistech";
  };
}