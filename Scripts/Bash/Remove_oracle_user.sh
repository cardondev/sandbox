#!/bin/bash

# Check if oracle user exists
if ! id -u oracle > /dev/null 2>&1; then
    echo "Oracle user does not exist. Exiting script."
    exit 0
fi

# Remove oracle user and home directory
userdel -r oracle

echo "Successfully removed oracle user and home directory"
