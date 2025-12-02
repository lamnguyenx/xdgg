#!/bin/bash
# --------------------------------------------------------------
#                     install_firefox_custom_css.sh
# --------------------------------------------------------------
# Install script for Firefox userChrome.css customization
# Creates symlink from dotfiles to Firefox profile chrome directory

set -Eeuo pipefail

# Define logging functions
ANSIFmt__reset='\033[00m'
ANSIFmt__red='\033[31m'
ANSIFmt__green='\033[32m'

function echo_green() { printf "$ANSIFmt__green$*$ANSIFmt__reset\n"; }
function echo_red()   { printf "$ANSIFmt__red$*$ANSIFmt__reset\n"; }

# Firefox base directory on macOS (profiles.ini contains Paths starting with "Profiles/")
FIREFOX_BASE_DIR="$HOME/Library/Application Support/Firefox"
PROFILES_INI="$FIREFOX_BASE_DIR/profiles.ini"

# Check if Firefox base directory exists
if [[ ! -d "$FIREFOX_BASE_DIR" ]]; then
    echo_red "Firefox directory not found at $FIREFOX_BASE_DIR"
    echo_red "Make sure Firefox is installed and has been run at least once."
    exit 1
fi

# Check if profiles.ini exists
if [[ ! -f "$PROFILES_INI" ]]; then
    echo_red "Firefox profiles.ini not found at $PROFILES_INI"
    exit 1
fi

# Find all profile directories
PROFILE_PATHS=$(grep -A 5 "\[Profile[0-9]*\]" "$PROFILES_INI" | grep "^Path=" | cut -d'=' -f2)

if [[ -z "$PROFILE_PATHS" ]]; then
    echo "Error: Could not find any Firefox profiles"
    echo "Please check your Firefox installation."
    exit 1
fi

# Path to our userChrome.css
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERCHROME_SRC="$SCRIPT_DIR/../dot-config/firefox/chrome/userChrome.css"

# Check if source file exists
if [[ ! -f "$USERCHROME_SRC" ]]; then
    echo "Error: userChrome.css not found at $USERCHROME_SRC"
    exit 1
fi

echo_green "Found Firefox profiles:"
echo "$PROFILE_PATHS" | sed "s|^|$FIREFOX_BASE_DIR/|" | sed 's/^/  /'
echo ""

# Process each profile
echo "$PROFILE_PATHS" | while read -r PROFILE_PATH; do
    # Handle relative paths (Firefox sometimes uses relative paths)
    if [[ "$PROFILE_PATH" != /* ]]; then
        PROFILE_DIR="$FIREFOX_BASE_DIR/$PROFILE_PATH"
    else
        PROFILE_DIR="$PROFILE_PATH"
    fi

    echo_green "Processing profile: $(basename "$PROFILE_DIR")"

    # Check if profile directory exists
    if [[ ! -d "$PROFILE_DIR" ]]; then
        echo_red "Profile directory not found at $PROFILE_DIR, skipping"
        continue
    fi

    # Create chrome directory if it doesn't exist
    CHROME_DIR="$PROFILE_DIR/chrome"
    if [[ ! -d "$CHROME_DIR" ]]; then
        mkdir -p "$CHROME_DIR"
        echo_green "  Created chrome directory: $CHROME_DIR"
    fi

    # Archive existing userChrome.css (archive.sh handles existence and symlink checks)
    USERCHROME_DEST="$CHROME_DIR/userChrome.css"
    "$SCRIPT_DIR/archive.sh" "$USERCHROME_DEST"

    # Create symlink
    ln -sf "$USERCHROME_SRC" "$USERCHROME_DEST"
    echo_green "  Created symlink: $(ls -la "$USERCHROME_DEST" | sed "s|$HOME|~|g")"
    echo ""
done

echo_green "Firefox userChrome.css installed to all profiles successfully!"
echo_green "Restart Firefox (all versions) to apply changes."
echo ""
echo_red "⚠️  IMPORTANT: Enable userChrome.css support in Firefox"
echo_green "   1. Open Firefox and go to about:config"
echo_green "   2. Search for: toolkit.legacyUserProfileCustomizations.stylesheets"
echo_green "   3. Set the value to: true"
echo_green "   4. Restart Firefox completely"