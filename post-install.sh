#!/bin/bash

## prettier echo
# cosmetics (colors for text).
BOLD='\e[1m'
BRED='\e[91m'
BBLUE='\e[34m'  
BGREEN='\e[92m'
BYELLOW='\e[93m'
RESET='\e[0m'

## functions
# pretty print
info_print () {
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
}
# git clone
gc () {
    info_print "Cloning into: ${2}"
    git clone $1 $2
}

## variables
dot="https://github.com/hallmasonc/dotfiles"
dotDir="~/.dotfiles"
rofi="https://github.com/hallmasonc/rofi"
rofiDir="~/.config/rofi.git"
yay="https://aur.archlinux.org/yay.git"
yayDir="~/yay"

## main
# yay
gc $yay $yayDir
# dotfiles
gc $dot $dotDir
# rofi
gc $rofi $rofiDir

# enable pacman multilib repo
sudo sed -i "/\[multilib\]/,/Include/"'s/^#*//' /etc/pacman.conf
# force pacman database update
sudo pacman -Syy
# install pacman packages
sudo pacman -S --needed - < ./pacman.txt

# begin yay
if [ ! -d "$yayDir" ]; then
    echo "failed to clone yay repo"
else
    # move directory and build
    cd $yayDir
    makepkg --noconfirm -si
    # move back to previous directory
    cd -
    # remove yay directory (cleanup)
    rm -rf $yayDir
    # install yay packages
    yay -S --needed - < ./yay.txt
fi

# add flathub as remote for flatpak
flatpak remote-add --user flathub https://flathub.org/repo/flathub.flatpakrepo
# install flatpak applications
xargs flatpak --user install -y < ./flatpak.txt

## misc.
# stow dotfiles
bash ~/.dotfiles/stowit.sh
# alacritty theme
bash ~/.config/alacritty/alacritty-themes.sh 
# rofi theme
cd $rofiDir
bash ./setup.sh
cd -

## services
# enable lightdm service
sudo systemctl enable lightdm.service