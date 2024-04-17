#!/bin/bash

# Function to update .bashrc file
update_bashrc() {
    local username=$1
    local bashrc=$2

    # Check if the HISTTIMEFORMAT line already exists in the .bashrc file
    if ! grep -q 'HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %Z "' "$bashrc"; then
        # Add the HISTTIMEFORMAT line to the .bashrc file
        echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S %Z "' >> "$bashrc"
        echo "Added HISTTIMEFORMAT to $username's .bashrc"
    else
        echo "HISTTIMEFORMAT already exists in $username's .bashrc"
    fi

    # Source the .bashrc file for the user
    if [ "$username" = "root" ]; then
        source "$bashrc"
    else
        su - "$username" -c "source $bashrc"
    fi
    echo "Sourced $username's .bashrc"
}

# Update root's .bashrc file
root_bashrc="/root/.bashrc"
if [ -f "$root_bashrc" ]; then
    update_bashrc "root" "$root_bashrc"
else
    echo "Creating .bashrc file for root"
    touch "$root_bashrc"
    update_bashrc "root" "$root_bashrc"
fi

# Loop through all users in the /home directory
for users in /home/*; do
    # Check if the directory is a valid user home directory
    if [ -d "$users" ]; then
        # Get the username from the directory name
        username=$(basename "$users")

        # Check if the user has a .bashrc file
        bashrc="$users/.bashrc"
        if [ -f "$bashrc" ]; then
            update_bashrc "$username" "$bashrc"
        else
            echo "Creating .bashrc file for $username"
            touch "$bashrc"
            update_bashrc "$username" "$bashrc"
        fi
    fi
done
