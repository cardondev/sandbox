#!/usr/bin/env bash

# Define color codes
colors=(
  '\033[0;31m'  # Red
  '\033[0;32m'  # Green
  '\033[0;33m'  # Yellow
  '\033[0;34m'  # Blue
  '\033[0;35m'  # Magenta
  '\033[0;36m'  # Cyan
  '\033[1;32m'  # Lime Green
  '\033[1;35m'  # Neon Pink
)
reset='\033[0m'

# Function to display usage information
usage() {
  echo "Usage: command | glow [-i] [-c COLOR] [PATTERN...]"
  echo "Highlight text matching PATTERNs with specified COLOR or automatically assigned colors."
  echo
  echo "Options:"
  echo "  -i         Perform case-insensitive matching"
  echo "  -c COLOR   Specify the color to use for highlighting (default: automatic)"
  echo
  echo "Available colors:"
  echo "  red, green, yellow, blue, magenta, cyan, lime_green, neon_pink"
  echo
  echo "Examples:"
  echo "  cat /etc/issue | glow -i -c neon_pink authentication"
  echo "  ls | glow -i movies"
}

# Parse command-line options
ignore_case=false
color=""
while getopts ":hic:" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    i)
      ignore_case=true
      ;;
    c)
      color="${!OPTARG}"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Set grep options based on case sensitivity
if $ignore_case; then
  grep_opts="-Ei"
else
  grep_opts="-E"
fi

# Highlight matching patterns
index=0
while IFS= read -r line; do
  for pattern in "$@"; do
    if [[ -z "$color" ]]; then
      current_color=${colors[$((index % ${#colors[@]}))]}
      ((index++))
    else
      current_color=$color
    fi
    line=$(echo "$line" | grep $grep_opts --color=always "$pattern" | sed -E "s/($pattern)/${current_color}\1${reset}/gI")
  done
  echo -e "$line"
done

echo -ne "$reset"
