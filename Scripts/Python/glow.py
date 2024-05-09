#!/usr/bin/env python3

import argparse
import re
import sys
import time

# Define color codes
color_codes = {
    "red": "\033[0;31m",
    "green": "\033[0;32m",
    "yellow": "\033[0;33m",
    "blue": "\033[0;34m",
    "magenta": "\033[0;35m",
    "cyan": "\033[0;36m",
    "lime_green": "\033[1;32m",
    "neon_pink": "\033[1;35m",
}
reset = "\033[0m"

# Define glow animation frames
glow_frames = [
    "\033[1;33m",  # Bright yellow
    "\033[1;32m",  # Bright green
    "\033[1;36m",  # Bright cyan
    "\033[1;35m",  # Bright magenta
    "\033[1;31m",  # Bright red
]

def animate_glow(text, color, duration=0.5, interval=0.1):
    frames = [f"{frame}{text}{reset}" for frame in glow_frames]
    start_time = time.time()
    while time.time() - start_time < duration:
        for frame in frames:
            sys.stdout.write(f"\r{frame}")
            sys.stdout.flush()
            time.sleep(interval)
    sys.stdout.write(f"\r{color}{text}{reset}")
    sys.stdout.flush()
    print()

def highlight_matches(text, patterns, colors):
    for pattern, color in zip(patterns, colors):
        text = re.sub(f"({pattern})", f"{color}\\1{reset}", text)
    return text

def main():
    parser = argparse.ArgumentParser(description="Highlight text matching patterns with specified colors or automatically cycle through colors.")
    parser.add_argument("-c", "--color", action="append", nargs=2, metavar=("COLOR", "PATTERN"), help="Specify the color to use for highlighting the given pattern")
    parser.add_argument("-a", "--animate", action="store_true", help="Enable glow animation effect")
    parser.add_argument("patterns", nargs="*", metavar="PATTERN", help="Patterns to highlight")
    args = parser.parse_args()

    patterns = [pattern for _, pattern in args.color] + args.patterns
    colors = [color_codes[color] for color, _ in args.color]

    if not patterns:
        parser.print_help()
        sys.exit(1)

    for line in sys.stdin:
        highlighted_line = highlight_matches(line, patterns, colors)
        if args.animate:
            animate_glow(highlighted_line, colors[0])
        else:
            print(highlighted_line, end="")

    if colors:
        print(reset, end="")

if __name__ == "__main__":
    main()
