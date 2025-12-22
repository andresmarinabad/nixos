# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules.agenix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      channel.enable = true;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
    };

  users.users = {
    andres = {
      initialHashedPassword = "*";
      isNormalUser = true;
      shell = pkgs.fish;

      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
      ];
    };
  };

  age = {
    identityPaths = [
      "/tmp/master-key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
    secretsDir = "/run/agenix";

    secrets = {
      secret_as-xvi_ssh_key = {
        file = ../secrets/secret_as-xvi_ssh_key.age;
        owner = "xavier";
        group = "users";
        mode = "0600";
      };
      secret_xvi_ssh_key = {
        file = ../secrets/secret_xvi_ssh_key.age;
        owner = "xavier";
        group = "users";
        mode = "0600";
      };
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      X11Forwarding = true;
    };
  };

  programs.git.enable = true;

  programs.nix-ld.enable = true;

  programs.ssh.startAgent = true;

  # Enable docker system-wide for all devices
  virtualisation.docker = {
    enable = true;
    # ... other options
    daemon.settings = {
      # This explicitly sets the cgroup driver to systemd,
      # which is crucial for cgroup delegation to work.
      "exec-opts" = [ "native.cgroupdriver=systemd" ];
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
    cacert
    wget
    htop
    vim
    curl
    killall
    ncdu
    dig
    tail-tray
  ];

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    fira-code
    fira-code-symbols
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
      inherit (config.age) secrets;
    };

    users = {
      andres =
        if builtins.pathExists (../home-manager + "/andres-${config.networking.hostName}.nix") then
          import (../home-manager + "/andres-${config.networking.hostName}.nix")
        else
          import ../home-manager/andres-default.nix; # fallback
    };
  };

  programs.fish = {
    enable = true;
    shellInit = "
      starship init fish | source
      function ns
        nix shell --impure nixpkgs#$argv
      end

      function nsu
        nix shell --impure nixpkgs-unstable#$argv
      end

      function nsm
        nix shell --impure nixpkgs-master#$argv
      end
    ";
    shellAliases = {
      nix-shell = "nix-shell --command 'fish'";
      g = "git";

      gd = "git diff";

      ga = "git add";
      gaa = "git add --update";

      gpu = "git push";
      gpf = "git push --force-with-lease";
      gup = "git pull --rebase";

      gc = "git commit";
      gcm = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gsw = "git switch";

      gs = "git status -s";
      gl = "git log --oneline --graph --decorate";
      gll = "git log --graph --decorate";

      gst = "git stash";
      gsp = "git stash pop";

      k = "kubectl";
      kgc = "kubectl config get-contexts";
      ksc = "kubectl config use-context";

      kd = "kubectl describe";
      kf = "kubectl get pods -o wide";

      nd = "nix develop";
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [
      "--accept-routes"
    ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
