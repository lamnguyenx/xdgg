#!/bin/bash
# --------------------------------------------------------------
#                           args
# --------------------------------------------------------------
function parse_args() {
  local -a remaining_args=()

  # Process all arguments
  while [[ $# -gt 0 ]]; do
      case $1 in
          --dry)
              if [[ $2 =~ ^(true|false)$ ]]; then
                  # --dry true/false
                  dry="$2"
                  shift 2
              elif [[ $2 && ! $2 =~ ^-- ]]; then
                  # --dry followed by non-flag argument, treat as flag only
                  dry="true"
                  shift 1
              else
                  # --dry without value or followed by another flag
                  dry="true"
                  shift 1
              fi
              ;;
          --live)
              if [[ $2 =~ ^(true|false)$ ]]; then
                  # --live true/false
                  live="$2"
                  shift 2
              elif [[ $2 && ! $2 =~ ^-- ]]; then
                  # --live followed by non-flag argument, treat as flag only
                  live="true"
                  shift 1
              else
                  # --live without value or followed by another flag
                  live="true"
                  shift 1
              fi
              ;;
          --config)
              if [[ -z "$2" || "$2" =~ ^-- ]]; then
                  echo "Error: --config requires a filename" >&2
                  return 1
              fi
              local config_file="$2"
              if [[ -f "$config_file" ]]; then
                  source "$config_file"
              else
                  echo "Error: Config file '$config_file' not found" >&2
                  return 1
              fi
              shift 2
              ;;
          --help|-h)
              return 1  # This will trigger help display in main function
              ;;
          --*)
              echo "Error: Unknown option $1" >&2
              return 1
              ;;
          *)
              # Positional argument - save it
              remaining_args+=("$1")
              shift 1
              ;;
      esac
  done

  # Replace the original arguments with remaining ones
  set -- "${remaining_args[@]}"
  return 0
}