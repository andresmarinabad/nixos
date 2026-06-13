{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      core.editor = "vim";
    };

    includes = [
      {
        condition = "gitdir:~/code/personal/";
        contents = {
          user = {
            name = "Andrés";
            email = "andresmarinabad@protonmail.com";
          };
          url."git@github.com:".insteadOf = "https://github.com/";
        };
      }
    ];
  };

  home.file.".ssh/andres.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqImXgnyR1mINurbZY0xV5EJmKUQWGv6BxQihpsgxiD";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/andres";
        identitiesOnly = true;
      };
    };
  };
}
