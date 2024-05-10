#!/usr/bin/env bash

# Define color codes for background
colors=(
  '\033[41m'  # Red
  '\033[42m'  # Green
  '\033[44m'  # Blue
  '\033[43m'  # Yellow
  '\033[45m'  # Magenta
  '\033[47m'  # White
  '\033[46m'  # Cyan
  '\033[101m'  # Red (bright)
  '\033[102m'  # Lime Green
  '\033[105m'  # Neon Pink
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
    
    if [[ "$pattern" =~ ^-c(red|green|blue|yellow|magenta|white|cyan|red_bright|lime_green|neon_pink)$ ]]; then
      color="${colors[${BASH_REMATCH[1]}]}"
      continue
    fi
    
    if [[ -z "$color" ]]; then
      current_color=${colors[$((index % ${#colors[@]}))]}
      ((index++))
    else
      current_color=$color
    fi
    
    if $ignore_case; then
      colored_line=$(echo "$colored_line" | sed -E "s/(${pattern})/${current_color}\1${reset}/gI")
    else
      colored_line=$(echo "$colored_line" | sed -E "s/(${pattern})/${current_color}\1${reset}/g")
    fi
  done
  echo -e "$colored_line"
done

echo -ne "$reset"
