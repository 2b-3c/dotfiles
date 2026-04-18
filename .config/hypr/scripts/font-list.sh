#!/bin/bash
# List all available monospace fonts that can be used with font-set.sh
fc-list :spacing=100 -f "%{family[0]}\n" | grep -v -i -E 'emoji|signwriting' | sort -u
