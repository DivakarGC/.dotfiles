echo "Welcome to the installer, this will be part 1 of installing all necessary tools for development
This script will automatically reboot the system after it is done"
sleep 10

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Basic setup
sudo sed -i "s/^\(GRUB_DEFAULT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT=\).*/\10/g" /etc/default/grub
sudo sed -i "s/^\(GRUB_TIMEOUT_STYLE=\).*/\1hidden/g" /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo sed -i "s/^#\(Color\)/\1\nILoveCandy/g" /etc/pacman.conf
sudo sed -i "s/^#\(ParallelDownloads .*\)/\1/g" /etc/pacman.conf

# Temporary setup for zsh shell
yes | sudo pacman -S zsh neovim
chsh -s $(which zsh)
rm -f ~/.bash*
sudo pacman -Rs vim

# Basic software
yes | sudo pacman -S arch-wiki-docs arch-wiki-lite
yes | sudo pacman -S p7zip unrar tar exfat-utils ntfs-3g
yes | sudo pacman -S libreoffice-fresh vlc
yes | sudo pacman -S fastfetch btop # benchmarkers
yes | sudo pacman -S stow speedtest-cli openbsd-netcat
# Others
paru -S preload # to open up software faster
sudo systemctl enable preload --now

# Uninstall bloat
yes | sudo pacman -Rs epiphany # Remove browser
# gstreamer1.0-vaapi # video player
# and contacts, weather, tour

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Rust
source ~/.zprofile
# Installing paru and git and curl
echo "Installing paru AUR package manager"
yes | sudo pacman -Syu
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
echo "Done, cleaning up"
cd ..
rm -rf paru/
yes | sudo pacman -S flatpak

# Install fonts
yes | sudo pacman -S ttf-jetbrains-mono-nerd

# Alacritty Terminal Emulator
yes | sudo pacman -S alacritty starship 
yes | sudo pacman -S zellij xclip
paru -S tio # Enter, enter, y, y

# Command line tools
yes | sudo pacman -S fzf zoxide eza bat fd ripgrep
yes | sudo pacman -S  gdu duf jq

echo "\ny" | sudo pacman -S man
paru -S tlrc-bin # enter, enter, y

# Brave
echo "Installing Brave"
echo "Just keep pressing 'Enter' From here on"
paru -S brave-bin # enter, enter, enter, y, y
echo "Done"

# Language compilers and related packages - install these as early as possible in the script
echo "3\ny" | sudo pacman -S gdb valgrind strace ghidra
yes | sudo pacman -S --needed clang lldb
yes | sudo pacman -S nodejs-lts-iron

# Get the appropriate profilers for all other necessary programming languages
# yes | sudo pacman -S zig
# Download crate suite with quality of life crates
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh # Haskell
# yes | sudo pacman -S zig

yes | sudo pacman -S --needed perl go python
yes | sudo pacman -S python-pip pyenv
# Change the location of the .pyenv folder & reflect it in .zprofile

# Onedriver
# mkdir $HOME/OneDrive
# paru -S onedriver
# rm -rf ~/Music ~/Pictures ~/Templates ~/Public

# Remote machine tools
yes | sudo pacman -S usbip
sudo sh -c "printf '%s\n%s\n' 'usbip-core' 'vhci-hcd' >> /etc/modules-load.d/usbip.conf" # adding basic conf to usbip 
# paru -S nomachine
# Download rust-desk

# Gnome Desktop Config
# Bring minimise, maximise and close buttons to their positions
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font' 

cd ~/Documents
rm -rf install_script_temp_folder

echo "The system will reboot now"

sleep 10
reboot
