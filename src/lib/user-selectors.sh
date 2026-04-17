#!/usr/bin/env bash

## function(s)
firewall_selector () {
    # prompt
    input_print "Install and configure ufw (firewall)? [y/n]: "
    read -r l_user_choice

    case $l_user_choice in 
        y|Y)
            # install ufw
            info_print "Installing ufw... "
            sudo pacman -S --needed ufw

            # configure ufw
            info_print "Configuring ufw... "
            sudo ufw default allow outgoing 
            sudo ufw default deny incoming
            sudo ufw logging on
            sudo ufw enable
            sudo ufw status verbose
            return 0
            ;;
        *)
            # do not install ufw
            info_print "Package ufw will not be installed. If prompted again, do install the package. "
            return 1
    esac
}

multilib_selector () {
    # check if multilib repository is enabled
    info_print "Checking pacman multilib repository status... "
    if grep -q "^\[multilib\]" /etc/pacman.conf; then
        info_print "The multilib repository is already enabled. "
        return 0
    else
        # prompt to enable multilib repository
        input_print "The multilib repository is not configured, enable it? [y/n]: "
        read -r l_user_choice

        case $l_user_choice in 
            y|Y)
                # enable repository
                info_print "Enabling the multilib repository... "
                sudo sed -i "/\[multilib\]/,/Include/"'s/^#*//' /etc/pacman.conf
                return 0
                ;;
            *)
                # do not enable repository
                info_print "Skipping multilib setup. If prompted again, do enable the repository. "
                return 1
                ;;
        esac
    fi
}

server_selector () {
    # prompt
    input_print "Configure this device as a server? [y/n]: "
    read -r l_user_choice

    case $l_user_choice in 
        y|Y)
            info_print "This device will be configured as a server. "
            
            # enable sshd
            info_print "Enabling ssh server for remote access... "
            sudo systemctl enable sshd &> /dev/null

            # install and configure ufw
            info_print "Enabling ufw firewall and configuring additional rules... "
            until firewall_selector; do : ; done
            sudo ufw limit ssh &> /dev/null

            # return true
            return 0 
            ;;
        *)
            info_print "This device will be configured as a standard workstation. "

            # prompt for ufw installation and configuration
            firewall_selector

            # return false
            return 1
            ;;
    esac    
}