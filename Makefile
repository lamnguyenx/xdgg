.PHONY: help all helix tmux termux lazygit amp opencode bax yazi tmux-powerline firefox clean

help:
	@echo "Configuration Setup"
	@echo "=================="
	@echo ""
	@echo "Run 'make <amp|opencode|tmux|helix|termux|lazygit|bax|yazi|tmux-powerline|firefox>' to install specific config"
	@echo "Or run 'make all' to install all configurations"
	@echo "Run 'make clean' to remove symlinks and create empty config directories"
	@echo ""
	@echo "WARNING: Do NOT move this directory. All configs use symlinks that will break if this folder is relocated."
	@echo ""

all: helix tmux termux lazygit amp opencode bax yazi tmux-powerline firefox

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
	@rm -f ~/.config/tmux-powerline
	@mkdir -p ~/.config/tmux-powerline
	@echo "Cleaned symlinks and created empty config directories"

helix:
	@bash ./bach_lite.sh archive ~/.config/helix
	@ln -sf "$(shell pwd)/dot-config/helix" ~/.config/helix
	@bash ./bach_lite.sh echo_banner "Helix"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/helix

tmux:
	@bash ./bach_lite.sh archive ~/.config/tmux
	@bash ./bach_lite.sh archive ~/.tmux.conf
	@ln -sf "$(shell pwd)/dot-config/tmux" ~/.config/tmux
	@ln -sf "$(shell pwd)/dot-config/tmux/tmux.conf" ~/.tmux.conf
	@bash ./bach_lite.sh echo_banner "Tmux"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/tmux ~/.tmux.conf
	@-tmux source-file ~/.tmux.conf 2>/dev/null || true

termux:
	@bash ./bach_lite.sh archive ~/.termux
	@ln -sf "$(shell pwd)/dot-termux" ~/.termux
	@bash ./bach_lite.sh echo_banner "Termux"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.termux

lazygit:
	@mkdir -p "$(shell lazygit --print-config-dir)"
	@ln -sf "$(shell pwd)/dot-config/lazygit/config.yml" "$(shell lazygit --print-config-dir)/config.yml"
	@bash ./bach_lite.sh echo_banner "Lazygit"
	@echo "Symlinks:"
	@ls -la "$(shell lazygit --print-config-dir)/config.yml"

amp:
	@bash ./bach_lite.sh archive ~/.config/amp
	@mkdir -p ~/.config/amp
	@ln -sf "$(shell pwd)/__submodules__/humanlayer2/.claude/commands" ~/.config/amp/commands
	@bash ./bach_lite.sh echo_banner "Amp"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/amp

yazi:
	@bash ./bach_lite.sh archive ~/.config/yazi
	@ln -sf "$(shell pwd)/dot-config/yazi" ~/.config/yazi
	@bash ./bach_lite.sh echo_banner "Yazi"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/yazi

tmux-powerline:
	@bash ./bach_lite.sh archive ~/.config/tmux-powerline
	@ln -sf "$(shell pwd)/dot-config/tmux-powerline" ~/.config/tmux-powerline
	@bash ./bach_lite.sh echo_banner "Tmux Powerline"
	@echo "Symlinks:"
	@bash ./local/show_symlinks.sh ~/.config/tmux-powerline

firefox:
	@./local/install_firefox_custom_css.sh

