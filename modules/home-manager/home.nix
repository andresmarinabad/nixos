{
  pkgs,
  secrets,
  ...
}:
{
  home.packages = with pkgs; [
    telegram-desktop
    wasistlos
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Andres Marin";
        email = "andres.marin.abad+git@gmail.com";
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
    profiles.default = {
      userSettings = {
        "editor.cursorBlinking" = "smooth";
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "window.commandCenter" = true;
        "workbench.colorTheme" = "Monokai";
        "workbench.tree.indent" = 24;
        "workbench.activityBar.orientation" = "vertical";
        "git.autofetch" = true;
        "vs-kubernetes" = {
          "vs-kubernetes.crd-code-completion" = "enabled";
        };
        "terminal.external.linuxExec" = "gnome-terminal";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "editor.fontFamily" = "'Fira Code Symbol'";
        "editor.inlayHints.fontFamily" = "Fira Code SymbolSymbol";
        "editor.codeLensFontFamily" = "Fira Code Symbol";
        "editor.inlineSuggest.fontFamily" = "Fira Code";
        "terminal.integrated.fontFamily" = "'Fira Code', 'Fira Code Symbol'";
        "docker.extension.experimental.composeCompletions" = true;
      };
      extensions = with pkgs.vscode-extensions; [
        golang.go
        matangover.mypy
        redhat.vscode-yaml
        charliermarsh.ruff
        ms-python.python
        ms-azuretools.vscode-docker
        jnoortheen.nix-ide
      ];
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
      "github.com" = {
        hostname = "github.com";
        identityFile = secrets.secret_andres_ssh_key.path;
        user = "git";
        port = 22;
      };
      "as.github.com" = {
        addKeysToAgent = "no";
        hostname = "github.com";
        identityFile = secrets.secret_gandalf_ssh_key.path;
        user = "git";
        port = 22;
      };
    };
  };

  services.ssh-agent.enable = true;

}
