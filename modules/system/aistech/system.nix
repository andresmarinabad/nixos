{ ... }:
{
  imports = [
    ../common.nix
    ../../agenix
  ];

  # Añadir trabajo
  environment.shellAliases = {
    nr = "nh os switch -H aistech";
  };

}
