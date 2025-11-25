#!/bin/bash
# --------------------------------------------------------------
#                         aliases
# --------------------------------------------------------------
# Common shell aliases for productivity

# Enable color support for ls and add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias oc="opencode"
alias occ="opencode --continue"

alias a="amp"
alias ac="amp threads continue"

alias lg="lazygit"
alias gu="gituit"

alias tb="SHELL=/bin/bash tmux"

# Check if running in VS Code terminal and set editor accordingly
if [ "$TERM_PROGRAM" = "vscode" ]; then
    export EDITOR="code --wait"
fi

# ===================================
#            PROJECTS
# ===================================

if [[ -f .project.sh ]]; then
    source .project.sh
fi

if [[ -f .project-untracked.sh ]]; then
    source .project-untracked.sh
fi
