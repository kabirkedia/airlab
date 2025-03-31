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
    docker-compose \
    rsync \
    date \
    nvidia-container-toolkit \
    docker-ce \
    docker-ce-cli \
    containerd.io

# Ensure Docker service is started and enabled
sudo systemctl enable --now docker

# Install pip dependencies
pip3 install --upgrade pip
pip3 install pyyaml python3-vcstool

echo "Installation complete!"
