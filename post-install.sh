#!/usr/bin/env bash

## source(s)
# shellcheck disable=SC1091
source lib/bash-outputs.sh

## variable(s)
dotfiles_repo="https://github.com/hallmasonc/dotfiles"
dotfiles_dir="$HOME/.dotfiles"
yay_repo="https://aur.archlinux.org/yay-bin.git"
yay_dir="$HOME/.yay"

## function(s)
git_clone () {
    info_print "Attempting to clone into: $2"

    if git clone "$1" "$2"; then
        info_print "Clone successful!"
    else
        error_print "Clone failed for $1"
        exit 1
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

install_flatpak_pkgs () {
    # add flathub repo and install packages
    info_print "Adding flathub repo for flatpak... "
    if flatpak remote-add --user flathub https://flathub.org/repo/flathub.flatpakrepo; then
        info_print "Installing new packages with flatpak... "
        xargs flatpak --user install --noninteractive < packages/flatpak.txt
    else
        error_print "Couldn't add flathub repo for flatpak."
    fi
}

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

configure_plymouth () {
    # configure splash setting for grub and error output only
    info_print "Configuring GRUB command line w/ splash screen... "
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 splash"/' /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null
    
    # configure mkinitcpio to include plymouth, set theme, and regenerate mkinitcpio
    if ! grep -q 'plymouth' /etc/mkinitcpio.conf; then
        info_print "Adding plymouth to mkinitcpio.conf as a new hook... "
        sudo sed -i 's/\(HOOKS=(systemd\)/\1 plymouth/' /etc/mkinitcpio.conf
        sudo plymouth-set-default-theme -R monoarch-refined &> /dev/null
    fi
}

multilib_check () {
    info_print "Checking pacman multilib repository status... "
    if grep -q "^\[multilib\]" /etc/pacman.conf; then
        info_print "The multilib repository is already enabled. "
        return 0
    else 
        input_print "The multilib repository is not configured, enable it? (y/N): "
        read -r user_choice

        case $user_choice in 
            y|Y)
                info_print "Enabling the multilib repository... "
                sudo sed -i "/\[multilib\]/,/Include/"'s/^#*//' /etc/pacman.conf
                return 0
                ;;
            *)
                info_print "Skipping multilib setup. If prompted again, do enable the repository. "
                return 1
                ;;
        esac
    fi
}

main () {
    # clone repositories
    git_clone $yay_repo "$yay_dir"
    git_clone $dotfiles_repo "$dotfiles_dir"

    # enable pacman multilib repo
    multilib_check

    # install pacman packages
    install_pacman_pkgs

    # build yay
    build_source "$yay_dir"

    # install yay packages
    install_yay_pkgs

    # install flatpak packages
    install_flatpak_pkgs

    # stow dotfiles
    bash "$dotfiles_dir/stowit.sh"

    # setup oh-my-posh
    curl -s https://ohmyposh.dev/install.sh | bash -s

    # setup alacritty theme
    . "$HOME/.config/alacritty/alacritty-themes.sh"

    # setup rofi theme
    . "$HOME/.config/rofi/rofi-themes.sh"

    # download default wallpaper
    . "$HOME/.config/sway/scripts/default-wallpaper.sh"

    # configure plymouth splash screen
    configure_plymouth

    ## service(s)
    # enable user service(s)
    systemctl enable --user --now kanshi.service &> /dev/null
    systemctl enable --user --now swayidle.service &> /dev/null

    # enable system service(s)
    sudo systemctl enable ly@tty1 &> /dev/null
    sudo systemctl enable --now tuned &> /dev/null
}

## init main
main
