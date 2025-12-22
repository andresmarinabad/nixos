{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    modules.developer-tools = {
      enable = lib.mkEnableOption "Enable developer tools";
    };
  };

  config = lib.mkIf config.modules.developer-tools.enable {
    environment.systemPackages = with pkgs; [
      vscode
      slack
      buf
      mypy
      postman
      jq
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
      dbeaver-bin
    ];  

  };


}
