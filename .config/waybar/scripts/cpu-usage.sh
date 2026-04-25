#!/usr/bin/env bash

# Get CPU model (removed "(R)", "(TM)", and clock speed)
# Use 'exit' after first match — faster than head -n1
model=$(awk -F ': ' '/model name/{print $2; exit}' /proc/cpuinfo | sed 's/@.*//; s/ *\((R)\|(TM)\)//g; s/^[ \t]*//; s/[ \t]*$//')

# Get CPU usage via /proc/stat — no blocking 1-second wait unlike vmstat
read_cpu() { awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5}' /proc/stat; }
line1=$(read_cpu); sleep 0.2; line2=$(read_cpu)
total1=$(echo "$line1" | awk '{print $1}'); idle1=$(echo "$line1" | awk '{print $2}')
total2=$(echo "$line2" | awk '{print $1}'); idle2=$(echo "$line2" | awk '{print $2}')
load=$(awk "BEGIN {dt=$total2-$total1; di=$idle2-$idle1; printf \"%d\", (dt>0)?(100*(dt-di)/dt):0}")

# Determine CPU state based on usage
if [ "$load" -ge 80 ]; then
  state="Critical"
elif [ "$load" -ge 60 ]; then
  state="High"
elif [ "$load" -ge 25 ]; then
  state="Moderate"
else
  state="Low"
fi

# Set color based on CPU load
if [ "$load" -ge 80 ]; then
  # If CPU usage is >= 80%, set color to #f38ba8
  text_output="<span color='#f38ba8'>󰀩 ${load}%</span>"
else
  # Default color
  text_output="󰻠 ${load}%"
fi

tooltip="${model}"
tooltip+="\nCPU Usage: ${state}"

# Module and tooltip
echo "{\"text\": \"$text_output\", \"tooltip\": \"$tooltip\"}"
