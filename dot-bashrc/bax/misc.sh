#!/bin/bash
# --------------------------------------------------------------
#                          miscs
# --------------------------------------------------------------

function print_proxy() {

    local parent_func="${FUNCNAME[1]:-<shell>}"

    echo "+---------------------+"
    echo "| > called by         |" "$parent_func"
    echo "| http_proxy          |" "${http_proxy:-"<<unset>>"}"
    echo "| HTTP_PROXY          |" "${HTTP_PROXY:-"<<unset>>"}"
    echo "| https_proxy         |" "${https_proxy:-"<<unset>>"}"
    echo "| HTTPS_PROXY         |" "${HTTPS_PROXY:-"<<unset>>"}"
    echo "| socks_proxy         |" "${socks_proxy:-"<<unset>>"}"
    echo "| SOCKS_PROXY         |" "${SOCKS_PROXY:-"<<unset>>"}"
    echo "| REQUESTS_CA_BUNDLE  |" "${REQUESTS_CA_BUNDLE:-"<<unset>>"}"
    echo "| NODE_EXTRA_CA_CERTS |" "${NODE_EXTRA_CA_CERTS:-"<<unset>>"}"
    echo "| NO_PROXY            |" "${NO_PROXY:-"<<unset>>"}"
    echo "+---------------------+"
}

function accept_all(){

    local IP=$1

    sudo iptables -I INPUT  -p tcp -s $IP -j ACCEPT
    sudo iptables -I OUTPUT -p tcp -d $IP -j ACCEPT
}

function list_swap(){
    find /proc -maxdepth 2 -path "/proc/[0-9]*/status" -readable -exec awk -v FS=":" '{process[$1]=$2;sub(/^[ \t]+/,"",process[$1]);} END {if(process["VmSwap"] && process["VmSwap"] != "0 kB") printf "%10s %-30s %20s\n",process["Pid"],process["Name"],process["VmSwap"]}' '{}' \; \
        | awk '{print $(NF-1),$0}' \
        | sort -h \
        | cut -d " " -f2-

}


function just_one_tensorboard() {

    local logdir="$1"
    local port=$2

    pgrep -U $USER -f "tensorboard.*$port" | xargs kill
    setsid nohup \
        tensorboard \
            --host 0.0.0.0 \
            --logdir "$logdir" \
            --port $port \
        &>> ~/$port.log &

    tail -f ~/$port.log
}


function rename_easy() {
    local input_dir="$1"
    local source_string="$2"
    local target_string="$3"

    # Validate inputs
    if [ $# -ne 3 ]; then
        echo "Usage: rename_easy <input_dir> <source_string> <target_string>"
        return 1
    fi

    if [ ! -d "$input_dir" ]; then
        echo "Error: Directory '$input_dir' does not exist"
        return 1
    fi

    if [ -z "$source_string" ]; then
        echo "Error: Source string cannot be empty"
        return 1
    fi

    echo "Starting rename operation..."
    echo "Input directory: $input_dir"
    echo "Source string: $source_string"
    echo "Target string: $target_string"
    echo "----------------------------------------"

    # Function to rename a single item
    rename_item() {
        local item="$1"
        local dirname=$(dirname "$item")
        local basename=$(basename "$item")

        # Check if basename contains source string
        if [[ "$basename" == *"$source_string"* ]]; then
            local new_basename="${basename//$source_string/$target_string}"
            local new_path="$dirname/$new_basename"

            log "src:" "$item"
            log "tgt:" "$new_path"
            mv "$item" "$new_path"
            if [ $? -eq 0 ]; then
                log_green "✓ OK"
            else
                log_red "✗ FAILED"
            fi
        fi
    }

    # Process files first (depth-first approach)
    # Find all files and sort by depth (deepest first)
    find "$input_dir" -type f -name "*$source_string*" | \
    awk '{print length($0), $0}' | sort -rn | cut -d' ' -f2- | \
    while IFS= read -r file; do
        [ -e "$file" ] && rename_item "$file"
    done

    # Process directories (deepest first to avoid path issues)
    find "$input_dir" -type d -name "*$source_string*" | \
    awk '{print length($0), $0}' | sort -rn | cut -d' ' -f2- | \
    while IFS= read -r dir; do
        [ -d "$dir" ] && rename_item "$dir"
    done

    # Finally, rename the input directory itself if it contains source string
    local input_dirname=$(dirname "$input_dir")
    local input_basename=$(basename "$input_dir")

    if [[ "$input_basename" == *"$source_string"* ]]; then
        local new_input_basename="${input_basename//$source_string/$target_string}"
        local new_input_dir="$input_dirname/$new_input_basename"

        log "src:" "$input_dir"
        log "tgt:" "$new_input_dir"
        mv "$input_dir" "$new_input_dir"
        if [ $? -eq 0 ]; then
            log_green "✓ OK"
        else
            log_red "✗ FAILED"
        fi
    fi

}


# --------------------------------------------------------------
#                            AI
# --------------------------------------------------------------
# bind '"\e[27;2;13~": "\n"'
alias ap="set_pp_proxy && amp"
alias cl="set_pp_proxy && claude --verbose"
export EDITOR="vim"

if command -v fzf > /dev/null 2>&1; then
    [ -n "$BASH_VERSION" ] && source <(fzf --bash)
    [ -n "$ZSH_VERSION" ] && source <(fzf --zsh)
fi

export EDITOR="hx"

alias ggx="cd /data/cheese/git/lamnguyenx"
alias gg5="cd /data/cheese/git/lamnt45"
alias tmux='tmux attach || tmux new'

if command -v afplay &>/dev/null; then
    alias noti="(afplay /System/Library/Sounds/Submarine.aiff &>/dev/null &)"
elif command -v paplay &>/dev/null; then
    alias noti="(paplay /usr/share/sounds/freedesktop/stereo/complete.oga &>/dev/null &)"
elif command -v aplay &>/dev/null; then
    alias noti="(aplay /usr/share/sounds/alsa/Front_Center.wav &>/dev/null &)"
fi