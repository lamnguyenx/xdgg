#!/bin/bash
# --------------------------------------------------------------
#                           proxy
# --------------------------------------------------------------

function urlencode() {
  local string="$1"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"
}

function unset_proxy() {

    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset socks_proxy
    unset SOCKS_PROXY
    unset REQUESTS_CA_BUNDLE
    unset NODE_EXTRA_CA_CERTS
    unset NO_PROXY
}

function remove_proxy() { unset_proxy; }




function set_legacy_proxy() {
    unset_proxy
    # legacy proxy, used to install pip, conda packages
    # more restricted that s5 proxy, but might useful on CI/CD servers
    export http{,s}_proxy="http://$(get_host_ip):7126"
    export HTTP{,S}_PROXY="http://$(get_host_ip):7126"
    export NO_PROXY="localhost,127.0.0.1,0.0.0.0,.local,.internal,.sslip.io"

    print_proxy
}

