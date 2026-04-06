#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Parse command line arguments.
VENV_MODE=""  # "", "override", "no-override", or "skip"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --override-venv)
            VENV_MODE="override"
            shift
            ;;
        --no-override-venv)
            VENV_MODE="no-override"
            shift
            ;;
        --skip-venv)
            VENV_MODE="skip"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--override-venv | --no-override-venv | --skip-venv]"
            exit 1
            ;;
    esac
done

# Get the directory of the current script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Update package lists
sudo apt update

# Install apt dependencies
sudo apt install -y \
    python3-pip \
    python3-venv

# Handle venv setup.
VENV_DIR="$HOME/VENVs"
VENV_ACTION=""  # "create", "reuse", or "skip"

if [ "$VENV_MODE" = "skip" ]; then
    # Expect the user to already be in a venv.
    if [ -z "$VIRTUAL_ENV" ]; then
        echo "Error: --skip-venv requires an active virtual environment, but none is detected."
        exit 1
    fi
    echo "Using current virtual environment: $VIRTUAL_ENV"
    VENV_ACTION="skip"
else
    mkdir -p "$VENV_DIR"

    # Test if the virtual environment already exists.
    if [ -d "$VENV_DIR/airlab" ]; then
        if [ "$VENV_MODE" = "override" ]; then
            echo "Removing existing virtual environment 'airlab'..."
            rm -rf "$VENV_DIR/airlab"
            VENV_ACTION="create"
        elif [ "$VENV_MODE" = "no-override" ]; then
            echo "Error: Virtual environment 'airlab' already exists."
            exit 1
        else
            # Interactive prompt.
            echo "Virtual environment 'airlab' already exists at $VENV_DIR/airlab."
            read -rp "Remove and re-create it? [y/N] " answer
            case "$answer" in
                [yY]|[yY][eE][sS])
                    echo "Removing existing virtual environment 'airlab'..."
                    rm -rf "$VENV_DIR/airlab"
                    VENV_ACTION="create"
                    ;;
                *)
                    echo "Keeping existing virtual environment. Skipping venv setup."
                    VENV_ACTION="reuse"
                    ;;
            esac
        fi
    else
        VENV_ACTION="create"
    fi

    if [ "$VENV_ACTION" = "create" ]; then
        python3 -m venv "$VENV_DIR/airlab"
        source "$VENV_DIR/airlab/bin/activate"
        pip install --upgrade pip
        pip install ipython ipdb
        # Only add to .bashrc if not already present.
        if ! grep -q 'source ~/VENVs/airlab/bin/activate' ~/.bashrc; then
            echo 'source ~/VENVs/airlab/bin/activate' >> ~/.bashrc
        fi
    elif [ "$VENV_ACTION" = "reuse" ]; then
        # Activate the existing venv so install_dependencies_ubuntu24.sh sees $VIRTUAL_ENV.
        source "$VENV_DIR/airlab/bin/activate"
    fi
fi

# Go back to the script directory and run the Ubuntu 24 dependencies installation script.
cd "$SCRIPT_DIR"
bash install_dependencies_ubuntu24.sh

# Create the DEB package.
cd "$SCRIPT_DIR"/..
dpkg-deb --build airlab

# Install the DEB package.
sudo dpkg -i airlab.deb

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${GREEN}========================================${RESET}"
echo -e "${GREEN}    Installation complete!${RESET}"
echo -e "${GREEN}========================================${RESET}"
echo ""
if [ "$VENV_ACTION" = "skip" ]; then
    echo -e "${YELLOW}${BOLD}>>> AirLab was installed using your current venv:${RESET}"
    echo ""
    echo -e "    ${BOLD}$VIRTUAL_ENV${RESET}"
    echo ""
    echo -e "${YELLOW}${BOLD}>>> Make sure this venv is active when using AirLab.${RESET}"
else
    echo -e "${YELLOW}${BOLD}>>> To start using AirLab, open a new terminal or run:${RESET}"
    echo ""
    echo -e "    ${BOLD}source ~/VENVs/airlab/bin/activate${RESET}"
fi
echo ""
echo -e "${GREEN}========================================${RESET}"
