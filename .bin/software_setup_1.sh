echo "Welcome to the installer, this will be part 1 of installing all necessary tools for development
This script will automatically reboot the system after it is done"
sleep 10

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Temporary setup for zsh shell
yes | sudo pacman -S --needed base-devel
yes | sudo pacman -S zsh neovim
chsh -s $(which zsh)
rm -f ~/.bash*
yes | sudo pacman -Rs vim htop
echo "Do you have an and or intel CPU?"
echo "a -> amd & i -> intel: "
read cpu_name
if [[ "$cpu_name" == "a" ]]; then
  yes | sudo pacman -S amd-ucode
elif [[ "$cpu_name" == "i" ]]; then
  yes | sudo pacman -S intel-ucode
fi

# Basic setup
sudo sed -i "s/^\(GRUB_DEFAULT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT_STYLE=\).*/\1hidden/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i "s/^#\(Color\)/\1\nILoveCandy/g" /etc/pacman.conf
sudo sed -i "s/^#\(ParallelDownloads .*\)/\1/g" /etc/pacman.conf

# Uninstall bloat
yes | sudo pacman -Rs epiphany gnome-music gnome-calendar
yes | sudo pacman -Rs gnome-contacts sushi gnome-weather
yes | sudo pacman -Rs totem gnome-maps gnome-logs evince

# Installing external package managers yay(AUR), flatpak(flathub)
yes | sudo pacman -Syu
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay/
yes | sudo pacman -S flatpak

# Basic software
yes | sudo pacman -S arch-wiki-docs arch-wiki-lite
yes | sudo pacman -S p7zip unrar tar exfat-utils ntfs-3g
yes | sudo pacman -S libreoffice-fresh vlc
yes | sudo pacman -S fastfetch btop # benchmarkers
yes | sudo pacman -S stow speedtest-cli openbsd-netcat
yes | sudo pacman -S --needed less
# Others
yay -S preload # to open up software faster
sudo systemctl enable preload --now
yay -S tio

# Install fonts and extensions
yes | sudo pacman -S ttf-jetbrains-mono-nerd
flatpak install ExtensionManager --assumeyes

# Command line tools
yes | sudo pacman -S fzf zoxide eza bat fd ripgrep
yes | sudo pacman -S hub gdu duf jq man-db
yay -S tlrc-bin

# Terminal Emulator tools
yes | sudo pacman -S alacritty starship tmux

# Brave
yay -S brave-bin

# Language compilers and related packages
yes | sudo pacman -S --needed perl go python
sudo pacman -S gdb valgrind strace ghidra
yes | sudo pacman -S --needed clang lldb
yes | sudo pacman -S nodejs-lts-iron
yes | sudo pacman -S python-pip pyenv
mv ~/.pyenv $HOME/.local/share/

echo "Do you want to install rust?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Rust
  # Download crate suite with quality of life crates for rust
fi
echo "Do you want to install haskell?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh # Haskell
fi

# yes | sudo pacman -S zig
# Get the appropriate profilers for other necessary programming languages

# Onedriver
echo "Do you want to install onedriver?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  mkdir $HOME/OneDrive
  yay -S onedriver
  rm -rf ~/Music ~/Pictures ~/Templates ~/Public
fi

# Remote machine tools
yes | sudo pacman -S usbip
sudo sh -c "printf '%s\n%s\n' 'usbip-core' 'vhci-hcd' >> /etc/modules-load.d/usbip.conf"
echo "Do you want to install nomachine and rustdesk?(Y/n)"
read usr_input
if [[ "$usr_input" == 'y' ]]; then
  yay -S nomachine
  yay -S rustdesk-bin
fi

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

# Gnome Desktop Config
# Bring minimise, maximise and close buttons to their positions
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font'

cd ~/Documents
rm -rf install_script_temp_folder

echo "The system will reboot now"

sleep 10
reboot
