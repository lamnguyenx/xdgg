#!/bin/bash
# --------------------------------------------------------------
#                         essentials
# --------------------------------------------------------------

function reload_voice_bashrc() {
    source /data/docker/hanoi_it/voice.bashrc.sh
}

function get_host_ip() {
    echo "${HOST_IP:-$(ipconfig getifaddr en0 || ipconfig getifaddr en1 || hostname -I | awk '{print $1}')}"
}

export HOST_IP=$(get_host_ip)
export USER=${USER:-"$(id -un)"}
export UID
export GID=$(id -g)
export PATH="$HOME/.local/bin:/data/docker/hanoi_it/bin:$PATH"
export MAVEN_MIRROR="http://${HOST_IP}:8888/repository/maven-public"