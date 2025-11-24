#!/bin/bash
# --------------------------------------------------------------
#                         bax.sh
# --------------------------------------------------------------
# Modularized bash configuration for development environment
# Sources individual modules for better organization and maintainability

# Calculate script directory once
bax_dir="$(dirname "${BASH_SOURCE[0]}")"

# Core modules - always loaded
    source "$bax_dir/essentials.sh"
    source "$bax_dir/args.sh"
    source "$bax_dir/logging.sh"
    source "$bax_dir/misc.sh"

# Proxies module - contains sensitive credentials, load conditionally
# Uncomment the following line if you need proxy functionality:
    # source "$bax_dir/proxies.sh"

# Application-specific modules
    source "$bax_dir/docker.sh"
    source "$bax_dir/git.sh"
    source "$bax_dir/homebrew.sh"

# Project and terminal setup
    source "$bax_dir/projects.sh"
    source "$bax_dir/terminal.sh"

# Updated reload function to reload all modules
function reload_bax() {
    # script_dir is already defined globally as bax_dir

    # Reload all modules
source "$bax_dir/essentials.sh"
source "$bax_dir/args.sh"
source "$bax_dir/logging.sh"
source "$bax_dir/misc.sh"

    # Conditional proxy loading (commented by default for security)
# source "$bax_dir/proxies.sh"

source "$bax_dir/docker.sh"
source "$bax_dir/git.sh"
source "$bax_dir/homebrew.sh"
source "$bax_dir/projects.sh"
source "$bax_dir/terminal.sh"

    echo "✅ All bax modules reloaded"
}