# AGENTS.md - Guidelines for Agentic Coding Agents

For general project overview, tools, dependencies, and installation instructions, see [README.md](README.md).

## Build/Lint/Test Commands
This is a dotfiles configuration repository, not a software project. No build/lint/test commands exist.
- Use `make <tool>` to setup symlinks (helix, tmux, termux, lazygit)
- Shell scripts use `set -Eeuo pipefail` for strict error handling

## Configuration Management
- After editing `tmux.conf`, run `tmux source-file ~/.tmux.conf` to apply changes immediately without restarting tmux

## Code Style Guidelines

### Shell Scripts (Bash)
- Use `set -Eeuo pipefail` at script start for error handling
- Use descriptive variable names in UPPER_CASE
- Quote all variable expansions: `"$VAR"`
- Use `sed "s|$HOME|~|g"` for path display formatting
- Functions: lowercase with underscores: `function_name()`

### Configuration Files
- **TOML**: 2-space indentation, descriptive comments, consistent key ordering
- **YAML**: 2-space indentation, minimal comments
- **Tmux conf**: Group related settings, use descriptive comments for sections

### Naming Conventions
- Config directories: `dot-config/`, `dot-termux/`
- Scripts: lowercase with underscores (`archive.sh`, `echo_banner.sh`)
- Theme files: abbreviated names (`hcl.toml`, `hcd.toml`)

### General
- Comments: Brief and descriptive, avoid redundancy
- No type annotations (config files)
- Follow XDG Base Directory specification
- E-ink friendly themes with high contrast