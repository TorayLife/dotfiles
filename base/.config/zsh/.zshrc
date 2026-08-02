
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  # source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

source ~/.bash_profile

alias ls='eza --icons=always'
# alias cat='bat'
# alias fastfetch='fastfetch --logo-type kitty-icat -l ~/Documents/important.gif --logo-width 30'

alias ollamacode='export ANTHROPIC_BASE_URL=http://localhost:11434 export ANTHROPIC_AUTH_TOKEN=ollama claude'

autoload -Uz compinit

# Use XDG dirs for completion and history files
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
HISTFILE="$XDG_STATE_HOME"/zsh/history
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

export EDITOR="nvim"
export VISUAL="$EDITOR"

# plugin manager
eval "$(sheldon source)"

# fzf integration to shell
# source <(fzf --zsh)

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
# [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
eval "$(starship init zsh)"

# Completion styling
eval "$(dircolors)"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons=always --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --icons=always --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --icons=always --color=always $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Created by `pipx` on 2026-03-17 10:23:40
export PATH="$PATH:/home/toraylife/.local/bin"

# . "$HOME/.atuin/bin/env"

# eval "$(atuin init zsh)"
