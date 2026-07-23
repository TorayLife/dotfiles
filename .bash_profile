#
# ~/.bash_profile
#
#[[ -f ~/.bashrc ]] && . ~/.bashrc

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/toraylife/.lmstudio/bin"
# End of LM Studio CLI section
export QT_QPA_PLATFORMTHEME="qt6ct"
