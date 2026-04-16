#!/usr/bin/env bash

git_clone () {
    # check if destination path exists
    if [[ -d $2 ]]; then
        info_print "The destination path already exists. Fetching from remote: $1  "
        
        # change directory and git fetch and pull
        cd "$2" &> /dev/null || exit
        if git fetch &> /dev/null; then
            if git pull &> /dev/null; then
                info_print "Successfully pulled down the latest files from the remote repository! "
            else
                error_print "Couldn't pull latest files from remote repository. "
            fi
        else
            error_print "Unable to fetch from the remote repository. "
        fi

        # change directory and continue
        cd - &> /dev/null || exit
    else
        info_print "Attempting to clone into: $2"

        # clone from remote repository to destination path
        if git clone "$1" "$2" &> /dev/null; then
            info_print "Clone successful!"
        else
            error_print "Clone failed for $1"
            exit 1
        fi
    fi
}