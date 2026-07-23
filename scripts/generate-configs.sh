#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

export YAMUSIC_TOKEN=$(rbw get "yamusic_token")
envsubst '$YAMUSIC_TOKEN' \
    < "$DOTFILES_DIR/.config/yamusic-tui/config.template.yaml" \
    > "$DOTFILES_DIR/.config/yamusic-tui/config.yaml"
