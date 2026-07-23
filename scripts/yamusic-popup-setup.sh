#!/usr/bin/env bash
MUSIC_SERVER="music"
MUSIC_SESSION="music"
PLAYER_CMD="yamusic-tui"
POPUP_KEY="M"

# убить старую, если есть
tmux -L "$MUSIC_SERVER" kill-session -t "$MUSIC_SESSION" 2>/dev/null

# создать сервер с пустым конфигом и сессию
tmux -f /dev/null -L "$MUSIC_SERVER" new-session -d -s "$MUSIC_SESSION" "$PLAYER_CMD"

# настройки
tmux -L "$MUSIC_SERVER" set -t "$MUSIC_SESSION" status off
tmux -L "$MUSIC_SERVER" set -s escape-time 0
tmux -L "$MUSIC_SERVER" bind-key -T root Escape detach-client

# запреты
tmux -L "$MUSIC_SERVER" unbind c
tmux -L "$MUSIC_SERVER" unbind '%'
tmux -L "$MUSIC_SERVER" unbind '"'
tmux -L "$MUSIC_SERVER" unbind f
