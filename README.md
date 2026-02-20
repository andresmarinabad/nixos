# NixOS – Configuración multi-host

[![Nix](https://github.com/andresmarinabad/nixos/actions/workflows/nix.yml/badge.svg?branch=main)](https://github.com/andresmarinabad/nixos/actions/workflows/nix.yml)

Flake con dos hosts: **aistech** (PC trabajo) y **home** (PC casa).

## Requisitos

- Nix con flakes y `nix-command` (ya en la config).
- Secretos con [agenix](https://github.com/ryantm/agenix); clave age en `~/.ssh/master`.

## Primer build tras clonar el repo

Tras clonar (o copiar) el repo, el sistema aún no tiene flakes activos y Nix exige que el flake esté en un repo git con los archivos commiteados. Haz lo siguiente:

1. **Entrar al directorio del repo**

   ```bash
   cd /path/to/nixos
   ```

2. **Dejar el flake en un estado válido para Nix**
   - Si clonaste con `git clone`, ya tienes repo. Si no (copia manual), inicializa:
     ```bash
     git init
     ```
   - Añade todo y haz un commit (el flake suele quejarse si el árbol está sucio o sin commit):
     ```bash
     git add .
     git commit -m "Initial config"
     ```

3. **Activar flakes para este comando** (si tu NixOS actual aún no tiene `nix-command` y `flakes` en config):

   ```bash
   # PC de casa
   sudo nixos-rebuild switch --flake .#home --option experimental-features 'nix-command flakes'

   # PC de trabajo
   sudo nixos-rebuild switch --flake .#aistech --option experimental-features 'nix-command flakes'
   ```

   Si tu NixOS ya tiene flakes activados, puedes omitir `--option ...`:

   ```bash
   sudo nixos-rebuild switch --flake .#home
   sudo nixos-rebuild switch --flake .#aistech
   ```

4. **Secretos (agenix)**  
   Asegúrate de tener la clave age en `~/.ssh/master` y los `.age` correspondientes en `modules/agenix/` antes del primer switch.

## Rebuild

En cada host tienes el alias `nr`:

- **aistech:** `nr` → `sudo nixos-rebuild switch --flake .#aistech`
- **home:** `nr` → `sudo nixos-rebuild switch --flake .#home`

Desde cualquier sitio (con el repo clonado):

```bash
sudo nixos-rebuild switch --flake /path/to/repo#aistech
sudo nixos-rebuild switch --flake /path/to/repo#home
```

## Estructura

- `hosts/{aistech,home}/` – configuration.nix y hardware por host.
- `modules/system/` – módulos NixOS (common, desktop-plasma, agenix, por-host).
- `modules/home-manager/` – usuarios y common.
- `modules/desktop/` – Plasma (solo andres).
- `modules/agenix/` – definición de secretos.

## Marcadores del navegador

Los marcadores de **Brave** (andres) y **Chromium** (sara) se generan desde Nix. Edita la lista dentro del `let` que genera el JSON:

- `modules/home-manager/users/andres.nix` (Brave): variable `braveBookmarksJson`, lista `bookmarksList`.
- `modules/home-manager/users/sara.nix` (Chromium): variable `chromiumBookmarks`, lista `bookmarksList`.

Cada entrada puede ser `{ name = "..."; url = "https://..."; }` o una carpeta: `{ name = "..."; folder = true; children = [ ... ]; }`. Tras cambiar, `home-manager switch` sobrescribe el archivo del perfil por defecto.

## Formatear Nix

```bash
./scripts/format.sh
```

O manualmente: `nixpkgs-fmt flake.nix` y los `.nix` en `modules/` y `hosts/`.

## CI

En cada push a `main`/`master`, GitHub Actions ejecuta:

- `nix flake check --no-build`
- dry-build de las configs **aistech** y **home**.

Si usas agenix y en CI no hay claves, el dry-build puede fallar; en ese caso conviene ejecutar el build localmente.
