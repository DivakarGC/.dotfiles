echo "Welcome to part 2 of the installer"
echo "Ensure that you are running this on Alacritty only (y/n)"
read usr_input
if [[ "$usr_input" == "n" ]]; then
   echo "Run this again with alacritty only"
   exit
fi

# system update
source system_updater.sh
echo "Please enter tmux prefix + I to install all plugins"
echo "press enter to continue"
read usr_input

echo "would you like to move the minimal tmux status bar to the top? (y/n)"
read usr_input
if [[ "$usr_input" == "y" ]]; then
   sed -i "s/bottom/top/g" $XDG_CONFIG_HOME/tmux/plugins/minimal-tmux-status/minimal.tmux
fi
echo "Press tmux prefix + r to reload the config file"
read usr_input

# Gnome config
echo "Please follow the instructions below to configure gnome"
cat --line-range=1:4 ../ref/gui_instructions.txt
echo "press enter to continue"
read usr_input

# Gnome extensions
cat --line-range=6:17 ../ref/gui_instructions.txt
echo "press enter to continue"
read usr_input

echo "Would you like to configure the server IP address of USBIP? (y/n)"
read usr_input
if [[ "$usr_input" == "y" ]]; then
   echo "Please enter the server's IP address"
   read server_ip
   sed -i "s/\(SERVER_IP=\).*/\1$server_ip/g" $ZDOTDIR/zsh-functions.sh
fi

mkdir ~/Documents/install_script_temp_folder
cd ~/Documents/install_script_temp_folder

yes | sudo pacman -Rs gnome-console
# Necessary Python libraries
pyenv install 3.12
pyenv global 3.12
pyenv shell 3.12
source ~/.zprofile
source ~/.config/zsh/.zshrc
pip install --upgrade pip
# debugging
pip install icecream
# presentation
pip install drawio
pip install colorama pyfiglet
pip install dash plotly seaborn # seaborn - (replace matplotlib)
# data representation and calculation
pip install mysql-connector-python
pip install polars xarray # xarray - (multi-dimentional arrays)
pip install Cython numba taichi
pip install numpy scipy pillow
pip install parse
# quality of life
pip install pendulum # replaces datetime
pip install pydantic
pip install ruff # linter
pip install mypy # static typing
pip install pyglet # best game engine

# virt-manager with qemu/KVM
echo "do you want to install a VM software?(y/n)"
read usr_input
if [[ "$usr_input" == "y" ]]; then
   yes | sudo pacman -Syu
   yes | sudo pacman -S --needed archlinux-keyring
   yes | sudo pacman -S qemu-desktop virt-manager virt-viewer dnsmasq vde2 bridge-utils
   echo "n" | sudo pacman -S --needed ebtables iptables
   echo "n" | sudo pacman -S --needed libguestfs
   sudo systemctl enable libvirtd.service --now
   sudo usermod -a -G libvirt $(whoami)
   sudo systemctl restart libvirtd.service
fi

# Bottles(Wine) Emulator
flatpak install bottles --assumeyes

flatpak install yacreader --assumeyes
yes | sudo pacman -S obsidian zathura

cd ~/Documents
rm -rf install_script_temp_folder
