# Start sudo keepalive so we don't get prompted mid-install
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
export SUDO_KEEPALIVE_PID=$!
