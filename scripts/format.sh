#!/usr/bin/env bash
# Formatea los .nix del repo con nixpkgs-fmt
set -e
cd "$(dirname "$0")/.."
find modules hosts -name "*.nix" -print0 | xargs -0 nixpkgs-fmt
nixpkgs-fmt flake.nix
echo "Formateo aplicado."
