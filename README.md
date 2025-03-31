
# Airlab: Simplified Deployment for Robotic Systems


`airlab` is a command-line tool designed to streamline and simplify deployment workflows for robotic systems, both locally and remotely.  It unifies common tasks such as file synchronization, launch file management, and environment configuration by integrating industry-standard tools like `rsync`, `docker`, and `tmux` under a single, consistent interface.  This reduces complexity and accelerates development and deployment cycles, making `airlab` an invaluable asset for robotics engineers and developers.

## Table of Contents

*   [Key Features](#key-features)
*   [Installation](#installation)
*   [Commands](#commands)
    *   [Setup](#setup)
    *   [SSH](#ssh)
    *   [set_env](#set_env)
    *   [Sync](#sync)
    *   [Launch](#launch)
    *   [Docker Commands](#docker-commands)
    *   [Version Control Commands](#vcs-commands)
*   [Workspace Structure](#workspace-structure)
    *   [Overview](#overview-1)
    *   [Directory Structure](#directory-structure)
    *   [Folder Breakdown](#folder-breakdown)
*   [Future Work](#future-work)
*   [Contributing](#contributing)
*   [License](#license)
*   [Index](#index)


## Key Features

*   **File Synchronization:**  Provides an easy and efficient method for transferring files between local and remote systems.
*   **Launch Management:** Simplifies the process of launching and managing robotic system launch files, especially using `tmux` sessions.
*   **Environment Setup:** Automates the configuration of necessary environments on remote systems.
*   **Unified Interface:** Consolidates various tools and processes into a single command-line utility.
*   **Debian Package:**  Offers a simple and reliable installation and update mechanism via a Debian package.

## Installation

`airlab` is intended to be installed on the host machine from which you control remote robotic systems. Remote systems are then configured using the `setup` command.

### Prerequisites

1.  **Docker Engine:**  Install Docker Engine using the [official Docker documentation](https://docs.docker.com/engine/install/ubuntu/#installation-methods).

2.  **NVIDIA Container Toolkit:** Install the NVIDIA Container Toolkit according to the [official NVIDIA documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html). This also requires the CUDA Toolkit and NVIDIA Driver, which can be found [here](https://developer.nvidia.com/cuda-downloads).

3.  **Other Dependencies:** Install the following dependencies using `apt`:

    ```bash
    sudo apt-get update
    sudo apt-get install -y curl dpkg-dev git lsb-release openssh-server python3-pip rsync sshpass tmux tmuxp
    ```

    Alternatively, run the included `install.sh` script.

### Installation Steps

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/kabirkedia/airlab
    cd airlab
    ```

2.  **Set File Permissions:**  Ensure all files are executable:

    ```bash
    chmod -R a+rX *
    ```

    *Note:*  The goal is to grant execute permissions to all files within the `airlab` directory. Alternative methods to achieve this are acceptable.

3.  **Build the Debian Package:**

    ```bash
    cd ..
    dpkg-deb --build airlab
    ```

4.  **Install `airlab`:**

    ```bash
    sudo dpkg -i airlab.deb
    ```

5.  **(Optional) Install Missing Dependencies:** This command can attempt to fix broken installations by installing missing dependencies. While it can be helpful, it's generally more reliable to ensure all prerequisites are installed beforehand.

    ```bash
    sudo apt install -f -y
    ```

### Post-Installation Notes
After installing airlab you can run the command to setup the environment `airlab setup local or <robot>`

## Commands

Once installed, the `airlab` command provides access to a suite of tools for managing your robotic systems.  The `setup` command is particularly crucial, as it initializes the environment before any other commands are used.

---
### Setup

This command configures either the local environment or a remote robot system.

#### Usage

```bash
airlab setup local [--path=<install_path>] [--force]

airlab setup <robot_name> [--path=<install_path>] [--force]
```

#### Options

*   `--path`: Installation directory (default: `~/airlab_ws`)
*   `--force`: Overwrite an existing installation.
*   `<robot_name>`: Robot identifier, as defined in `robot.conf`.

#### Configuration Files

*   Robot config: `robot.conf` in the workspace's `robot` folder.
*   Environment: `airlab.env` (created during setup).
*   Bash config: Updates to `.bashrc`.

#### Quick Examples

```bash
# Local setup
airlab setup local --path=/opt/airlab_ws
airlab setup local --force

# Remote setup
airlab setup robot1 --path=/home/airlab/ws
airlab setup robot1 --force
```

#### Setup Process

##### Local

1.  Creates the necessary directory structure.
2.  Copies configuration files.
3.  Sets environment variables.
4.  Updates `.bashrc`.
5.  Creates `airlab.env`.

##### Remote

1.  Establishes an SSH connection.
2.  Performs environment setup.
3.  Copies necessary files.
4.  Installs required packages.
5.  Updates `.bashrc`.
6.  Configures `/etc/hosts`.

##### Robot Configuration

In `robot.conf`:

```bash
robot1=airlab@192.45.34.1
robot2=airlab@192.45.34.2
```

#### Common Issues

1.  "Permission denied": Check permissions on the installation path.
2.  "SSH connection failed": Verify entries in `robot.conf`.
3.  "Configuration exists": Use `--force` to overwrite.
4.  "Environment not set": Check `airlab.env` and `.bashrc`.

Detailed documentation is available [here](/usr/local/bin/docs/setup.md).

---

### SSH

This command establishes an SSH connection to a remote robot.

#### Usage

```bash
airlab ssh <robot_name> [options]
```

#### Options

*   `--help`: Show help message.

#### Configuration Files

*   Robot config: `$AIRLAB_PATH/robot/robot.conf`
*   Robot info: `$AIRLAB_PATH/robot/robot_info.yaml`

#### Quick Examples

```bash
airlab ssh mt001  # SSH into mt001, as defined in robot.conf
```

#### Dependencies

*   `ssh`
*   `sshpass`

#### Common Issues

1.  "SSH connection failed": Check network connectivity and credentials.
2.  "Workspace not found": Verify the `robot_info.yaml` configuration.

*Note: Further detailed documentation is omitted due to its relative simplicity.*

---

### Set_env

Sets environment variables for local or remote robot environments.

#### Usage

```bash
airlab set_env [ROBOT_NAME] [ENV_VARIABLE]
```

#### Arguments

*   `ROBOT_NAME`: Target system (`local` for the local environment).
*   `ENV_VARIABLE`: Environment variable and its value to set.

#### Options

*   `--help`, `-h`: Display help message.

#### Examples

```bash
# Set a local environment variable
airlab set_env local MY_VAR="hello"

# Set a remote robot environment variable
airlab set_env robot1 MY_VAR="hello"
```

#### Features

*   For local execution, updates the local `airlab.env` file.
*   For remote execution, updates both the remote `airlab.env` file and the configuration in `robot_info.yaml`.

*Note: Further detailed documentation is omitted due to its relative simplicity.*

---

### Sync

This command synchronizes files between the local machine and a remote robot.

#### Usage

```bash
airlab sync <robot_name> [options]
```

#### Options

*   `--dry-run`: Preview the synchronization without making changes.
*   `--delete`: Remove extra files on the remote system.
*   `--path=<relative_path>`: Synchronize a specific directory.
*   `--exclude=<pattern>`: Skip files matching the specified pattern.
*   `--time`: Synchronize system time.
*   `--help`: Show help message.

#### Configuration Files

*   Robot config: `$AIRLAB_PATH/robot/robot.conf`
*   Robot info: `$AIRLAB_PATH/robot/robot_info.yaml`

#### Quick Examples

```bash
# Basic sync
airlab sync mt001  # Sync all files
airlab sync mt001 --dry-run  # Preview changes
airlab sync mt001 --delete  # Remove extra files

# Advanced sync
airlab sync mt001 --path=src/config  # Sync specific path
airlab sync mt001 --exclude='*.log'  # Skip log files
```

#### Default Exclusions

*   `.git/`, `build/`, `devel/`, `log/`
*   `install/`, `*.pyc`, `__pycache__`
*   `*.env`

#### Dependencies

*   `rsync`
*   `ssh`
*   `sshpass`
*   `date`
*   `python3` (with PyYAML)

#### Common Issues

1.  "SSH connection failed": Check network connectivity and credentials.
2.  "Workspace not found": Verify the `robot_info.yaml` configuration.
3.  "Sync failed": Check file permissions and available disk space.
4.  "Time sync failed": Check `sudo` access on the remote system.

Detailed documentation is available [here](/usr/local/bin/docs/sync.md).

---

### Launch

This command launches applications or processes on a robot using `tmux`.

#### Usage

```bash
airlab launch <robot_name> [options]
```

#### Options

*   `<robot_name>`: Name of the robot (must be defined in `robot.conf`).
*   `--yaml_file=<file_name>`: Alternative launch file (relative to the workspace).
*   `--stop`: Stop the `tmux` session.
*   `--help`: Show help message.

#### Configuration Files

*   Launch files: Set by the `LAUNCH_FILE_PATH` environment variable.
*   Robot config: `$AIRLAB_PATH/robot/robot.conf`
*   Robot info: `$AIRLAB_PATH/robot/robot_info.yaml`

#### Quick Examples

```bash
# Local operations
airlab launch local  # Launch locally
airlab launch local --stop  # Stop local session

# Remote operations
airlab launch mt001  # Launch on mt001
airlab launch mt001 --stop  # Stop on mt001
airlab launch mt001 --yaml_file=mt002.yaml  # Launch specific yaml
```

#### Dependencies

*   `tmuxp`
*   `ssh`
*   `python3` (with PyYAML)
*   `sshpass` (for remote operations)

#### Common Issues

1.  "YAML file not found": Check the `LAUNCH_FILE_PATH` environment variable.
2.  "System not found": Verify the robot name in `robot.conf`.
3.  "Cannot connect": Check network and SSH credentials.
4.  "Failed to get workspace": Verify entries in `robot_info.yaml`.

Note: Use `local` as the robot name for local operations. YAML file paths should be relative to the robot's workspace.

Detailed documentation is available [here](/usr/local/bin/docs/launch.md).

---

### Docker Commands

This section outlines commands related to managing Docker containers and images. These commands are basically a wrapper around docker. I don't think they are that useful tbh. I tried to use docker context but it is tricky to deal with!

#### docker-build

Builds Docker images locally or remotely. 

##### Usage

```bash
airlab docker-build [OPTIONS]
```

##### Options

*   `--system=<system_name>`: Target system for remote operations.
*   `--compose=<compose_file>`: Docker Compose file (relative to robot workspace. Defaults to `$DOCKER_BUILD_PATH`).
*   `--help`: Display help message.

#### docker-list

Lists Docker containers or images.

##### Usage

```bash
airlab docker-list [OPTIONS]
```

##### Options

*   `--system=<system_name>`: Target system for remote operations.
*   `--images`: List images instead of containers.
*   `--help`: Display help message.

#### docker-join

Joins a running container with an interactive shell.

##### Usage

```bash
airlab docker-join [OPTIONS]
```

##### Options

*   `--system=<system_name>`: Target system for remote operations.
*   `--name=<container_name>`: Container to join.
*   `--help`: Display help message.

#### docker-up

Starts containers using Docker Compose.

##### Usage

```bash
airlab docker-up [OPTIONS]
```

##### Options

*   `--system=<system_name>`: Target system for remote operations.
*   `--compose=<compose_file>`: Docker Compose file (relative to the robot workspace. Defaults to `$DOCKER_UP_PATH`).
*   `--help`: Display help message.

#### Common Features

*   **Remote Operations**: Requires a valid system definition in `robot.conf`, SSH credentials, and correct configuration in `robot_info.yaml`.
*   **Error Handling**: Employs colored error messages and performs validation before executing operations.
*   **Dependencies**: `docker`, `docker-compose`, `ssh`, `sshpass`.
*   **Environment**: Requires `$DOCKER_BUILD_PATH` and `$DOCKER_UP_PATH` to be set.

Detailed documentation is available [here](/usr/local/bin/docs/docker-commands.md).

---

### VCS Commands

This section describes commands for interacting with version control systems. This is based on [vcstool](https://github.com/dirk-thomas/vcstool) which is developed by Thomas Dirk. These tools lets you deal with multiple repositories at the same time.

#### init

Initializes local repositories based on a YAML configuration.

##### Usage

```bash
airlab vcs init [OPTIONS]
```

##### Options

*   `--repo_file=FILE`: YAML file (default: `repos.yaml`).
*   `--path=DIR`: Local directory. If not specified, the directory from the YAML file is used.
*   `--help`: Display help message.
* `--all` : Apply the operation to all YAML files in the version-control directory

#### pull

Pulls changes from remote repositories to the local workspace.

##### Usage

```bash
airlab vcs pull [OPTIONS]
```

##### Options

*   `--no-rebase`: Disable rebasing.
*   `--help`: Display help message.

#### push

Pushes local changes to remote repositories.

##### Usage

```bash
airlab vcs push [OPTIONS]
```

##### Options

*   `--help`: Display help message.

#### status

Displays the status of local repositories.

##### Usage

```bash
airlab vcs status [OPTIONS]
```

##### Options

*   `--help`: Display help message.
* `--show-branch`: Show the current branch of the repository

#### Common Features

*   **Error Handling**: Employs colored error messages and performs validation before executing operations.
*   **Dependencies**: `git`, `vcstool`, `bash`.
*   **Environment**: Requires `$AIRLAB_PATH` to be set.

Detailed documentation is available [here](/usr/local/bin/docs/version-control-commands.md).

---

## Workspace Structure

### Overview

This workspace design is intended to simplify integration and operation of robotic systems utilizing ROS 2 and Docker. The workspace is structured into folders dedicated to specific tasks, ensuring efficient management of configurations, dependencies, and runtime environments and enabling a smooth and scalable development process.

### Directory Structure

The workspace follows this hierarchical structure:

```
workspace/
│
├── docker/
│   ├── sample.dockerfile            # Dockerfile to build the container
│   ├── docker-compose.yml           # Compose file to manage multiple containers
│
├── launch/
│   ├── sample.yaml                 # Launch file for starting nodes or systems
│
├── robot/
│   ├── robot.conf                  # Configuration file for robot-specific settings
│   ├── robot_info.yaml             # System-generated YAML file containing robot information
│
├── version_control/
│   ├── repos.yaml                  # Sample repositories for version control using git
│
└── airlab.env                      # Environment file for airlab command settings
```

### Folder Breakdown

#### docker/

This folder contains all Docker-related files, including the **Dockerfile** and **docker-compose.yml**, which are essential for setting up the containerized environment.

-   **sample.dockerfile**: The primary Dockerfile used to build the robot's container.
-   **docker-compose.yml**: A Docker Compose file for managing multi-container setups, which simplifies running and scaling multiple services or systems simultaneously.

##### Usage:

-   Add additional Dockerfiles and compose files to this directory as needed. Ensure that any changes align with the standard structure and naming conventions.

#### launch/

This folder holds all **launch** files in the [tmuxp format](https://github.com/tmux-python/tmuxp), a powerful tool for managing tmux sessions programmatically. Launch files specify the startup procedures for nodes or systems and are crucial for orchestrating the robot's operational flow.

-   **sample.yaml**: A sample launch file configured to use tmuxp format for managing multi-session tmux setups.

##### Usage:

-   Add new launch files as needed, ensuring that they follow the tmuxp format to maintain consistency and compatibility.

#### robot/

This folder contains the configuration files that define robot-specific settings and metadata. It is essential for ensuring that the robot's environment is properly configured and that the system can integrate various robots into the workspace.

-   **robot.conf**: A configuration file to define the IP addresses of remote systems. The format is simple:

    ```
    mt001=dtc@10.223.1.99
    mt002=dtc@10.3.1.102
    ```

    Each line maps a robot identifier (e.g., `mt001`) to an IP address and a username.

-   **robot_info.yaml**: A dynamically generated YAML file that contains detailed information about the robots in the system, including metadata such as IP addresses, usernames, and robot models.

    Example:

    ```yaml
    spot1:
      ws_path: "/home/airlab/airlab_ws"
      robot_ssh: "airlab@10.3.1.14"
      last_updated: "2024-12-22 19:48:31"
    ```

##### Usage:

-   The **robot_info.yaml** file is automatically updated by the `airlab` command to reflect the latest robot configurations.
-   The **robot.conf** file must be manually updated to include the IP addresses of new robots as they are added to the system.

#### version_control/

This folder is responsible for managing the version control configurations for the repositories used in the project. It utilizes [python-vcstool](https://github.com/dirk-thomas/vcstool) to streamline version management and facilitate easy integration of external repositories.

-   **repos.yaml**: This file lists all the repositories required for the project. The file follows the vcs format supported by vcstool. Each repository is defined by its type, URL, and the version/branch to be used.

    Example format:

    ```yaml
    dir: src
    repositories:
      vcstool:
        type: git
        url: git@github.com:dirk-thomas/vcstool.git
        version: master
    ```

    In this example, `type` specifies the version control system (e.g., `git`), `url` provides the repository location, and `version` refers to the branch (e.g., `master`).
    The path provided to the dir is relative to the workspace_path.

##### Usage:

-   Regularly update the **repos.yaml** file to add new repositories, update existing ones, or change versions to ensure your workspace stays synchronized with the latest code and dependencies.
- You can also add other yaml files to **version_control/** for specific purposes.

#### airlab.env

The **airlab.env** file configures the environment variables and runtime settings specific to the `airlab` command. It is essential for ensuring that the necessary paths, configurations, and system parameters are set up correctly.

##### Key points:

-   This file defines system paths, environment variables, and settings unique to the robot's workspace.
-   **airlab.env** is **system-specific** and **not synchronized** when you run the sync or setup commands. This means each system or robot may have a different configuration.

##### Usage:

-   Make sure to configure this file correctly for each system to ensure that the `airlab` command functions as expected.

**IMPORTANT NOTE**: You are welcome to rename or create new files as needed, but **please do not modify the folder structure**. Renaming or deleting folders like `docker/` or altering their names may cause the tool to malfunction and prevent it from working properly.

## Future Work

This was a weekend project through which I learned scripting. I would love new ideas that we can add here. It should probably be adding ROS2 functionality to the tool!

## Contributing

Contributions are welcome! Feel free to fork the repository, make changes, and submit a pull request. Please ensure any changes follow coding standards and include relevant tests if applicable.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

<!-- ## Index

*   `.bashrc`, [Setup Process](#setup-process), [Setup](#setup)
*   `airlab` command, [Commands](#commands)
*   `airlab.env`, [Setup Process](#setup-process), [Setup](#setup)
*   CUDA Toolkit, [Prerequisites](#prerequisites)
*   Debian package, [Key Features](#key-features), [Installation Steps](#installation-steps)
*   Docker, [Introduction](#introduction), [Docker Commands](#docker-commands)
*   Docker Engine, [Prerequisites](#prerequisites)
*   NVIDIA Driver, [Prerequisites](#prerequisites)
*   NVIDIA Container Toolkit, [Prerequisites](#prerequisites)
*   ROS2, [Future Work](#future-work)
*   `robot.conf`, [Setup Process](#setup-process), [Setup](#setup)
*   `robot_info.yaml`, [Setup Process](#setup-process), [Setup](#setup)
*   rsync, [Introduction](#introduction)
*   SSH, [Setup Process](#setup-process), [Setup](#setup)
*   sshpass, [Setup Process](#setup-process), [Setup](#setup)
*   tmux, [Introduction](#introduction)
*   tmuxp format, [launch/](#launch)
*   vcstool, [version_control/](#version_control) -->
