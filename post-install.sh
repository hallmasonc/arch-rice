#!/bin/bash

# colors for prettier echo
BOLD='\e[1m'
BRED='\e[91m'
BBLUE='\e[34m'  
BGREEN='\e[92m'
BYELLOW='\e[93m'
RESET='\e[0m'

## variables
dotfiles_repo="https://github.com/hallmasonc/dotfiles"
dotfiles_dir="$HOME/.dotfiles"
rofi_repo="https://github.com/adi1090x/rofi"
rofi_dir="$HOME/.config/rofi.git"
yay_repo="https://aur.archlinux.org/yay.git"
yay_dir="$HOME/.yay"
lightdm_conf="/etc/lightdm/lightdm.conf"
rofi_launcher="$HOME/.config/rofi/launchers/type-3/launcher.sh"
rofi_power="$HOME/.config/rofi/powermenu/type-1/powermenu.sh"
launcher_theme='style-10'
power_theme='style-3'

## functions
# pretty print
info_print () {
    echo -e "${BOLD}${BGREEN}[ ${BYELLOW}•${BGREEN} ] $1${RESET}"
}

error_print () {
    echo -e "${BOLD}${BRED}[ ${BBLUE}•${BRED} ] $1${RESET}"
}

# git clone
git_clone () {
    info_print "Attempting to clone into: $2"

    if git clone $1 $2; then
        info_print "Clone successful!"
    else
        error_print "Clone failed for $1"
        error_print "Error: $?"
        exit 1
    fi
}

install_pacman_pkgs () {
    info_print "Updating pacman database..."
    sudo pacman -Syy

    info_print "Installing pacman packages..."
    sudo pacman -S --needed - < ./packages/pacman.txt
}

install_yay_pkgs () {
    info_print "Installing yay packages..."
    yay -S --needed - < ./packages/yay.txt
}

build_source () {
    info_print "Moving into package directory..."
    cd $1

    info_print "Building package..."
    makepkg --noconfirm -si

    info_print "Moving back to previous directory..."
    cd -
    
    info_print "Cleaning up package directory..."
    rm -rf $1
}

install_flatpak_pkgs () {
    info_print "Adding flathub repo..."
    flatpak remote-add --user flathub https://flathub.org/repo/flathub.flatpakrepo

    info_print "Installing flatpak packages..."
    xargs flatpak --user install -y < ./packages/flatpak.txt
}

## main
# clone repositories
git_clone $yay_repo $yay_dir
git_clone $dotfiles_repo $dotfiles_dir
git_clone $rofi_repo $rofi_dir

# enable pacman multilib repo
sudo sed -i "/\[multilib\]/,/Include/"'s/^#*//' /etc/pacman.conf

# install packages
install_pacman_pkgs

# build yay
build_source $yay_dir

# install yay packages
install_yay_pkgs

# install flatpak packages
install_flatpak_pkgs

## misc.
# stow dotfiles
bash $dotfiles_dir/stowit.sh

# setup alacritty theme
bash $HOME/.config/alacritty/alacritty-themes.sh 

# setup rofi theme
cd $rofi_dir
bash ./setup.sh
cd -

# configure lightdm and greeter
sudo sed -i 's/^#*greeter-session\s*=.*/greeter-session=lightdm-slick-greeter/' $lightdm_conf

# modify rofi themes
sed -i "s|^theme=.*|theme='${launcher_theme}'|" $rofi_launcher
sed -i "s|^theme=.*|theme='${power_theme}'|" $rofi_power

## services
# enable global service(s)
sudo systemctl enable lightdm.service

# enable user services(s)
systemctl enable --user kanshi.service