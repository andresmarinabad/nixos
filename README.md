# NixOS – Configuración

[![Nix](https://github.com/andresmarinabad/nixos/actions/workflows/nix.yml/badge.svg?branch=main)](https://github.com/andresmarinabad/nixos/actions/workflows/nix.yml)

Flake con un host: **home** (PC casa).

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
   sudo nixos-rebuild switch --flake .#home --option experimental-features 'nix-command flakes'
   ```

   Si tu NixOS ya tiene flakes activados, puedes omitir `--option ...`:

   ```bash
   sudo nixos-rebuild switch --flake .#home
   ```

4. **Secretos (agenix)**
   Asegúrate de tener la clave age en `~/.ssh/master` y los `.age` correspondientes en `modules/agenix/` antes del primer switch.

5. **Enlace a /etc/nixos**
   Crea un enlace desde /etc/nixos a la raiz del repositorio
   ```bash
   sudo ln -s /home/andres/code/personal/nixos /etc/nixos
   ```

## Rebuild

Utiliza nix helper `nh`:

- `nr` → `nh os switch -H home`

Desde cualquier sitio (con el repo clonado) se puede hacer `nr` gracias a la configuración de `nh` y al enlace simbólico de /etc/nixos que apunta al flake del repositorio clonado.

## Estructura

- `hosts/home/` – configuration.nix y hardware por host.
- `modules/system/` – módulos NixOS (common, por-host).
- `modules/home-manager/` – usuarios y common.
- `modules/desktop/` – Plasma (solo andres).
- `modules/agenix/` – definición de secretos.

## Marcadores del navegador

Los marcadores de **Brave** (andres) y **Chromium** (sara) se generan desde Nix. Edita la lista dentro del `let` que genera el JSON:

- `modules/home-manager/users/andres/browsers.nix` (Brave): variable `braveBookmarksJson`, lista `bookmarksList`.
- `modules/home-manager/users/sara.nix` (Chromium): variable `chromiumBookmarks`, lista `bookmarksList`.

Cada entrada puede ser `{ name = "..."; url = "https://..."; }` o una carpeta: `{ name = "..."; folder = true; children = [ ... ]; }`. Tras cambiar, `home-manager switch` sobrescribe el archivo del perfil por defecto.

## Formatear Nix

```bash
./scripts/format.sh
```

O manualmente: `nixpkgs-fmt flake.nix` y los `.nix` en `modules/` y `hosts/`.

## CI

En cada push a `main`, GitHub Actions ejecuta:

- `nix flake check --no-build`
- dry-build de la config **home**.
