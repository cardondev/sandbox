#!/bin/bash

for users in /home/*; do

    if [ -d "$users" ]; then

        username=$(basename "$users")

        bashrc_file="$users /.bashrc"

        if [ -f "$bashrc_file" ]; then

            if ! grep -q 'HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %Z "' "$bashrc_file"; then
    
                echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %Z "' >> "$bashrc_file"
                echo "Added HISTTIMEFORMAT to $username's .bashrc"
            else
                echo "HISTTIMEFORMAT already exists in $username's .bashrc"
            fi
            
            su - "$username" -c "source $bashrc_file"
            echo "Sourced $username's .bashrc"
        else
            echo "User $username does not have a .bashrc file"
        fi
    fi
done
