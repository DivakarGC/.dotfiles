# Profile file. Runs on login. Environment variables are here

# Default path
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"
export TERM="xterm-256color"

# Clean-up
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export TOOLS_HOME="$HOME/Tools"
export DOTFILES_HOME="$HOME/.dotfiles"

# zsh initialisations
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/.zcompdump-$HOST"
export ZSH_DATA_DIR="$XDG_DATA_HOME/zsh"
# Download Zinit & fzf-zsh, if it's not there
if [ ! -d "$ZSH_DATA_DIR" ]; then
	mkdir -p "$(dirname $ZSH_DATA_DIR)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
	git clone https://github.com/junegunn/fzf-git.sh.git "$ZINIT_HOME"
fi

# fzf modifications
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/rust/.cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rust/.rustup"
export RUSTC_WRAPPER=$CARGO_HOME/bin/sccache

# rtx-cli
source <($CARGO_HOME/bin/rtx activate zsh)
