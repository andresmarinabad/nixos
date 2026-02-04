# NixOS Config

## Pasos para la instalación

### 1. Preparar el repositorio

```bash
# Descargar el repositorio y entrar en la carpeta
cd nixos

# Copiar el hardware generado por el instalador
cp /etc/nixos/hardware-configuration.nix ./hosts/linux/

# IMPORTANTE: Nix Flakes solo ve archivos trackeados por Git
git init
git add .
```
Pero git no viene instalado por defecto
```
nix-shell -p git --run "git init && git add ."
```

### 2. Aplicar la configuración por primera vez

```
sudo nixos-rebuild switch --flake .#linux --extra-experimental-features "nix-command flakes"
```
Como flakes no viene instalado en vez de tocar configuracion que luego se borrará, mejor:
```
sudo NIX_CONFIG="extra-experimental-features = nix-command flakes" nixos-rebuild switch --flake .#linux
```

### 3. Definir las contraseñas para los usuarios

```
sudo passwd andres
sudo passwd gandalf
```

### 4. Reiniciar
