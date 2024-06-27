mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

# Basic setup
sudo python ~/.dotfiles/.bin/conf_grub.py # removing grub screen on startup
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo python ~/.dotfiles/.bin/conf_pacman.py

# Temporary setup for zsh shell
yes | sudo pacman -S zsh
chsh -s $(which zsh)
yes | sudo pacman -S neovim
# rm -f ~/.bash* -> need to verify if this doesn't break anything


# Install fonts
yes | sudo pacman -S ttf-jetbrains-mono-nerd

# Installing yay and git and curl
echo "Installing yay AUR package manager"
yes | sudo pacman -Syu
yes | sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
yes | makepkg -si
echo "Done, cleaning up"
cd ..
rm -rf yay/
yes | sudo pacman -S flatpak

# Uninstall bloat
yes | sudo pacman -Rs epiphany # Remove browser
# gstreamer1.0-vaapi # video player
# and contacts, weather, tour


# Basic software
yes | sudo pacman -S --needed arch-wiki-docs arch-wiki-lite
yes | sudo pacman -S --needed p7zip unrar tar exfat-utils ntfs-3g
yes | sudo pacman -S --needed libreoffice-fresh vlc
yes | sudo pacman -S --needed fastfetch btop tree
yes | sudo pacman -S --needed xclip stow usbip
# Others
# yay -S preload # to open up software faster
# sudo systemctl enable preload; sudo systemctl start preload
# Auto cpu-freq

# Command line tools
yes | sudo pacman -S fzf zoxide bat
# bat (& alias with cat), eza(& alias with ls), tlrc(alias with tldr), zoxide(alias with cd)

# Brave
echo "Installing Brave"
echo "Just keep pressing 'Enter' From here on"
yay -S brave-bin
echo "Done"

# Alacritty Terminal Emulator
yes | sudo pacman -S alacritty starship zellij


# Bottles(Wine) Emulator
yes | flatpak install bottles # Doesn't work if system is not restarted

# Language compilers and related packages
# install 'pip' for py n stuff
# 'tio' serial monitor

# Onedriver


# Remote machine tools
yes | sudo pacman -S usbip

# Seting up backup schemes (timeshift)
# betterfs for better backup & setup encrypted HDD

# Initialising all dot files
cd ~/.dotfiles
stow .
cd -

# Gnome Desktop Config
# Bring minimise, maximise and close buttons to their positions
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font' 

cd ~/Documents
rm -rf install_script_temp_folder

echo "Reboot the system now"
