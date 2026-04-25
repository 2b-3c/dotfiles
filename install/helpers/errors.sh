QR_CODE='
█▀▀▀▀▀█ ██▀▀ █▄  ▄ █▀▀▀▀▀█
█ ███ █ ▄▄▀▄▀  ▀▀▀ █ ███ █
█ ▀▀▀ █ █ ▄ █▄▀▄▀▄ █ ▀▀▀ █
▀▀▀▀▀▀▀ ▀ █ ▀ █ ▀ ▀▀▀▀▀▀▀
▀▄▀█▄▄▀▄▀▀▄ ▄  █  ▀ █▀▀██
█  ▀█ ▀  ▀▀▄▄ ▄▀ ▀▀▄▄▀██
▄▀█ █ ▀ ▄▄▄▀▄ ██▀▄▄█▄▀▄█
 ▀▄▄▄█▀█ █▄▄▄  ▀▄██▀▀▄▄█▀
▀ ▀ ▀ ▀ █▄ ▄▀▀▀ █▀▀▀█▄▀
█▀▀▀▀▀█ ▀▄  ▀▄█  █ ▀ █▄██
█ ███ █ █ █▄▀  ███▀█▄▀▀▄
█ ▀▀▀ █  █ ▀▀ █▄▄▄ ▄▄█ █
▀▀▀▀▀▀▀ ▀ ▀▀▀  ▀ ▀▀▀▀▀▀'

ONYX_ERROR_HANDLING=false

# ── Show tail of log (formatted) ─────────────────────────────────
show_log_tail() {
  if [[ -f $ONYX_LOG_FILE ]]; then
    local log_lines=$(( TERM_HEIGHT - LOGO_HEIGHT - 35 ))
    (( log_lines < 5 )) && log_lines=5
    local max_line_width=$(( LOGO_WIDTH - 4 ))

    tail -n $log_lines "$ONYX_LOG_FILE" | while IFS= read -r line; do
      if (( ${#line} > max_line_width )); then
        line="${line:0:$max_line_width}..."
      fi
      gum style --foreground 8 "${PADDING_LEFT_SPACES}  → $line"
    done
    echo
  fi
}

# ── Show failed script or inline command ─────────────────────────
show_failed_source() {
  if [[ -n ${CURRENT_SCRIPT:-} ]]; then
    gum style --padding "0 0 0 $PADDING_LEFT" "  Failed script: $CURRENT_SCRIPT"
  else
    local cmd="$BASH_COMMAND"
    local max_cmd_width=$(( LOGO_WIDTH - 4 ))
    (( ${#cmd} > max_cmd_width )) && cmd="${cmd:0:$max_cmd_width}..."
    gum style --padding "0 0 0 $PADDING_LEFT" "  Failed command: $cmd"
  fi
}

# ── Main error handler ────────────────────────────────────────────
catch_error() {
  [[ $ONYX_ERROR_HANDLING == "true" ]] && return
  ONYX_ERROR_HANDLING=true

  local exit_code=$?
  show_cursor

  clear_logo
  gum style --foreground 1 --padding "1 0 1 $PADDING_LEFT" "  ONYX installation stopped!"

  show_log_tail
  gum style --padding "0 0 0 $PADDING_LEFT" \
    "  This command halted with exit code $exit_code:"
  show_failed_source

  gum style --padding "1 0 0 $PADDING_LEFT" "$QR_CODE"
  echo
  gum style --padding "0 0 1 $PADDING_LEFT" \
    "  Scan the QR code or visit: https://github.com/your-repo/onyx/issues"

  while true; do
    local choice
    choice=$(gum choose \
      "View full log" \
      "Exit" \
      --header "  What would you like to do?" \
      --padding "1 0 1 $PADDING_LEFT")

    case "$choice" in
      "View full log")
        if command -v less &>/dev/null; then
          less "$ONYX_LOG_FILE"
        else
          tail -50 "$ONYX_LOG_FILE"
        fi
        ;;
      "Exit"|"")
        exit 1
        ;;
    esac
  done
}

exit_handler() {
  local exit_code=$?
  if (( exit_code != 0 )) && [[ $ONYX_ERROR_HANDLING != "true" ]]; then
    catch_error
  else
    show_cursor
  fi
}

trap catch_error  ERR INT TERM
trap exit_handler EXIT
