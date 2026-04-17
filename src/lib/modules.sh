#!/usr/bin/env bash

## function(s)
build_source () {
    # change directory and build
    cd "$1" &> /dev/null || exit

    info_print "Building yay package... "
    makepkg --noconfirm -si

    # change directory and cleanup
    cd - &> /dev/null || exit
    
    info_print "Cleaning up package directory... "
    rm -rf "$1"
}

gpu_check () {
    ## variable(s)
    l_prompt="graphics card was detected."
    l_gpu=""
    
    if lspci | grep -qi "vga"; then
        if lspci | grep -i "vga" | grep -qi "intel"; then
            info_print "An Intel $l_prompt"
            l_gpu="intel"
        elif lspci | grep -i "vga" | grep -qiE "amd|ati"; then
            info_print "An AMD $l_prompt"
            l_gpu="amd"
        elif lspci | grep -i "vga" | grep -qi "nvidia"; then
            info_print "A NVIDIA $l_prompt"
            l_gpu="nvidia"
        else
            error_print "No supported l_gpu detected. "
        fi
    fi

    case $l_gpu in
        "intel") ;;
        "amd") ;;
        "nvidia") ;;
        * ) ;; 
    esac
}

install_flatpak_pkgs () {
    # add flathub repo and install packages
    info_print "Adding flathub repo for flatpak... "
    if flatpak remote-add --user flathub https://flathub.org/repo/flathub.flatpakrepo &> /dev/null; then
        info_print "Installing new packages with flatpak... "
        xargs flatpak --user install --noninteractive < packages/flatpak.txt
    else
        error_print "Couldn't add flathub repo for flatpak."
    fi
}

install_pacman_pkgs () {
    # update system and install packages
    info_print "Upgrading system packages with pacman... "
    sudo pacman -Syu 

    info_print "Installing new packages with pacman... "
    sudo pacman -S --needed - < packages/pacman.txt
}

install_yay_pkgs () {
    # install packages
    info_print "Installing new packages with yay... "
    yay -S --needed - < packages/yay.txt
}