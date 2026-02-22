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
export KEYTIMEOUT=1

##### COMPLETION #####
fpath=(/usr/share/zsh/vendor-completions $fpath)
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select                     # interactive menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # colored completions
bindkey '^[[Z' reverse-menu-complete                  # Shift+Tab for reverse completion

##### HISTORY #####
HISTSIZE=100000          # keep a large number in memory
SAVEHIST=$HISTSIZE       # save same amount to disk
HISTFILE="$ZDOTDIR/.zsh_history"
setopt appendhistory      # append instead of overwriting
setopt sharehistory       # share across terminals
setopt extendedhistory    # include timestamp
setopt incappendhistory  # append each command immediately to the file
setopt histignorealldups # remove all duplicates, not just consecutive


_comp_options+=(globdots) # With hidden files
# TODO: find a place for this file
# source $ZDOTDIR/zsh/completion.zsh

##### STACK FOR DIRECTORIES #####
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

##### PLUGINS #####
# Only load the plugins you want
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source <(fzf --zsh)

# Accept autosuggestion
bindkey -M viins '^F' autosuggest-accept

##### KEYBINDINGS #####
bindkey '^H' backward-kill-word

# Format: MM/DD/YY HH:MM:SS
HIST_STAMPS="mm/dd/yy %T"

# Source aliases
source "$ZDOTDIR/.zsh_aliases"

##### POWERLEVEL10K THEME #####
source "$ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"

##### Make VIM mode for zsh have beam/block for mode #####
cursor_mode() {
    # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode

##### Let me edit commands nvim #####
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
