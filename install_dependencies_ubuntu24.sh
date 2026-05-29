#!/bin/bash

# Parse command line arguments.
SKIP_APT=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-apt)
            SKIP_APT=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--skip-apt]"
            exit 1
            ;;
    esac
done

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
if [ "$SKIP_APT" = true ]; then
    echo "Skipping apt-get install (--skip-apt)."
else
    sudo apt-get install -y \
        curl dpkg-dev git lsb-release openssh-server rsync sshpass tmux tmuxp
fi

# With the Python venv.
pip install pyyaml vcstool "setuptools<=81.0.0"

echo "Done."
