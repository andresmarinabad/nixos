# Instalación de NixOS con Flake y Home Manager

Este README explica cómo instalar NixOS en un nuevo ordenador usando la configuración flake y Home Manager de este repositorio.

---

### 1. Preparar el sistema

1. Arranca desde un USB live de NixOS.
2. Instala NixOS

### 2. Instalar Nix y habilitar flakes

```
nix-env -iA nixpkgs.git nixpkgs.nixFlakes
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

### 3. Clonar el repo 

### 4. Aplicar tu configuración NixOS desde el flake

```
sudo nixos-rebuild switch --flake /etc/nixos#<device>
```

### 5. Aplicar Home Manager (usuario)

```
home-manager switch --flake /etc/nixos#<home-manager>
```

### 6. Reboot

