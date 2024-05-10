#!/usr/bin/env bash

# Define color codes
colors=(
  '\033[0;31m'  # Red
  '\033[0;32m'  # Green
  '\033[0;34m'  # Blue
  '\033[0;33m'  # Yellow
  '\033[1;35m'  # Magenta (bold)
  '\033[1;37m'  # White (bold)
  '\033[0;36m'  # Cyan
  '\033[1;31m'  # Red (bold)
  '\033[1;32m'  # Lime Green
  '\033[1;35m'  # Neon Pink
)
reset='\033[0m'

# Highlight matching patterns
index=0
ignore_case=false
while IFS= read -r line; do
  colored_line="$line"
  for pattern in "$@"; do
    if [[ "$pattern" == "-i" ]]; then
      ignore_case=true
      continue
    fi
    
    if [[ "$pattern" =~ ^-c(${colors[@]%m*})$ ]]; then
      color="${BASH_REMATCH[1]}m"
      continue
    fi
    
    if [[ -z "$color" ]]; then
      current_color=${colors[$((index % ${#colors[@]}))]}
      ((index++))
    else
      current_color=$color
    fi
    
    if $ignore_case; then
      colored_line=$(echo "$colored_line" | sed -E "s/($pattern)/${current_color}\1${reset}/gI")
    else
      colored_line=$(echo "$colored_line" | sed -E "s/($pattern)/${current_color}\1${reset}/g")
    fi
  done
  echo -e "$colored_line"
done

echo -ne "$reset"
