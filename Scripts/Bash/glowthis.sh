#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 'identifier1:glow1 identifier2:glow2 ...' < file"
    echo "Glows can be: red, green, yellow, blue, magenta, cyan, white, reset"
    exit 1
}

# ANSI color codes
declare -A glow_codes=(
    ["reset"]="0"
    ["bold"]="1"
    ["red"]="31"
    ["green"]="32"
    ["yellow"]="33"
    ["blue"]="34"
    ["magenta"]="35"
    ["cyan"]="36"
    ["white"]="37"
    ["red_bg"]="41"
    ["green_bg"]="42"
    ["yellow_bg"]="43"
    ["blue_bg"]="44"
    ["magenta_bg"]="45"
    ["cyan_bg"]="46"
    ["white_bg"]="47"
)

# Check if at least one argument is passed
if [ $# -lt 1 ]; then
    usage
fi

# Read identifiers and glows from the first argument
IFS=' ' read -r -a identifiers <<< "$1"

# Read the input line by line
while IFS= read -r line; do
    for identifier_glow in "${identifiers[@]}"; do
        # Split identifier and glow
        IFS=':' read -r identifier glow <<< "$identifier_glow"
        
        # Validate glow
        if [[ -z "${glow_codes[$glow]}" ]]; then
            echo "Invalid glow: $glow"
            usage
        fi

        # Apply the glow
        glow_code="${glow_codes[$glow]}"
        line=$(echo "$line" | sed -E "s/($identifier)/\x1b[${glow_code}m\1\x1b[0m/g")
    done
    # Print the modified line
    echo -e "$line"
done
