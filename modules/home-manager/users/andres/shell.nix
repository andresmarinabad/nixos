{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    shellAliases = {
      v = "vim";
      ns = "nix-shell -p";

      tg = "terragrunt";
      tgi = "terragrunt init --terragrunt-non-interactive";
      tgp = "terragrunt plan --terragrunt-non-interactive";
      tga = "terragrunt apply --terragrunt-non-interactive";
      tgd = "terragrunt destroy";

      tgia = "terragrunt run-all init --terragrunt-non-interactive";
      tgpa = "terragrunt run-all plan --terragrunt-non-interactive";
      tgaa = "terragrunt run-all apply --terragrunt-non-interactive";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "sudo"
        "python"
        "opentofu"
        "docker-compose"
        "extract"
        "copypath"
        "copyfile"
        "z"
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \\($name\\))]($style) ";
      };

      cmd_duration = {
        min_time = 2000;
        format = "⏱ [$duration]($style) ";
      };

      git_branch = {
        symbol = "🌱 ";
      };
      git_status = {
        conflicted = "⚔️";
        ahead = "🚀";
        behind = "🐢";
        diverged = "😵";
        untracked = "🤷";
        modified = "📝";
        staged = "✅";
        deleted = "🗑️";
        renamed = "🔄";
        stashed = "📦";
      };

      python = {
        symbol = "🐍 ";
        format = "via [$symbol$version (\\($virtualenv\\))]($style) ";
      };

      docker_context = {
        symbol = "🐳 ";
      };

      terraform = {
        symbol = "🏗️ ";
      };

      aws = {
        symbol = "☁️ ";
        disabled = false;
      };

      package = {
        disabled = true;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
