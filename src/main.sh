#!/usr/bin/env bash

## source(s)
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
# shellcheck disable=SC1091
{
source "$SCRIPT_DIR/lib/bash-outputs.sh"
source "$SCRIPT_DIR/lib/git-clone.sh"
source "$SCRIPT_DIR/lib/modules.sh"
source "$SCRIPT_DIR/lib/user-selectors.sh"
}

## variable(s)
dotfiles_repo="https://github.com/hallmasonc/dotfiles"
dotfiles_dir="$HOME/.dotfiles"
yay_repo="https://aur.archlinux.org/yay-bin.git"
yay_dir="$HOME/.yay"

## function(s)
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

main () {

    # clone dotfiles
    git_clone $dotfiles_repo "$dotfiles_dir"

    # enable pacman multilib repo
    multilib_selector

    # prompt for server configuration; if function returns false
    # then install yay AUR helper and AUR packages
    if ! server_selector; then
        # clone yay AUR helper
        git_clone $yay_repo "$yay_dir"

        # build yay
        build_source "$yay_dir"

        # install yay packages
        install_yay_pkgs
    fi
    
    # install pacman packages
    install_pacman_pkgs

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
