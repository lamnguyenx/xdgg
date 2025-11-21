.PHONY: all helix tmux termux

all: helix tmux termux

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
