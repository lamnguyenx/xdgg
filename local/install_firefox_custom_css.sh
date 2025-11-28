#!/bin/bash
# --------------------------------------------------------------
#                     install_firefox_custom_css.sh
# --------------------------------------------------------------
# Install script for Firefox userChrome.css customization
# Creates symlink from dotfiles to Firefox profile chrome directory

set -Eeuo pipefail

# Source bax logging functions for nice output
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../dot-bashrc/bax/logging.sh"

# Firefox base directory on macOS (profiles.ini contains Paths starting with "Profiles/")
FIREFOX_BASE_DIR="$HOME/Library/Application Support/Firefox"
PROFILES_INI="$FIREFOX_BASE_DIR/profiles.ini"

# Check if Firefox base directory exists
if [[ ! -d "$FIREFOX_BASE_DIR" ]]; then
    log_error "Firefox directory not found at $FIREFOX_BASE_DIR"
    log_error "Make sure Firefox is installed and has been run at least once."
    exit 1
fi

# Check if profiles.ini exists
if [[ ! -f "$PROFILES_INI" ]]; then
    log_error "Firefox profiles.ini not found at $PROFILES_INI"
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

log_info "Found Firefox profiles:"
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

    log_info "Processing profile: $(basename "$PROFILE_DIR")"

    # Check if profile directory exists
    if [[ ! -d "$PROFILE_DIR" ]]; then
        log_warning "Profile directory not found at $PROFILE_DIR, skipping"
        continue
    fi

    # Create chrome directory if it doesn't exist
    CHROME_DIR="$PROFILE_DIR/chrome"
    if [[ ! -d "$CHROME_DIR" ]]; then
        mkdir -p "$CHROME_DIR"
        log_info "  Created chrome directory: $CHROME_DIR"
    fi

    # Archive existing userChrome.css (archive.sh handles existence and symlink checks)
    USERCHROME_DEST="$CHROME_DIR/userChrome.css"
    "$SCRIPT_DIR/archive.sh" "$USERCHROME_DEST"

    # Create symlink
    ln -sf "$USERCHROME_SRC" "$USERCHROME_DEST"
    log_ok "  Created symlink: $(ls -la "$USERCHROME_DEST" | sed "s|$HOME|~|g")"
    echo ""
done

log_ok "Firefox userChrome.css installed to all profiles successfully!"
log_info "Restart Firefox (all versions) to apply changes."
echo ""
log_warning "⚠️  IMPORTANT: Enable userChrome.css support in Firefox"
log_info "   1. Open Firefox and go to about:config"
log_info "   2. Search for: toolkit.legacyUserProfileCustomizations.stylesheets"
log_info "   3. Set the value to: true"
log_info "   4. Restart Firefox completely"