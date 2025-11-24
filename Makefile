.PHONY: help all helix tmux termux lazygit amp

help:
	@echo "Configuration Setup"
	@echo "=================="
	@echo ""
	@echo "Run 'make <amp|tmux|helix|termux|lazygit>' to install specific config"
	@echo "Or run 'make all' to install all configurations"
	@echo ""
	@echo "WARNING: Do NOT move this directory. All configs use symlinks that will break if this folder is relocated."
	@echo ""

all: helix tmux termux lazygit amp

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
	@ln -sf "$(shell pwd)/dot-config/amp" ~/.config/amp
	@bash ./local/echo_banner.sh "Amp"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/amp
