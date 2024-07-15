echo "Welcome to part 2 of the installer"
echo "Ensure that you are running this on Alacritty only (y/n)"
read usr_input
if [[ "$usr_input" == "n" ]]; then
   echo "Run this again with alacritty only"
   exit
fi

# Gnome config
echo "Please follow the instructions below"
cat --line-range=1:4 ../ref/gui_instructions.txt
echo "Done? (y/n)"
read usr_input

# Gnome extensions
cat --line-range=6:17 ../ref/gui_instructions.txt
echo "Done? (y/n)"
read usr_input

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
