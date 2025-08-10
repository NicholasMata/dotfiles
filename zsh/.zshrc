#zmodload zsh/zprof # Enable for profiling
# -------------------------------
# Powerlevel10k Instant Prompt
# -------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------------
# Homebrew Environment Setup
# -------------------------------
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# -------------------------------
# Zinit Setup
# -------------------------------
ZVM_INIT_MODE=sourcing
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# -------------------------------
# Zinit Plugins & Snippets (Non-dependent)
# -------------------------------
zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit light romkatv/zsh-defer
zinit light jeffreytse/zsh-vi-mode

for plugin in \
  zsh-users/zsh-completions \
  zsh-users/zsh-autosuggestions \
  joshskidmore/zsh-fzf-history-search; do
  zinit ice wait'0' lucid
  zinit light $plugin
done

zinit ice wait'0' lucid
zinit snippet OMZP::git
zinit ice wait'0' lucid
zinit snippet OMZP::command-not-found

# -------------------------------
# Completion Setup
# -------------------------------
autoload -Uz compinit
compinit -C

zinit ice wait'0' lucid
zinit light Aloxaf/fzf-tab

zinit cdreplay -q

source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu no
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -A --color $realpath'

# -------------------------------
# Prompt Configuration
# -------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# -------------------------------
# General Options
# -------------------------------
setopt correct
setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt nocheckjobs
setopt numericglobsort
setopt auto_cd

# -------------------------------
# History Configuration
# -------------------------------
HISTSIZE=100000
HISTFILE=~/.zhistory
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# -------------------------------
# Man Page Colors
# -------------------------------
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# -------------------------------
# FZF Configuration
# -------------------------------
export FZF_DEFAULT_OPTS='--bind=alt-n:preview-down --bind=alt-p:preview-up'
export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --glob "!.git/*"'
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
else
  eval "$(fzf --zsh)"
fi

# -------------------------------
# Needs to be last Zinit Plugin
# -------------------------------
zinit ice wait'0' lucid
zinit light zsh-users/zsh-syntax-highlighting

# -------------------------------
# Key Bindings
# -------------------------------
zmodload zsh/terminfo
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey "\e[1;3D" backward-word       # ⌥←
bindkey "\e[1;3C" forward-word        # ⌥→
bindkey "\e[1;9D" beginning-of-line   # ⌘←
bindkey "\e[1;9C" end-of-line         # ⌘→
bindkey "\e[107;9u" clear-screen
bindkey '^[^?' backward-delete-word

# -------------------------------
# Aliases
# -------------------------------
alias ekitty="nvim ~/.config/kitty/kitty.conf"
alias ezsh="nvim ~/.zshrc && source ~/.zshrc"
alias vim="nvim"
alias ls='ls -G'
alias ll='ls -laG'

# -------------------------------
# NVM Setup with zsh-defer
# -------------------------------
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && zsh-defer source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && zsh-defer source "$NVM_DIR/bash_completion"

#zprof # Enable for profiling
