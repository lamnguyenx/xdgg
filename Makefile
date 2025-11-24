.PHONY: help all helix tmux termux lazygit amp opencode bax yazi clean

help:
	@echo "Configuration Setup"
	@echo "=================="
	@echo ""
	@echo "Run 'make <amp|opencode|tmux|helix|termux|lazygit|bax|yazi>' to install specific config"
	@echo "Or run 'make all' to install all configurations"
	@echo "Run 'make clean' to remove symlinks and create empty config directories"
	@echo ""
	@echo "WARNING: Do NOT move this directory. All configs use symlinks that will break if this folder is relocated."
	@echo ""

all: helix tmux termux lazygit amp opencode bax yazi

clean:
	@rm -f ~/.config/helix
	@mkdir -p ~/.config/helix
	@rm -f ~/.config/tmux
	@rm -f ~/.tmux.conf
	@mkdir -p ~/.config/tmux
	@rm -f ~/.config/lazygit
	@mkdir -p ~/.config/lazygit
	@rm -f ~/.config/yazi
	@mkdir -p ~/.config/yazi
	@echo "Cleaned symlinks and created empty config directories"

helix:
	@bash ./local/archive.sh ~/.config/helix
	@ln -sf "$(shell pwd)/dot-config/helix" ~/.config/helix
	@bash ./local/echo_banner.sh "Helix"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/helix

tmux:
	@bash ./local/archive.sh ~/.config/tmux
	@bash ./local/archive.sh ~/.tmux.conf
	@ln -sf "$(shell pwd)/dot-config/tmux" ~/.config/tmux
	@ln -sf "$(shell pwd)/dot-config/tmux/tmux.conf" ~/.tmux.conf
	@bash ./local/echo_banner.sh "Tmux"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/tmux ~/.tmux.conf
	@-tmux source-file ~/.tmux.conf 2>/dev/null || true

termux:
	@bash ./local/archive.sh ~/.termux
	@ln -sf "$(shell pwd)/dot-termux" ~/.termux
	@bash ./local/echo_banner.sh "Termux"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.termux

lazygit:
	@bash ./local/archive.sh ~/.config/lazygit
	@ln -sf "$(shell pwd)/dot-config/lazygit" ~/.config/lazygit
	@bash ./local/echo_banner.sh "Lazygit"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/lazygit

amp:
	@bash ./local/archive.sh ~/.config/amp
	@mkdir -p ~/.config/amp
	@ln -sf "$(shell pwd)/__submodules__/humanlayer2/.claude/commands" ~/.config/amp/commands
	@bash ./local/echo_banner.sh "Amp"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/amp

opencode:
	@bash ./local/archive.sh ~/.config/opencode/command
	@mkdir -p ~/.config/opencode
	@ln -sf "$(shell pwd)/__submodules__/humanlayer2/.claude/commands" ~/.config/opencode/command
	@bash ./local/echo_banner.sh "OpenCode"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/opencode/command

yazi:
	@bash ./local/archive.sh ~/.config/yazi
	@ln -sf "$(shell pwd)/dot-config/yazi" ~/.config/yazi
	@bash ./local/echo_banner.sh "Yazi"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/yazi

bax:
	@bash ./local/install_bax.sh
