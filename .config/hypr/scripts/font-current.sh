#!/bin/bash
# Returns the current monospace font being used (reads from waybar style.css)
grep -oP "font-family:\s*[\"']?\K[^;\"']+" ~/.config/waybar/style.css | head -n1
