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
