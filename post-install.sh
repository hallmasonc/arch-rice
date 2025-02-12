#!/bin/bash

## Variables
dot="https://github.com/hallmasonc/dotfiles"
dotDir="~/.dotfiles"

rofi="https://github.com/hallmasonc/rofi"
rofiDir="~/.config/rofi.git"

yay="https://aur.archlinux.org/yay.git"
yayDir="~/yay"

## Main
# clone yay
git clone $yay $yayDir

# clone dotfiles
git clone $dot $dotDir

# clone rofi
git clone $rofi $rofiDir

# enable pacman multilib repo
sudo sed -i "/\[multilib\]/,/Include/"'s/^#*//' /etc/pacman.conf

# force pacman database update
sudo pacman -Syy

# install pacman packages
sudo pacman -S --needed - < ./pacman.txt

# Begin yay
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

# Misc.
# stow dotfiles
bash ~/.dotfiles/stowit.sh

# alacritty theme
mkdir -p ~/.config/alacritty/themes
bash ~/.config/alacritty/alacritty-themes.sh 

# rofi theme
cd $rofiDir
bash ./setup.sh
cd -

# Services
# enable lightdm service
sudo systemctl enable lightdm.service