{
  pkgs,
  secrets,
  ...
}:
{
  home.packages = with pkgs; [
    telegram-desktop
    gemini-cli
  ];

  programs.ruff = {
    enable = true;
    settings = {
    };
  };

  programs.uv.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Gandalf";
        email = "andres.marin@aistechspace.com";
      };
      url."git@github.com:aistechspace/".insteadOf = [ "https://github.com/aistechspace/" ];
      rerere.enabled = true;
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

        "editor.fontFamily" = "'JetBrainsMono Nerd Font'";
        "editor.fontWeight" = "Regular";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;

        "terminal.external.linuxExec" = "gnome-terminal";
        "terminal.integrated.defaultProfile.linux" = "fish";
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "terminal.integrated.fontWeight" = "Regular";
        "terminal.integrated.fontLigatures" = true;
        "terminal.integrated.fontSize" = 14;

        "docker.extension.experimental.composeCompletions" = true;
        "terminal.integrated.commandsToSkipShell" = [ "-cursorai.action.generateInTerminal" ];
        "remote.SSH.useLocalServer" = false;
        "[dockercompose]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoIndent" = "advanced";
          "editor.quickSuggestions" = {
            "other" = true;
            "comments" = false;
            "strings" = true;
          };
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
      };

      extensions =
        with pkgs.vscode-extensions;
        [
          golang.go
          matangover.mypy
          redhat.vscode-yaml
          charliermarsh.ruff
          ms-python.python
          eamodio.gitlens
          ms-azuretools.vscode-docker
          jnoortheen.nix-ide
          ms-python.python
          github.vscode-github-actions
          #google.gemini-cli-vscode-ide-companion
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "gemini-cli-vscode-ide-companion";
            publisher = "google";
            version = "0.20.0";
            sha256 = "sha256-gJ7ghOOrk4kvzReqfB6ZRhFonOdpJXcPh7voBgCwqPg=";
          }
          {
            name = "vscode-coverage-gutters";
            publisher = "ryanluker";
            version = "2.14.0";
            sha256 = "sha256-waF3FmncUsXqWFWGRy9X7RQ29BDRYlaqyFhEXg4HXNo=";
          }
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
        identityFile = secrets.secret_gandalf_ssh_key.path;
        user = "git";
        port = 22;
      };
      "p.github.com" = {
        addKeysToAgent = "no";
        hostname = "github.com";
        identityAgent = "none";
        identityFile = secrets.secret_andres_ssh_key.path;
        user = "git";
        port = 22;
      };
    };
  };

  services.ssh-agent.enable = true;

}
