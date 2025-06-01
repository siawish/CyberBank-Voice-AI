#!/bin/bash

# Check if Python virtual environment exists and activate it
if [ -d ~/myenv ]; then
    source ~/myenv/bin/activate
fi

# Check if required Python packages are installed
pip3 install gtts &>/dev/null

# Make voice_utils.sh executable
chmod +x ./voice_utils.sh

# Make main banking script executable
chmod +x ./test1.sh

# Launch the banking system
bash ./test1.sh

# Deactivate the virtual environment if it was activated
if [ -d ~/myenv ]; then
    deactivate
fi
