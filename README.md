# NixOS – Configuración

[![Nix](https://github.com/andresmarinabad/nixos/actions/workflows/nix.yml/badge.svg?branch=main)](https://github.com/andresmarinabad/nixos/actions/workflows/nix.yml)

Flake con un host: **home** (PC casa), dos usuarios: **andres** y **sara**.

## Instalación rápida

```bash
git clone https://github.com/andresmarinabad/nixos ~/code/personal/nixos
cd ~/code/personal/nixos
./scripts/bootstrap.sh
```

El script automatiza:

1. Verificar la clave age (`~/.ssh/master`) — necesaria para descifrar secretos.
2. Asegurar que el repo tiene un commit válido (requisito de Nix para los flakes).
3. Crear el enlace simbólico `/etc/nixos` → el repo clonado.
4. Ejecutar `nixos-rebuild switch --flake .#home` (detecta si hay que activar flakes primero).
5. Configurar Flathub e instalar Bambu Studio.

> **Antes de ejecutar el script**, copia la clave age a `~/.ssh/master`. Sin ella el build falla al descifrar contraseñas y la clave SSH de GitHub.

> **Hardware nuevo:** regenera `hosts/home/hardware-configuration.nix` y revisa
> el UUID de `/mnt/data` en `modules/system/home/system.nix` antes del bootstrap.

## Disko

Cada host tiene su propia definición de discos en `hosts/<host>/disko.nix`.

Esta configuración **no se importa en `configuration.nix`** y no forma parte del `nixos-rebuild` habitual. Se utiliza únicamente desde el instalador/Live ISO para particionar y montar el disco durante una instalación desde cero.

### Instalación desde cero

Arranca una ISO de NixOS y clona el repositorio:

```bash
git clone https://github.com/andresmarinabad/nixos ~/code/personal/nixos
cd ~/code/personal/nixos
```

Comprueba primero que `hosts/<host>/disko.nix` apunta al dispositivo correcto:

```nix
device = "/dev/nvme0n1";
```

**ATENCIÓN:** ejecutar Disko en modo destructivo borra las particiones y los datos del disco indicado.

Desde la ISO, ejecuta Disko con la configuración del host correspondiente y, después, instala NixOS siguiendo el procedimiento de instalación definido por el proyecto.

```bash
sudo nix \
  --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode destroy,format,mount \
  ./hosts/<host>/disko.nix
```

La configuración de Disko debe mantenerse sincronizada con:

```text
hosts/<host>/
├── configuration.nix
├── hardware-configuration.nix
└── disko.nix
```

`configuration.nix` y `hardware-configuration.nix` describen el sistema NixOS que se ejecutará normalmente; `disko.nix` describe cómo preparar físicamente el disco para una instalación nueva.

## Requisitos

- Nix con flakes y `nix-command` (ya en la config; el script lo activa si aún no están).
- Secretos con [agenix](https://github.com/ryantm/agenix); clave age en `~/.ssh/master`.

## Rebuild

Desde cualquier sitio:

```bash
nr   # alias de: nh os switch -H home
```

Funciona gracias al enlace `/etc/nixos` → repo y a la configuración de `nh`.

## Estructura

```
nixos/
├── flake.nix
├── hosts/home/                    # hardware-configuration + stateVersion
├── modules/
│   ├── system/
│   │   ├── common.nix             # config NixOS compartida (audio, red, docker, SSH…)
│   │   └── home/system.nix        # config específica del host (partición /mnt/data, sara, Trezor)
│   ├── home-manager/
│   │   ├── common.nix             # paquetes y variables de sesión compartidos
│   │   ├── lib/
│   │   │   └── bookmarks.nix      # helper que genera el JSON de marcadores (Brave/Chromium)
│   │   └── users/
│   │       ├── andres/
│   │       │   ├── default.nix    # paquetes, activaciones (wallpaper, Flatpak), megasync
│   │       │   ├── plasma.nix     # KDE Plasma 6 (tema oscuro, panel, atajos, kitty)
│   │       │   ├── browsers.nix   # Brave + bookmarks
│   │       │   ├── git.nix        # git, SSH config, clave pública
│   │       │   ├── shell.nix      # zsh, starship, direnv, aliases terragrunt
│   │       │   └── vscode.nix     # VSCode + extensiones
│   │       └── sara/
│   │           ├── default.nix    # paquetes (spotify)
│   │           ├── plasma.nix     # KDE Plasma 6 (tema claro, Bing wallpaper)
│   │           └── browsers.nix   # Chromium + bookmarks
│   └── agenix/                    # secretos cifrados (.age) y declaraciones
├── pkgs/
│   └── calibre.nix                # wrapper: config en MEGA, guarda si megasync no corre
└── scripts/
    ├── bootstrap.sh               # instalación desde cero
    └── format.sh                  # formatea todos los .nix con nixpkgs-fmt
```

## Secretos (agenix)

Los secretos se cifran con la clave pública en `modules/agenix/secrets.nix` y se descifran en runtime con la clave privada `~/.ssh/master`.

Secretos declarados:

- `pass-andres.age` / `pass-sara.age` — contraseñas de login
- `github-andres.age` — clave SSH privada de GitHub (se coloca en `~/.ssh/andres`)

Para añadir un secreto nuevo:

```bash
agenix -e modules/agenix/nuevo-secreto.age
# luego declararlo en modules/agenix/default.nix y secrets.nix
```

## Marcadores del navegador

Los marcadores de **Brave** (andres) y **Chromium** (sara) se generan desde Nix. Edita la lista `bookmarksList` en el archivo correspondiente:

- Andres → `modules/home-manager/users/andres/browsers.nix`
- Sara → `modules/home-manager/users/sara/browsers.nix`

Cada entrada: `{ name = "..."; url = "https://..."; }` o carpeta: `{ name = "..."; folder = true; children = [ ... ]; }`.
Tras cambiar, el próximo `nr` sobrescribe el archivo de marcadores.

## Formatear Nix

```bash
./scripts/format.sh
```

## CI

En cada push a `main`, GitHub Actions ejecuta:

- `nix flake check --no-build`
- dry-build de la config **home**
