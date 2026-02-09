{ pkgs, ... }:
{
  # Herramientas developers
  imports = [ ./basic.nix ];

  home.packages = with pkgs; [
    bottom
    bat
    ripgrep
    curl
    wget
    docker-compose
    docker
    postman
    zsh
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    nixfmt
    fzf
    google-cloud-sdk
  ];

  # Configuración de Brave
  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Extensión de Bitwarden para el navegador
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      core.editor = "vim";
    };
  };

  # ZSH con OMZ
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake .#linux";
      v = "vim";
      ns = "nix-shell -p";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "sudo"
        "python"
        "opentofu"
      ];
    };
  };

  # Starchip prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # VSCode
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    # Extensiones para vscode 
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mkhl.direnv
      christian-kohler.path-intellisense
      naumovs.color-highlight
      eamodio.gitlens
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      pkief.material-icon-theme
      zhuangtongfa.material-theme
      redhat.ansible
      github.vscode-github-actions
      hashicorp.terraform
      esbenp.prettier-vscode
      ms-python.python
      davidanson.vscode-markdownlint
      ritwickdey.liveserver
      redhat.vscode-yaml
    ];

    # Configuración de settings.json
    profiles.default.userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
      "editor.fontLigatures" = true;
      "workbench.iconTheme" = "material-icon-theme";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil"; # Un LSP rápido para Nix
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "git.autofetch" = true;
      "python.defaultInterpreterPath" = "./.venv/bin/python";
      "workbench.colorTheme" = "Default Dark+"; # Quiet Light
      "window.autoDetectColorScheme" = false;
    };
  };

  home.stateVersion = "26.05";
}
