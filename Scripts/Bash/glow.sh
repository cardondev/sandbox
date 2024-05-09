#!/usr/bin/env bash

# Define color codes
declare -A color_codes=(
  ["red"]='\033[0;31m'
  ["green"]='\033[0;32m'
  ["yellow"]='\033[0;33m'
  ["blue"]='\033[0;34m'
  ["magenta"]='\033[0;35m'
  ["cyan"]='\033[0;36m'
  ["lime_green"]='\033[1;32m'
  ["neon_pink"]='\033[1;35m'
)
reset='\033[0m'

# Function to display usage information
usage() {
  echo "Usage: glow [-h] [-c COLOR PATTERN]... [PATTERN...]"
  echo "Highlight text matching PATTERNs with specified COLORs or automatically cycle through colors."
  echo
  echo "Options:"
  echo "  -h                 Display this help message"
  echo "  -c COLOR PATTERN   Specify the color to use for highlighting the given PATTERN"
  echo
  echo "Available colors:"
  echo "  red, green, yellow, blue, magenta, cyan, lime_green, neon_pink"
  echo
  echo "Example:"
  echo "  cat file.txt | glow -c red error -c lime_green success warning"
}

# Parse command-line options
declare -a patterns=()
declare -a colors=()
while getopts ":hc:" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    c)
      color="$OPTARG"
      if [[ -z "${color_codes[$color]}" ]]; then
        echo "Invalid color: $color" >&2
        usage
        exit 1
      fi
      shift
      if [ $# -eq 0 ]; then
        echo "Missing PATTERN for -c $color" >&2
        usage
        exit 1
      fi
      pattern="$1"
      patterns+=("$pattern")
      colors+=("${color_codes[$color]}")
      shift
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Append remaining patterns to the patterns array
patterns+=("$@")

# Check if at least one pattern is provided
if [ ${#patterns[@]} -eq 0 ]; then
  echo "Missing PATTERN" >&2
  usage
  exit 1
fi

# Highlight matching text with specified colors or automatically cycle through colors
color_index=0
for i in "${!patterns[@]}"; do
  pattern="${patterns[$i]}"
  if [ $i -lt ${#colors[@]} ]; then
    color="${colors[$i]}"
  else
    color="${color_codes[${!color_codes[@]:$color_index:1}]}"
    color_index=$((($color_index + 1) % ${#color_codes[@]}))
  fi
  grep --color=always -E "$pattern" | sed "s/($pattern)/$(echo -ne $color)\1$(echo -ne $reset)/gI"
done
