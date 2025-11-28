#!/bin/bash

echo "CPU Temperature Monitoring:"
if command -v sensors &> /dev/null; then
     sensors | grep -i 'temp'  # Adjust based on your system's output
else
     echo "Please install 'lm-sensors' to monitor CPU temperature."
fi
