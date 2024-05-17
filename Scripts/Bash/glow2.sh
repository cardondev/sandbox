#!/bin/bash

# Define the array of colors
glows=("41" "42" "44" "43" "45" "47" "46" "41;1")

# Split the input patterns into an array
IFS=' ' read -r -a regexp <<< "$*"

# Print the patterns and colors (for debugging purposes)
echo -e "\n<${regexp[*]}>\n"
echo -e "\n<${glows[*]}>\n"

# Read the input line by line
while IFS= read -r line; do
    # Initialize the glow index
    c=0
    num_glows=${#glows[@]}

    # Loop through each pattern
    for rex in "${regexp[@]}"; do
        c=$(( c % num_glows ))
        glow=${glows[$c]}
        # Replace the pattern with the highlighted pattern
        line=$(echo "$line" | sed -E "s/($rex)/\x1b[${glow}m\1\x1b[0m/g")
        c=$(( c + 1 ))
    done
    # Print the modified line
    echo -e "$line"
done
