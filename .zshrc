if [ -z "$TMUX" ]; then
  exec tmux new-session -A -s $USER
fi

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey '^H' backward-kill-word

# Plugins
plugins=(sudo zsh-autosuggestions colored-man-pages zsh-syntax-highlighting)

# Oh-My-Zsh setup
ZSH_THEME="powerlevel10k/powerlevel10k"

# Completion and update settings
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# History settings
HIST_STAMPS="%m/%d/%y %T "

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
bindkey -M viins '^F' autosuggest-accept
# User configuration
export EDITOR="nvim"

if [[ $(hostname) == "tsc-jarred-laptop" ]]; then
    export GIT_AUTHOR_EMAIL=jarred.bettencourt@tsc.com
else
    export GIT_AUTHOR_EMAIL=jarredbettencourt@gmail.com
fi


# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PATH configuration
export PATH="$PATH:/opt:$HOME/bin:$HOME/.local/kitty.app/bin"

export LANG=en_US.UTF-8

# Source Powerlevel10k configuration
bindkey -v
source ~/.zsh_aliases
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# TODO: jb: figure out a way for ssh-agent and gpg-agent to work on sway wm
