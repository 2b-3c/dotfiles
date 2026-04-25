show_cursor() { printf "\033[?25h"; }

# ── Log lifecycle ─────────────────────────────────────────────────
start_install_log() {
  : > "$ONYX_LOG_FILE"
  chmod 666 "$ONYX_LOG_FILE"
  export ONYX_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')
  export ONYX_START_EPOCH=$(date +%s)
  echo "=== ONYX Install Started: $ONYX_START_TIME ===" >> "$ONYX_LOG_FILE"
}

stop_install_log() {
  show_cursor

  local end_time=$(date +%s)
  local duration=$(( end_time - ONYX_START_EPOCH ))
  local mins=$(( duration / 60 ))
  local secs=$(( duration % 60 ))

  export ONYX_INSTALL_DURATION="${mins}m ${secs}s"

  echo "" >> "$ONYX_LOG_FILE"
  echo "=== ONYX Install Finished: $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$ONYX_LOG_FILE"
  echo "=== Duration: ${ONYX_INSTALL_DURATION} ===" >> "$ONYX_LOG_FILE"
}

# ── run_logged — for scripts that do NOT have their own UI ────────
# (not used for packaging/config which manage their own gum output)
run_logged() {
  local script="$1"
  export CURRENT_SCRIPT="$script"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script" >> "$ONYX_LOG_FILE"

  bash -c "source '$script'" </dev/null >> "$ONYX_LOG_FILE" 2>&1

  local exit_code=$?

  if (( exit_code == 0 )); then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script" >> "$ONYX_LOG_FILE"
    unset CURRENT_SCRIPT
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)" >> "$ONYX_LOG_FILE"
  fi

  return $exit_code
}
