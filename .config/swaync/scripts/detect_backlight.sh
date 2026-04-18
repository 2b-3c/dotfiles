#!/usr/bin/env bash
#
# Detects backlight device and updates swaync config automatically
#

SWAYNC_CONF="$HOME/.config/swaync/config.json"
BACKLIGHT_DIR="/sys/class/backlight"

# Find the best available device by priority
DEVICE=""
for preferred in intel_backlight amdgpu_bl0 amdgpu_bl1 nvidia_0 acpi_video0; do
    if [ -d "$BACKLIGHT_DIR/$preferred" ]; then
        DEVICE="$preferred"
        break
    fi
done

# If not found by priority, take the first available device
if [ -z "$DEVICE" ]; then
    DEVICE=$(ls "$BACKLIGHT_DIR" 2>/dev/null | head -1)
fi

# If no device found, remove backlight from swaync
if [ -z "$DEVICE" ]; then
    python3 -c "
import json
with open('$SWAYNC_CONF') as f:
    c = json.load(f)
c['widgets'] = [w for w in c['widgets'] if w not in ('backlight', 'backlight/slider')]
for k in ('backlight', 'backlight/slider'):
    c['widget-config'].pop(k, None)
with open('$SWAYNC_CONF', 'w') as f:
    json.dump(c, f, indent=2)
" 2>/dev/null
    exit 0
fi

# Update config with the correct device
python3 -c "
import json
with open('$SWAYNC_CONF') as f:
    c = json.load(f)

# Add backlight after volume if not already present
for widget in ['backlight']:
    if widget not in c['widgets']:
        idx = c['widgets'].index('volume') if 'volume' in c['widgets'] else 0
        c['widgets'].insert(idx + 1, widget)

# Configure the widget
c['widget-config']['backlight'] = {
    'label': '󰃠',
    'device': '$DEVICE'
}

with open('$SWAYNC_CONF', 'w') as f:
    json.dump(c, f, indent=2)
print('backlight device:', '$DEVICE')
" 2>/dev/null
