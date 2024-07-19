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
export ZINIT_HOME="$XDG_DATA_HOME/zsh/zinit.git"
# Download Zinit, if it's not there
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# ------ Local ------

# Github
source <(hub alias -s)

# Starship
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
source <(starship init zsh)

# Rust
export CARGO_HOME="$XDG_DATA_HOME/rust"
export RUSTUP_HOME="$XDG_DATA_HOME/rust"

# Pyenv
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin":$PATH
source <(pyenv init -)

# # Questasim
# export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/linux_x86_64":$PATH
# export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/RUVM_2021.2":$PATH
# export LM_LICENSE_FILE="$XDG_DATA_HOME/questasim/license.dat":$LM_LICENSE_FILE

# # Vivado
# source $TOOLS_HOME/Xilinx/Vivado/2024.1/settings64.sh
# source $TOOLS_HOME/Xilinx/Vitis/2024.1/settings64.sh 

# # SVUnit
# export PATH="$TOOLS_HOME/SVUnit/bin":$PATH

# # Symbiyosys
# export PATH="$TOOLS_HOME/YosysHQ/oss-cad-suite/bin":$PATH
