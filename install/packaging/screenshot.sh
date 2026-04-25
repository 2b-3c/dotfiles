step "Step 10 — Screenshot & screen recording"

_install "Screenshot tools" \
  grim slurp hyprpicker satty

_install "Screen recorder" \
  gpu-screen-recorder v4l-utils v4l2loopback-dkms linux-headers

_install "Video processing" \
  ffmpeg ffplay
