#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 'identifier1:glow1 identifier2:glow2 ...' < file"
    echo "Glows can be: red, green, yellow, blue, magenta, cyan, white, reset"
    echo "Example: $0 'error:red_bg warning:yellow_bg' < logfile.txt"
    exit 1
}

# ANSI background color codes
declare -A glow_codes=(
    ["reset"]="0"
    ["bold"]="1"
    ["red"]="41"
    ["green"]="42"
    ["yellow"]="43"
    ["blue"]="44"
    ["magenta"]="45"
    ["cyan"]="46"
    ["white"]="47"
)

# Default glow list if no color is specified
default_glows=("41" "42" "43" "44" "45" "46" "47" "41;1")

# Check for -h flag
if [[ "$1" == "-h" ]]; then
    usage
fi

# Check if at least one argument is passed
if [ $# -lt 1 ]; then
    usage
fi

# Read identifiers and glows from the first argument
IFS=' ' read -r -a identifiers <<< "$1"

# Read the input line by line
while IFS= read -r line; do
    c=0
    num_default_glows=${#default_glows[@]}

    for identifier_glow in "${identifiers[@]}"; do
        # Split identifier and glow
        IFS=':' read -r identifier glow <<< "$identifier_glow"
        
        # Use default glow if not specified
        if [ -z "$glow" ]; then
            glow="${default_glows[$((c % num_default_glows))]}"
            c=$((c + 1))
        else
            # Validate glow
            if [[ -z "${glow_codes[$glow]}" ]]; then
                echo "Invalid glow: $glow"
                usage
            fi
            glow="${glow_codes[$glow]}"
        fi

        # Apply the glow
        line=$(echo "$line" | sed -E "s/($identifier)/\x1b[${glow}m\1\x1b[0m/g")
    done
    # Print the modified line
    echo -e "$line"
done
