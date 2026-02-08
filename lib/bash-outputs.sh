#!/usr/bin/env bash

## variable(s)
RED='\e[91m'
GREEN='\e[92m'
YELLOW='\e[93m'
BOLD='\e[1m'
RESET='\e[0m'

## function(s)
# pretty print
info_print () {
    echo -e "${BOLD}${GREEN}[ ${YELLOW}• ${GREEN}] $1${RESET}"
}

# pretty error
error_print () {
    echo -e "${BOLD}${RED}[ ${YELLOW}! ${RED}] $1${RESET}"
}