# NixOS Config

## Pasos para la instalación

### 1. Preparar el repositorio

```bash
# Descargar el repositorio y entrar en la carpeta
cd nixos

# Copiar el hardware generado por el instalador
cp /etc/nixos/hardware-configuration.nix ./hosts/linux/
```

Nix Shell para ejecutar `git` y poder usar `flake`

```
nix-shell -p git --run "git init && git add ."
```

### 2. Copiar la clave para descifrar los secretos

Copiar desde Bitwarden las claves a `~/.ssh/master` y `~/.ssh/master.pub`

### 3. Aplicar la configuración por primera vez

```
sudo NIX_CONFIG="extra-experimental-features = nix-command flakes" nixos-rebuild switch --flake .#home
```

y

```
sudo NIX_CONFIG="extra-experimental-features = nix-command flakes" nixos-rebuild switch --flake .#aistech
```

En adelante puedes re-aplicar con:

```
rebuild
```

### 4. Reiniciar
