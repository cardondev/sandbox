#!/bin/bash
##########################################################################################
#                                                                                        #
#  e88~~\  888       ,88~-_   Y88b         / ~~~888~~~ 888   | 888 ,d88~~\               #
# d888     888      d888   \   Y88b       /     888    888___| 888 8888                  #
# 8888 __  888     88888    |   Y88b  e  /      888    888   | 888 `Y88b                 #
# 8888   | 888     88888    |    Y88bd8b/       888    888   | 888  `Y88b,               #
# Y888   | 888      Y888   /      Y88Y8Y        888    888   | 888    8888               #
#  "88__/  888____   `88_-~        Y  Y         888    888   | 888 \__88P'               #
#                                                                                        #
#                                                                                        #
##########################################################################################
#                                                                                        #
#                             G L O W T H I S . S H                                      #
#                                                                                        #
##########################################################################################
#                                                                                        #
# Script Name    : glowthis.sh                                                           #
# Author         : CardonDev                                                             #       
# Date Created   : 17 May 2024                                                           #
# Last Modified  : CardonDev                                                             #            
# Date Modified  : 17 May 2024                                                           #   
# Version        : v1.0                                                                  #    
# Description    : This script highlights specified words in a text file with            #
#                  user-defined colors for easier log file analysis.                     #
#                                                                                        #
##########################################################################################
#                                                                                        #
# Usage          : -h flag provides you information on how to use the script             #                                            
#                                                                                        #
##########################################################################################
#                                                                                        #
#                            R E V I S I O N   H I S T O R Y                             #
#                                                                                        #
##########################################################################################
#                                                                                        #
# Date        | Author      | Version  | Changes                                         #
#------------ |------------ |--------- |-------------------------------------------------#
# 2024/05/17  | CardonDev   | v1.0     | Initial Release                                 #
#             |             |          |                                                 #
#             |             |          |                                                 #
#------------ |------------ |--------- |-------------------------------------------------#
#                                                                                        #
##########################################################################################
#
usage() {
    echo "Usage: $0 'identifier1:glow1 identifier2:glow2 ...' < file"
    echo "Glows can be: red, green, yellow, blue, magenta, cyan, white, reset"
    echo "Example: $0 'error:red warning:yellow' < logfile.txt"
    exit 1
}

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

if [[ "$1" == "-h" ]]; then
    usage
fi

if [ $# -lt 1 ]; then
    usage
fi

IFS=' ' read -r -a identifiers <<< "$1"

while IFS= read -r line; do
    for identifier_glow in "${identifiers[@]}"; do
        IFS=':' read -r identifier glow <<< "$identifier_glow"
        
        if [[ -z "${glow_codes[$glow]}" ]]; then
            echo "Invalid glow: $glow"
            usage
        fi

        glow_code="${glow_codes[$glow]}"
        line=$(echo "$line" | sed -E "s/($identifier)/\x1b[${glow_code}m\1\x1b[0m/g")
    done
    # Print the modified line
    echo -e "$line"
done
