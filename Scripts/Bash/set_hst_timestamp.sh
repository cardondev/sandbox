#!/bin/bash

# Loop through all users in the /home directory
for users in /home/*; do
    # Check if the directory is a valid user home directory
    if [ -d "$users" ]; then
        # Get the username from the directory name
        username=$(basename "$users")

        # Check if the user has a .bashrc file
        bashrc="$users/.bashrc"
        if [ -f "$bashrc" ]; then
            # Check if the HISTTIMEFORMAT line already exists in the .bashrc file
            if ! grep -q 'HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %Z "' "$bashrc"; then
                # Add the HISTTIMEFORMAT line to the .bashrc file
                echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %Z "' >> "$bashrc"
                echo "Added HISTTIMEFORMAT to $username's .bashrc"
            else
                echo "HISTTIMEFORMAT already exists in $username's .bashrc"
            fi

            # Source the .bashrc file for the user
            su - "$username" -c "source $bashrc"
            echo "Sourced $username's .bashrc"
        else
            echo "Creating .bashrc file for $username"
            touch "$bashrc"
            echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %Z "' >> "$bashrc"
            echo "Added HISTTIMEFORMAT to $username's .bashrc"
            
            # Source the .bashrc file for the user
            su - "$username" -c "source $bashrc"
            echo "Sourced $username's .bashrc"
        fi
    fi
done
