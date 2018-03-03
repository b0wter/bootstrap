#!/usr/bin/env bash

#
# --- Colors for echo <3 ---
#
NC='\e[0m' # No Color
WHITE='\e[1;37m'
BLACK='\e[0;30m'
BLUE='\e[0;34m'
LIGHT_BLUE='\e[1;34m'
GREEN='\e[0;32m'
LIGHT_GREEN='\e[1;32m'
CYAN='\e[0;36m'
LIGHT_CYAN='\e[1;36m'
RED='\e[0;31m'
LIGHT_RED='\e[1;31m'
PURPLE='\e[0;35m'
LIGHT_PURPLE='\e[1;35m'
COLOR_BROWN='\e[0;33m'
YELLOW='\e[1;33m'
GRAY='\e[0;30m'
LIGHT_GRAY='\e[0;37m'

#
# --- Folder definitions
#
TEMP_DIR='~/temp_bootstrap'
BIN_DIR='~/bin'

#
# --- Default folders ---
#
cd ~
rmdir Downloads
rmdir Desktop
rmdir Documents
rmdir Pictures

mkdir downloads
mkdir documents
mkdir pictures
mkdir work
mkdir bin

#
# --- Make sure we are not running as root.
#
if [[ $EUID -ne 0 ]]; then
   echo "Running as regular using, using sudo prompts to do administrative tasks."
else
   echo "This script must not be run as root"
   exit 1
fi

#
# --- Install base packages ---
#
echo -e "${YELLOW}Installing pakets via zypper.${NC}"
sudo zypper -n install git zsh htop awesome awesome-shifty terminator wget curl mono-complete make gcc harfbuzz-tools harfbuzz-devel libpng16-devel fontconfig-devel Mesa-libGL-devel python3-devel libXrandr-devel libXinerama-devel libXcursor-devel libxkbcommon-devel libxkbcommon-x11-devel libXi-devel fsharp openvpn NetworkManager-openvpn texlive-fira-fonts mc mono-addins-msbuild sshfs feh mupdf pinta kernel-devel

sudo zypper -n rm libreoffice thunderbird pidgin

#
# --- Get config files and prepare temp folder.
#
cd /home/b0wter
if [ -d "$TEMP_DIR" ]; then
  echo -e "${RED}Temporary bootstrap folder already exists, aborting.${NC}"
  exit 1
fi
cd ~
mkdir "$TEMP_DIR"

#
# --- Fonts ---
#
# Fira
echo -e "${YELLOW}Installing Fira Code.${NC}"
mkdir -p ~/.local/share/fonts
for type in Bold Light Medium Regular Retina; do
    wget -O ~/.local/share/fonts/FiraCode-${type}.ttf \
    "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true";
done
# powerline
git clone https://github.com/powerline/fonts.git powerline
powerline/install.sh
rm -rf powerline

#
# --- Oh my Zsh ---
#
echo -e "${YELLOW}Installing oh-my-zsh.${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#
# --- .net core ---
#
echo -e "${YELLOW}Installing dotnet.core sdk.${NC}"
sudo rpm --nosignature --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[packages-microsoft-com-prod]\nname=packages-microsoft-com-prod \nbaseurl= https://packages.microsoft.com/yumrepos/microsoft-rhel7.3-prod\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/dotnetdev.repo'
sudo zypper -n update
sudo zypper -n install libunwind libicu
sudo zypper -n install -l -y dotnet-sdk-2.1.4

#
# --- Franz ---
#
echo -e "${YELLOW}Installing Franz.${NC}"
#wget -O /home/b0wter/bin/franz.AppImage https://github.com/meetfranz/franz/releases/download/v5.0.0-beta.15/franz-5.0.0-beta.15-x86_64.AppImage
chmod a+x /home/b0wter/bin/franz.AppImage

#
# --- VS Code ---
#
echo -e "${YELLOW}Installing Visual Studio Code.${NC}"
sudo rpm --nosignature --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
sudo zypper refresh
sudo zypper -n install code
code --install-extension vscodevim.vim
code --install-extension ms-vscode.csharp
code --install-extension adamgirton.gloom
code --install-extension christian-kohler.path-intellisense
code --install-extension Ionide.Ionide-fsharp
code --install-extension Ionide.Ionide-Paket
code --install-extension Ionide.Ionide-FAKE
code --install-extension patrys.vscode-code-outline

#
# --- Sublime ---
#
echo -e "${YELLOW}Installing Sublime.${NC}"
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo zypper -n addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo zypper -n install sublime-text
mkdir -p "~/.config/sublime-text-3/Installed Packages"
wget -O "~/.config/sublime-text-3/Installed Packages/Package Control.sublime-package" https://packagecontrol.io/Package%20Control.sublime-package
mkdir -p ~/.config/sublime-text-3/Packages/User/
mv "Package Control.sublime-settings" ~/.config/sublime-text-3/Packages/User/

#
# --- Kitty ---
#
echo -e "${YELLOW}Installing Kitty${NC}"
git clone https://github.com/kovidgoyal/kitty && cd kitty
make
cd ..
mv kitty "$BIN_DIR/Kitty"
cp -r kitty_session "$BIN_DIR/Kitty/sessions"

#
# --- Configuration files ---
#
echo -e "${YELLOW}Setting configuration files.${NC}"
echo -e "Vim"
echo -e "Awesome"
echo -e "Zsh"

#
# --- Eye Candy! ---
#
echo -e "${YELLOW}Downloading wallpaper${NV}"
wget --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:21.0) Gecko/20100101 Firefox/21.0" -O ~/pictures/wallpaper.jpg https://interfacelift.com/wallpaper/7yz4ma1/04128_glaciertrifecta_2560x1440.jpg

#
# --- Video Codecs ---
#
echo -e "${YELLOW}Installing video codes.${NC}"
sudo zypper -n ar -f -c http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
sudo zypper refresh
sudo zypper -n install libavcodec57 libavutil55 libcelt0-2 libfdk-aac1 libopenjpeg1 libswresample2 libva2 libva-drm2 libva-glx2 libva-x11-2 libvdpau1 libx264-148 libx265-146 libxvidcore4

#
# --- vim ---
#
echo -e "${YELLOW}Installing vim plugin manager.${NC}"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#
# --- Awesome (Tyrannical)
#
echo -e "${YELLOW}Installing Tyrannical for Awesome.${NC}"
git clone https://github.com/Elv13/tyrannical.git ~/.config/awesome/tyrannical

#
# --- Android Studio ---
#
cd ~/downloads
wget -O studio.zip https://dl.google.com/dl/android/studio/ide-zips/3.0.1.0/android-studio-ide-171.4443003-linux.zip
sudo unzip studio.zip -d /opt/
cd ~/bin
ln -s /opt/android-studio/bin/studio.sh

