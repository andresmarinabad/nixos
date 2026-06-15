{ pkgs, ... }:

let
  codeSettings = {
    "editor.fontSize" = 14;
    "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
    "editor.fontLigatures" = true;
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Default High Contrast";
    "window.autoDetectColorScheme" = false;
    "editor.formatOnSave" = true;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "git.autofetch" = true;
    "python.defaultInterpreterPath" = "./.venv/bin/python";
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.formatterPath" = "nixpkgs-fmt";
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };
    "[json]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[yaml]" = {
      "editor.defaultFormatter" = "redhat.vscode-yaml";
    };

    "claudeCode.claudeProcessWrapper" = "${pkgs.claude-code}/bin/claude";
  };

  vscodeExtensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    esbenp.prettier-vscode
    ms-python.python
    eamodio.gitlens
    hashicorp.terraform
    vscode-icons-team.vscode-icons
    anthropic.claude-code
  ];
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = vscodeExtensions;
      userSettings = codeSettings;
    };
  };

  home.packages = [ pkgs.claude-code ];
}
