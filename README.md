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
- **Custom Bindings**:
  - `D`: Open file diff in Delta with side-by-side, e-ink friendly view (files and commit files contexts)

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
  - **Vim-style navigation** in copy mode (set mode-keys vi)

### Termux Environment
Android-specific terminal configuration with custom colors, fonts, and terminal properties.
- **Appearance**: High-contrast color scheme with Nerd Font support for icons
- **Behavior**: Optimized input/output handling for mobile devices
- **Fonts**: Consolas Nerd Font for proper glyph rendering

## Dependencies

### Core Tools
- **Helix**: `helix` - Modern text editor with LSP support
- **Lazygit**: `lazygit` - Terminal UI for git
- **Tmux**: `tmux` - Terminal multiplexer
- **Delta**: `delta` - Syntax-highlighting pager for git diffs (used in lazygit custom commands)

### Tmux Plugins (auto-installed via TPM)
- **tpm**: Tmux plugin manager (bootstrap required)
- **tmux-fzf**: Fuzzy finder integration for tmux
- **tmux-resurrect**: Session persistence
- **tmux-continuum**: Automatic session saving/restoring

### Android/Termux Specific
- **Termux**: Terminal emulator app
- **Nerd Font**: For proper icon rendering (Consolas Nerd Font included)

### Installation Commands

**Linux/macOS:**
```bash
# Install main tools (example using Homebrew)
brew install helix lazygit tmux delta
```

**Termux (Android):**
```bash
pkg install helix lazygit tmux git
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

6. Setup Termux (if on Android):

   ```bash
   ln -s ~/.config/xdgg/dot-termux/termux.properties ~/.termux/termux.properties
   ln -s ~/.config/xdgg/dot-termux/colors.properties ~/.termux/colors.properties
   ln -s ~/.config/xdgg/dot-termux/ConsolasNerdFont-Regular.ttf ~/.termux/font.ttf
