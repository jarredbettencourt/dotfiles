##### POWERLEVEL10K INSTANT PROMPT (MUST BE FIRST) #####
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

##### TMUX AUTO-START #####
if [[ -z "$TMUX" ]]; then
  exec tmux new-session -A -s "$USER"
fi

##### ZSH MODE #####
bindkey -v  # vi keybindings

##### COMPLETION #####
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select                     # interactive menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # colored completions
bindkey '^[[Z' reverse-menu-complete                  # Shift+Tab for reverse completion

##### PLUGINS #####
# Only load the plugins you want
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Accept autosuggestion
bindkey -M viins '^F' autosuggest-accept

##### KEYBINDINGS #####
bindkey '^H' backward-kill-word

##### ENV #####
export EDITOR="nvim"
export LANG="en_US.UTF-8"
export PATH="$PATH:/opt:$HOME/bin:$HOME/.local/kitty.app/bin"

##### NVM #####
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

##### ALIASES #####
source ~/.zsh_aliases

##### HISTORY #####
HISTSIZE=100000          # keep a large number in memory
SAVEHIST=$HISTSIZE       # save same amount to disk
HISTFILE=~/.zsh_history
setopt appendhistory      # append instead of overwriting
setopt histignoredups     # skip duplicate commands
setopt sharehistory       # share across terminals
setopt extendedhistory    # include timestamp

# Format: MM/DD/YY HH:MM:SS
HIST_STAMPS="mm/dd/yy %T"

##### POWERLEVEL10K THEME #####
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

