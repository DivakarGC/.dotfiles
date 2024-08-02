echo "Welcome to the installer, this will be part 1 of installing all necessary tools for development
This script will automatically reboot the system after it is done"
sleep 10

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Temporary setup for zsh shell
BASIC_PKGS_PACMAN=(
  "base-devel" 
  "zsh" "neovim"
)
sudo pacman -S --needed --noconfirm "${BASIC_PKGS_PACMAN[@]}"
chsh -s $(which zsh)
echo "Do you have an amd or intel CPU?"
echo "a -> amd & i -> intel: "
read cpu_name
if [[ "$cpu_name" == "a" ]]; then
  sudo pacman -S --needed --noconfirm amd-ucode
elif [[ "$cpu_name" == "i" ]]; then
  sudo pacman -S --needed --noconfirm intel-ucode
fi

# System config
sudo sed -i "s/^\(GRUB_DEFAULT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT_STYLE=\).*/\1hidden/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i "s/^#\(Color.*\)/\1\nILoveCandy/g" /etc/pacman.conf
sudo sed -i "s/^#\(ParallelDownloads .*\)/\1/g" /etc/pacman.conf

# Language compilers and related packages
LANG_COMPILER_PKGS_PACMAN=(
  "perl" "go" "python"
  "clang" "lldb"
  "rustup"
  "python-pip" "tk"
  "ghc" "zig"
)
LANG_COMPILERS_PKGS_PARU=(
  "bun-bin"
  "scriptisto" # script in any compiled language
)
sudo pacman -S gdb valgrind strace ghidra
export CARGO_HOME="$HOME/.local/share/rust/.cargo"
export RUSTUP_HOME="$HOME/.local/share/rust/.rustup"
sudo pacman -S --needed --noconfirm "${LANG_COMPILER_PKGS_PACMAN[@]}"
rustup toolchain install stable
rustup default stable

cargo install sccache
export RUSTC_WRAPPER="$CARGO_HOME/bin/sccache"
QUALITY_OF_LIFE_CRATES=(
  "cargo-binstall"
  "irust" "bacon"
  # tokio rayon
)
cargo install "${QUALITY_OF_LIFE_CRATES[@]}"
QUALITY_OF_LIFE_CRATES_BIN=(
  "rtx-cli" # language version control
)
cargo binstall "${QUALITY_OF_LIFE_CRATES_BIN[@]}"

# Installing external package managers paru(AUR), flatpak(flathub)
sudo pacman -Syu --noconfirm
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru/
sudo pacman -S --noconfirm flatpak

paru -S --noconfirm "${LANG_COMPILERS_PKGS_PARU[@]}"

# Basic software
UTIL_PKGS_PACMAN=(
  "ttf-jetbrains-mono-nerd"
  "arch-wiki-docs" "arch-wiki-lite" "wiki-tui"
  "p7zip" "unrar" "exfat-utils" "ntfs-3g"
  "libreoffice-fresh" "vlc"
  "fastfetch" "btop" # benchmarkers
  "stow" "openbsd-netcat"
  "ufw" # firewall
  "dos2unix"
)
UTIL_PKGS_PARU=(
  "speedtest-rs-bin"
)
sudo pacman -S --noconfirm "${UTIL_PKGS_PACMAN[@]}"
sudo systemctl enable ufw --now
sudo paru -S --noconfirm "${UTIL_PKGS_PARU[@]}"

# Others
QOF_PKGS_PARU=(
  "preload" # to open up software faster
  # "auto-cpufreq"
)
paru -S --noconfirm "${QOF_PKGS_PARU[@]}"
sudo systemctl enable preload --now
# sudo systemctl enable auto-cpufreq --now

# Install extension manager
flatpak install --assumeyes ExtensionManager

# Brave
paru -S --noconfirm brave-bin

# Command line tools
CLI_PKGS_PACMAN=(
  "github-cli"
  "fzf" "zoxide" "eza" "bat" "fd" "ripgrep" "jq" "yq" "less"
  "yazi" "gdu" "duf" "git-delta"
  "man-db"
  "glow"
  "croc" # alternative to warp
)
CLI_PKGS_PARU=(
  # "jqp-bin"
  "tlrc-bin" "rm-improved-git" # consider aliasing with rm
  "tio"
  "pipes.sh"
  "espanso-wayland-git"
  "kanata-bin"
)
sudo pacman -S --noconfirm "${CLI_PKGS_PACMAN[@]}"
paru -S --noconfirm "${CLI_PKGS_PARU[@]}"
rm -rf ~/.config/espanso

#Kanata
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo sh -c 'echo KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput" > /etc/udev/rules.d/99-input.rules'
sudo udevadm control --reload && udevadm trigger --verbose --sysname-match=uniput
sudo ln -s $HOME/.config/kanata /etc/
sudo sh -c "echo '[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStartPre=/sbin/modprobe uinput
ExecStart=$(which kanata) --cfg /etc/kanata/config.kbd
Restart=no

[Install]
WantedBy=default.target' > /lib/systemd/system/kanata.service"

sudo systemctl enable kanata --now

# Terminal Emulator tools
TERMINAL_EMULATOR_PKGS_PACMAN=(
  "alacritty" "starship" "atuin"
  "tmux" "tmuxp"
)
sudo pacman -S --noconfirm "${TERMINAL_EMULATOR_PKGS_PACMAN[@]}"

# Remote machine tools
REMOTE_MACHINE_PKGS_PACMAN=(
  "usbip"
)
REMOTE_MACHINE_PKGS_PARU=(
  "nomachine" "rustdesk-bin" "parsec-bin"
)
sudo pacman -S --noconfirm "${REMOTE_MACHINE_PKGS_PACMAN[@]}"
sudo sh -c "printf '%s\n%s\n' 'usbip-core' 'vhci-hcd' >> /etc/modules-load.d/usbip.conf"
# paru -S --noconfirm "${REMOTE_MACHINE_PKGS_PARU[@]}"

# Onedriver
echo "Do you want to install onedriver?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  mkdir $HOME/OneDrive
  paru -S --noconfirm onedriver
  rm -rf ~/Music ~/Pictures ~/Templates ~/Public ~/go
fi

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

espanso service register
espanso start

# zsh plugin manager & fzf for git
mkdir -p "$(dirname $HOME/.local/share/zsh)" # might not be needed
git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.local/share/zsh"
git clone https://github.com/junegunn/fzf-git.sh.git "$HOME/.local/share/zsh/fzf-git"

# alacritty & tmux
git clone https://github.com/alacritty/alacritty-theme.git "$HOME/.config/alacritty/themes"
git clone https://github.com/tmux-plugins/tpm.git "$HOME/.config/tmux/plugins/tpm"

echo "Press Enter to continue"
read usr_input

# Gnome Config
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font'

cd ~/Documents
rm -rf install_script_temp_folder

echo "The system will reboot now"

sleep 10
reboot
