#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Update package lists
sudo apt update

# Install apt dependencies
sudo apt install -y \
    tmux \
    tmuxp \
    python3-pip \
    openssh-server \
    sshpass \
    ssh-askpass \
    git \
    rsync \

# Install pip dependencies
pip3 install --upgrade pip
sudo pip3 install pyyaml vcstool

echo "Installation complete!"
