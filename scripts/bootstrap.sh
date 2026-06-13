#!/usr/bin/env bash
# Bootstrap: configura el sistema desde cero tras clonar el repo.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOST="home"

info() { echo "  [✓] $*"; }
warn() { echo "  [!] $*" >&2; }
die()  { echo "  [✗] $*" >&2; exit 1; }

echo ""
echo "══════════════════════════════════════════"
echo "  NixOS bootstrap — host: $HOST"
echo "══════════════════════════════════════════"
echo ""

cd "$REPO_DIR"
[[ -f flake.nix ]] || die "No se encuentra flake.nix en $REPO_DIR"

# ── 1. Clave age (agenix) ────────────────────────────────────────────────────
if [[ ! -f "$HOME/.ssh/master" ]]; then
  warn "No se encontró la clave age en ~/.ssh/master"
  warn "El rebuild fallará al descifrar los secretos (contraseñas, SSH key de GitHub)."
  echo ""
  read -rp "  ¿Continuar de todas formas? [s/N] " reply
  echo ""
  [[ "$reply" =~ ^[sS]$ ]] || { echo "  Cancela. Copia ~/.ssh/master y vuelve a ejecutar."; exit 1; }
else
  info "Clave age encontrada en ~/.ssh/master"
fi

# ── 2. Repositorio git válido ────────────────────────────────────────────────
# Nix exige que el flake viva en un repo git con al menos un commit.
if [[ ! -d "$REPO_DIR/.git" ]]; then
  info "Inicializando repositorio git..."
  git -C "$REPO_DIR" init
  git -C "$REPO_DIR" add .
  git -C "$REPO_DIR" commit -m "Initial config"
elif ! git -C "$REPO_DIR" log -1 --quiet 2>/dev/null; then
  info "Creando commit inicial para que Nix pueda leer el flake..."
  git -C "$REPO_DIR" add .
  git -C "$REPO_DIR" commit -m "Initial config"
else
  info "Repositorio git OK"
fi

# ── 3. Enlace simbólico /etc/nixos → repo ───────────────────────────────────
CURRENT_LINK="$(readlink /etc/nixos 2>/dev/null || true)"
if [[ "$CURRENT_LINK" == "$REPO_DIR" ]]; then
  info "/etc/nixos ya apunta a $REPO_DIR"
else
  info "Creando enlace /etc/nixos → $REPO_DIR"
  sudo rm -rf /etc/nixos
  sudo ln -s "$REPO_DIR" /etc/nixos
fi

# ── 4. nixos-rebuild switch ──────────────────────────────────────────────────
info "Ejecutando nixos-rebuild switch --flake .#$HOST"
echo ""

# Si el sistema aún no tiene flakes habilitados hay que pasarlos como opción.
if nix flake metadata "$REPO_DIR" --no-write-lock-file --quiet 2>/dev/null; then
  sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST"
else
  warn "Flakes no habilitados en el sistema actual; activándolos solo para este comando..."
  sudo nixos-rebuild switch --flake "$REPO_DIR#$HOST" \
    --option experimental-features 'nix-command flakes'
fi

echo ""
echo "══════════════════════════════════════════"
echo "  Bootstrap completado."
echo "  Usa 'nr' para futuros rebuilds."
echo "══════════════════════════════════════════"
echo ""
