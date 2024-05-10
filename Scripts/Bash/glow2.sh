#!/usr/bin/env bash

# Define color codes
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
lime_green='\033[1;32m'
neon_pink='\033[1;35m'
bold_red='\033[1;31m'
bold_green='\033[1;32m'
bold_yellow='\033[1;33m'
bold_blue='\033[1;34m'
reset='\033[0m'

# Function to display usage information
usage() {
  echo "Usage: command | glow [-c COLOR] [PATTERN...]"
  echo "Highlight text matching PATTERNs with specified COLOR or automatically assigned colors."
  echo
  echo "Options:"
  echo "  -c COLOR   Specify the color to use for highlighting (default: automatic)"
  echo
  echo "Available colors:"
  echo "  red, green, yellow, blue, magenta, cyan, lime_green, neon_pink,"
  echo "  bold_red, bold_green, bold_yellow, bold_blue"
  echo
  echo "Examples:"
  echo "  cat myfile.txt | glow -c neon_pink text1 text2"
  echo "  ls | glow movies"
}

# Parse command-line options
color=""
while getopts ":hc:" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    c)
      case "$OPTARG" in
        red|green|yellow|blue|magenta|cyan|lime_green|neon_pink|bold_red|bold_green|bold_yellow|bold_blue)
          color="${!OPTARG}"
          ;;
        *)
          echo "Invalid color: $OPTARG" >&2
          usage
          exit 1
          ;;
      esac
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Assign default colors if no color is specified
if [[ -z "$color" ]]; then
  colors=("$red" "$green" "$blue" "$yellow" "$magenta" "$cyan" "$lime_green" "$neon_pink")
  num_colors=${#colors[@]}
fi

# Highlight matching patterns
index=0
while IFS= read -r line; do
  for pattern in "$@"; do
    if [[ -z "$color" ]]; then
      current_color=${colors[$((index % num_colors))]}
      ((index++))
    else
      current_color=$color
    fi
    line=$(echo "$line" | sed -E "s/($pattern)/${current_color}\1${reset}/g")
  done
  echo -e "$line"
done

echo -ne "$reset"
