# Source aliases
source "$ZDOTDIR/zsh-aliases.sh"

# Bell
unsetopt BEEP

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="${XDG_DATA_HOME}/zsh/.zsh_history"
HISDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# Completions
autoload -U compinit && compinit
_comp_options+=(globdots) # Show hidden files
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '#%d'
zstyle ':completion:*' menu no
zstyle ':completion:*' group-name '' # Group the completions by type

# Enable colors
autoload -U colors && colors

# Set the directory for zinit and it's plugins
ZINIT_HOME="${XDG_DATA_HOME}/zsh/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Improving performance
zinit cdreplay -q

# Add Plugins
zinit light zsh-users/zsh-syntax-highlighting

# ------- Local ------

# Zsh-Vi-Mode
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
# bindkey '^p' line-up-or-search
# bindkey '^n' line-down-or-search

# fzf-tab
zinit light Aloxaf/fzf-tab
zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:*' switch-group ctrl-h ctrl-l # Change keybinding to switch groups
zstyle ':fzf-tab:*' single-group color header # Show type even when only one group
# Increase fzf prompt size
zstyle ':fzf-tab:*' fzf-pad 5
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:(cd|ls|ll|lsd|lsdd|j|eza):*' fzf-preview '[[ -d $realpath ]] && eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:((micro|cut|cp|mv|rm|bat|less|code|vd|nvim|n):argument-rest|kate:*)' fzf-preview 'bat --color=always -- $realpath 2>/dev/null || ls --color=always -- $realpath'
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons=always --all --long --no-filesize --no-user --no-time --no-permissions $realpath'
#zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --icons=always --all --long --no-filesize --no-user --no-time --no-permissions $realpath'

# Shell integrations
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(pyenv init -)"
