# XDG-Based CLI Dev Environment Setup

This project contains XDG Base Directory specification-compliant configuration and setup files for various TUI (Text User Interface) tools designed for CLI-based development. Built to work seamlessly across different environments, including Android via Termux.

## Overview

A collection of personal dotfiles and configurations for essential CLI development tools, enabling efficient terminal-based workflows on any platform.

## TUI Tools

### Helix Editor
A post-modern text editor with built-in language server support. Features modal editing and multi-selection capabilities.
- **Appearance**: Minimalist UI with configurable high-contrast themes
- **Behavior**: Modal-based navigation (normal, insert, selection modes)
- **Custom themes**: `hcl` (High Contrast Light) and `hcd` (High Contrast Dark) optimized for readability
- **Key Bindings**:
  - `Tab`: Indent
  - `Shift+Tab`: Unindent
  - Standard Helix modal keybindings for efficient text editing

 ### Lazygit
 A simple terminal UI for git operations. Provides a keyboard-driven git interface without leaving the terminal.
 - **Appearance**: Colorful, interactive panels showing branches, commits, staging areas
 - **Behavior**: Fast git workflows with intuitive keybindings for common operations
 - **Platform note**: Works smoothly on Android/Termux for mobile git management
 - **Clipboard**: Uses system clipboard when available, falls back to tmux buffer for SSH sessions without display
 - **Config Location**: On macOS, lazygit uses `~/Library/Application Support/lazygit/config.yml` by default. Use `lazygit --print-config-dir` to confirm the location. Set `XDG_CONFIG_HOME="$HOME/.config"` to use `~/.config/lazygit` instead.
 - **Custom Bindings**:
   - `Ctrl+G`: Open file diff in Delta with side-by-side, e-ink friendly view (files and commit files contexts)

### Tmux
A terminal multiplexer for managing multiple shell sessions and windows within a single terminal.
- **Appearance**: Customizable status bar with e-ink optimized grayscale theme, emoji status indicators
- **Behavior**: Session-based workflow allowing persistent terminal environments
- **Platform note**: Essential for maintaining development sessions on Termux
- **Key Bindings**:
  - **Pane Navigation**: `h/j/k` - Left/Down/Up (vim-style without prefix)
  - **Window Switching**: `Alt+0-9` or `Alt+Backtick` - Quick window navigation without prefix
  - **Floating Pane**: `Prefix + l` - Open popup window (50% height/width)
  - **Pane Splitting**: Standard tmux splits open in current directory
   - **Copy Mode**: `v` - Begin selection, `V` - Select line, `C-v` - Rectangle toggle, `y` - Copy
   - **Sync Panes**: `Prefix + Ctrl+s` - Toggle synchronized panes
   - **Save Session**: `Prefix + Shift+s` - Save tmux session (tmux-resurrect)
   - **Restore Session**: `Prefix + Shift+r` - Restore tmux session (tmux-resurrect)
    - **Vim-style navigation** in copy mode (set mode-keys vi)

### Tmux Powerline
A tmux plugin providing a customizable status bar with dynamic segments displaying system information, git status, and more.
- **Appearance**: Powerline-style status bar with configurable segments and colors
- **Behavior**: Dynamic status updates showing hostname, IP addresses, working directory, battery, date/time
- **Platform note**: Works on all platforms supported by tmux, with e-ink optimized color scheme
- **Segments**: Configurable left/right status bar segments (session info, hostname, LAN/WAN IP, pwd, battery, date/time)
- **Theme**: Custom theme with high-contrast colors optimized for readability
- **Configuration**: Managed via `dot-config/tmux-powerline/` with separate config and theme files

### Termux Environment
Android-specific terminal configuration with custom colors, fonts, and terminal properties.
- **Appearance**: High-contrast color scheme with Nerd Font support for icons
- **Behavior**: Optimized input/output handling for mobile devices
- **Fonts**: Consolas Nerd Font for proper glyph rendering

### Yazi File Manager
A terminal file manager with vi-like keybindings, image previews, and plugin support.
- **Appearance**: Clean, minimal interface with customizable layouts
- **Behavior**: Fast file navigation with built-in preview capabilities
- **Key Bindings**:
   - `h/j/k/l`: Navigate (vim-style)
   - `enter`: Open files in `$EDITOR` (text files) or default opener
   - `e`: Explicitly edit files in `$EDITOR`

