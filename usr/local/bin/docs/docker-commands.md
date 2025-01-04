# Docker Command Documentation

This document provides detailed information about the Docker-related commands available in the Airlab toolkit.

## Table of Contents
- [docker-build](#docker-build)
- [docker-list](#docker-list)
- [docker-join](#docker-join)
- [docker-up](#docker-up)

## docker-build

### Description
Builds Docker images from a specified Docker Compose file, either locally or on a remote system.

### Usage
```bash
airlab docker-build [--system=<system_name>] [--compose=<compose_file>]
```

### Options
- `--system=<system_name>`: (Optional) Specifies the target system name for remote operations
- `--compose=<compose_file>`: (Optional) Specifies the Docker Compose file (defaults to $DOCKER_BUILD_PATH). \
**Path should be relative to $AIRLAB_PATH.**
- `--help`: Displays help information

### Examples
```bash
airlab docker-build
airlab docker-build --compose=docker-compose-orin.yml
airlab docker-build --system=robot1
airlab docker-build --system=robot1 --compose=docker-compose-orin.yml
```

### Features
- Supports both local and remote build operations
- Automatically handles SSH authentication for remote systems
- Validates configuration files before attempting operations
- Provides colored output for better visibility
- Checks for required dependencies before execution

## docker-list

### Description
Lists Docker containers or images, either on the local system or a remote system.

### Usage
```bash
airlab docker-list [--system=<system_name>] [--images]
```

### Options
- `--system=<system_name>`: (Optional) Specifies the target system for remote operations
- `--images`: (Optional) Lists Docker images instead of containers
- `--help`: Displays help information

### Examples
```bash
airlab docker-list
airlab docker-list --images
airlab docker-list --system=robot1 --images
```

### Features
- Lists either containers (default) or images
- Supports both local and remote systems
- Provides formatted output for easy reading
- Includes error handling for connection issues

## docker-join

### Description
Joins a running Docker container by launching an interactive bash shell, either locally or on a remote system.

### Usage
```bash
airlab docker-join [--system=<system_name>] [--name=<container_name>]
```

### Options
- `--system=<system_name>`: (Optional) Specifies the target system for remote operations
- `--name=<container_name>`: Specifies the container to join
- `--help`: Displays help information

### Examples
```bash
airlab docker-join
airlab docker-join --name=testcontainer
airlab docker-join --system=robot1 --name=testcontainer
```

### Features
- Verifies container status before attempting to join
- Supports both local and remote containers
- Provides interactive bash shell access
- Includes robust error handling

## docker-up

### Description
Starts containers using Docker Compose, either locally or on a remote system.

### Usage
```bash
airlab docker-up [--system=<system_name>] [--compose=<compose_file>]
```

### Options
- `--system=<system_name>`: (Optional) Specifies the target system for remote operations
- `--compose=<compose_file>`: (Optional) Specifies the Docker Compose file (defaults to $DOCKER_UP_PATH)
- `--help`: Displays help information

### Examples
```bash
airlab docker-up
airlab docker-up --compose=docker-compose-orin.yml
airlab docker-up --system=robot1 --compose=docker-compose-orin.yml
**Path should be relative to $AIRLAB_PATH.**
```

### Features
- Supports both local and remote deployment
- Validates compose file existence before execution
- Sources ~/.bashrc for proper environment setup on remote systems
- Includes comprehensive error handling

## Common Features Across All Commands

### Error Handling
- All commands implement robust error handling
- Clear error messages with color-coded output
- Proper exit codes for script integration

### Dependencies
All commands require the following dependencies:
- docker
- docker-compose
- ssh
- sshpass

### Configuration Files
Commands that interact with remote systems require:
- `robot.conf`: Contains system SSH addresses
- `robot_info.yaml`: Contains workspace path information
- `airlab.env`: Contains enviornment variable DOCKER_BUILD_PATH and DOCKER_UP_PATH

### Security
- Secure password handling for remote operations
- SSH connection validation before operations
- Proper error handling for authentication failures