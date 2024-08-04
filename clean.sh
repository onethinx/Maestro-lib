#!/bin/bash

# Get the files
SCRIPT_DIR="$(dirname "$0")"
MESON_FILE="$SCRIPT_DIR/meson.build"
BRD_CFG_FILE="$SCRIPT_DIR/.vscode/brd.cfg"

## Function to remove everything between #***_Start and #***_End in meson.build
clean_meson_file() {
  awk '
  BEGIN { keep=1 }
  /#.*_Start/ { print; keep=0 }
  /#.*_End/ { print; keep=1; next }
  keep { print }
  ' "$MESON_FILE" > "$MESON_FILE.tmp" && mv "$MESON_FILE.tmp" "$MESON_FILE"
  sed -i '' -e '/#.*_Line/{n;s/.*//;}' "$MESON_FILE"
  sed -i '' -e '/#.*_Lines/{n;s/.*//;n;s/.*//;}' "$MESON_FILE"
  echo "Cleaned $MESON_FILE"
}

# Function to remove the first line of .vscode/brd.cfg if it contains "PROGRAMMER"
clean_brd_cfg_file() {
  # Read the first line of the file
  first_line=$(head -n 1 "$BRD_CFG_FILE")
  
  # Check if the first line contains "PROGRAMMER"
  if [[ "$first_line" == *PROGRAMMER* ]]; then
    # Remove the first line
    sed -i '' -e '1d' "$BRD_CFG_FILE"
  fi
  echo "Cleaned $BRD_CFG_FILE"
}

# Run the functions
clean_meson_file
clean_brd_cfg_file