### OpenCode
An AI-powered coding agent for the terminal. Provides intelligent code assistance with custom commands and automation.
- **Appearance**: Interactive TUI with session management
- **Behavior**: Execute custom commands to send predefined prompts to LLM
- **Custom Commands**: Define reusable prompts as Markdown files or JSON config
- **See**: [dot-config/opencode/README.md](dot-config/opencode/README.md) for detailed configuration guide

## Dependencies

### Core Tools
- **Helix**: `helix` - Modern text editor with LSP support
- **Lazygit**: `lazygit` - Terminal UI for git
- **Tmux**: `tmux` - Terminal multiplexer
- **Yazi**: `yazi` - Terminal file manager with image previews
- **Delta**: `delta` - Syntax-highlighting pager for git diffs (used in lazygit custom commands)

### Tmux Plugins (auto-installed via TPM)
- **tpm**: Tmux plugin manager (bootstrap required)
- **tmux-fzf**: Fuzzy finder integration for tmux
- **tmux-resurrect**: Session persistence
- **tmux-continuum**: Automatic session saving/restoring
- **tmux-powerline**: Customizable status bar with dynamic segments

### Android/Termux Specific
- **Termux**: Terminal emulator app
- **Nerd Font**: For proper icon rendering (Consolas Nerd Font included)

### Installation Commands

**Linux/macOS (Homebrew):**
```bash
brew install helix lazygit tmux yazi delta
```

**Linux/macOS/Windows (Conda):**
```bash
conda install -c conda-forge helix lazygit tmux yazi git-delta
```

**Termux (Android):**
```bash
pkg install helix lazygit tmux yazi git
pip install delta
```

## XDG Directory Structure

This project follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html):

- **`$XDG_CONFIG_HOME` (~/.config)**: Application configuration files
- **`$XDG_DATA_HOME` (~/.local/share)**: Application data and plugins
- All configs are designed to be kept in `~/.config/xdgg/` with symlinks to their standard XDG locations

## Installation

1. Backup your current configs if you have them:

    ```bash
    mv ~/.config/helix ~/.config/helix.backup 2>/dev/null || true
    mv ~/.config/lazygit ~/.config/lazygit.backup 2>/dev/null || true
    mv ~/.config/tmux ~/.config/tmux.backup 2>/dev/null || true
    mv ~/.config/yazi ~/.config/yazi.backup 2>/dev/null || true
    ```

2. Clone this repository:

   ```bash
   git clone git@github.com:lamnguyenx/xdgg.git ~/.config/xdgg
   ```

3. Create symlinks for tool configs:

    ```bash
    ln -s ~/.config/xdgg/dot-config/helix ~/.config/helix
    ln -s ~/.config/xdgg/dot-config/lazygit ~/.config/lazygit
    ln -s ~/.config/xdgg/dot-config/tmux ~/.config/tmux
    ln -s ~/.config/xdgg/dot-config/yazi ~/.config/yazi
    ```

    Or use the provided Makefile for automated setup:

    ```bash
    make helix lazygit tmux yazi  # Install specific configs
    make all                      # Install all configs including tmux-powerline
    ```

4. Setup Tmux Plugin Manager (TPM):

   ```bash
   mkdir -p ~/.local/share/tmux/plugins
   git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm
   ```

5. Install Tmux plugins:

   ```bash
   ~/.local/share/tmux/plugins/tpm/bin/install_plugins
   ```
   Or start tmux and press `Prefix + I` to install plugins interactively.

    **Note:** TPM automatically clones all plugins listed in `tmux.conf` (marked with `set -g @plugin`) into `~/.local/share/tmux/plugins/`. No manual cloning needed—TPM handles it all.

6. Setup Yazi (optional, for enhanced file management):

    ```bash
    # Create symlink for Yazi config
    ln -s ~/.config/xdgg/dot-config/yazi ~/.config/yazi
    ```

7. Setup Termux (if on Android):

   ```bash
   ln -s ~/.config/xdgg/dot-termux/termux.properties ~/.termux/termux.properties
   ln -s ~/.config/xdgg/dot-termux/colors.properties ~/.termux/colors.properties
   ln -s ~/.config/xdgg/dot-termux/ConsolasNerdFont-Regular.ttf ~/.termux/font.ttf
