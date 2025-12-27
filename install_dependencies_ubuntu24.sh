#!/bin/bash

# Check if running under a Python virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Error: This script must be run from within a Python virtual environment."
    echo "Please activate a virtual environment first:"
    echo "  python3 -m venv /path/to/venv"
    echo "  source /path/to/venv/bin/activate"
    exit 1
fi

# Print virtual environment information
echo "Virtual environment detected:"
echo "  Name: $(basename "$VIRTUAL_ENV")"
echo "  Location: $VIRTUAL_ENV"
echo ""

# Install Ubuntu dependencies.
sudo apt-get install -y \
    curl dpkg-dev git lsb-release openssh-server rsync sshpass tmux tmuxp

# With the Python venv.
pip install pyyaml vcstool

echo "Done."
