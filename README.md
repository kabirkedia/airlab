# Airlab

### **`airlab`: Simplified Deployment for Robotic Systems**  

`airlab` is a command-line tool that unifies essential deployment tasks for local and remote robotic systems. It streamlines file synchronization, launch file management, and environment setup by integrating tools like `rsync`, `docker`, and `tmux`.  

Key features:  
- **File Sync**: Easy local-to-remote transfers.  
- **Launch Management**: Simplified robotic launch file handling.  
- **Environment Setup**: Automated configurations.  
- **Unified Interface**: Combines multiple tools under one command.  
- **Debian Package**: Quick install and updates for seamless deployment.  

`airlab` reduces complexity and accelerates workflows, making it an essential utility for robotics development and deployment.  


### **Installing `airlab`**  

`airlab` is installed on the host machine that controls remote robotic systems. Remote systems are set up using the `setup` command, which automates much of the configuration.  

#### **Prerequisites**  
Ensure `dpkg-deb` is installed on your host machine:  
```bash
sudo apt-get install dpkg-dev
```  

#### **Installation Steps**  

1. **Clone the Repository**:  
   ```bash
   git clone <repository-url>
   cd airlab
   ```  

2. **Set File Permissions**:  
   To ensure all files are executable, run:  
   ```bash
   chmod -R a+rX *
   ```  

   > *Note*: The goal is to make all files within the `airlab` directory executable. You can use other methods to achieve this if preferred.  

3. **Build the Debian Package**:  
   ```bash
   cd ..
   dpkg-deb --build airlab
   ```  

4. **Install `airlab`**:  
   ```bash
   sudo dpkg -i airlab.deb
   sudo apt install -f -y
   ```  

#### **Note on Dependencies**  
`airlab` depends on the libraries listed in `requirements.txt`, but you don't need to install them manually.  
- **Python dependencies** and `docker-compose` are installed using the **preinstall script**.  
- Other system dependencies are installed when you run:  
   ```bash
   sudo apt install -f -y
   ```  
This ensures all missing dependencies are handled seamlessly during installation.  

Once installed, you’re ready to use `airlab` for managing your robotic systems. For remote systems, you don't need to install it just use the [`setup`]() command to configure them efficiently.  


## Commands

Once installed, you can use the `airlab` command to perform various tasks. Below are the usage details for each command. The most important command to run before using any other command is `setup`. 


### Setup

#### Usage
```bash
# Local setup
airlab setup local [--path=<install_path>] [--force]

# Remote setup
airlab setup <robot_name> [--path=<install_path>] [--force]
```

#### Options
- `--path`: Installation directory (default: ~/airlab_ws)
- `--force`: Overwrite existing installation
- `<robot_name>`: Robot identifier from robot.conf

#### Configuration Files
- Robot config: `robot.conf` in workspace's robot folder
- Environment: `airlab.env` (created during setup)
- Bash config: Updates to `.bashrc`

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
1. Creates directory structure
2. Copies configuration files
3. Sets environment variables
4. Updates .bashrc
5. Creates airlab.env

##### Remote
1. Establishes SSH connection
2. Performs environment setup
3. Copies necessary files
4. Installs required packages
5. Updates .bashrc
6. Configures /etc/hosts
##### Robot Configuration
In robot.conf:
```bash
robot1=airlab@192.45.34.1
robot2=airlab@192.45.34.2
```

#### Common Issues
1. "Permission denied": Check installation path permissions
2. "SSH connection failed": Verify robot.conf entries
3. "Configuration exists": Use --force to overwrite
4. "Environment not set": Check airlab.env and .bashrc

Detailed Documentation is present [here](/usr/local/bin/docs/setup.md)

---


### Sync

#### Usage
```bash
airlab sync <robot_name> [options]
```

#### Options
- `--dry-run`: Preview sync without changes
- `--delete`: Remove extra files on remote
- `--path=<relative_path>`: Sync specific directory
- `--exclude=<pattern>`: Skip matching files
- `--time`: Sync system time
- `--help`: Show help

#### Configuration Files
- Robot config: `$AIRLAB_PATH/robot/robot.conf`
- Robot info: `$AIRLAB_PATH/robot/robot_info.yaml`

#### Quick Examples
```bash
# Basic sync
airlab sync mt001                    # Sync all files
airlab sync mt001 --dry-run         # Preview changes
airlab sync mt001 --delete          # Remove extra files

# Advanced sync
airlab sync mt001 --path=src/config # Sync specific path
airlab sync mt001 --exclude='*.log' # Skip log files
```

#### Default Exclusions
- `.git/`, `build/`, `devel/`, `log/`
- `install/`, `*.pyc`, `__pycache__`
- `*.env`

#### Dependencies
- rsync
- ssh
- sshpass
- date
- python3 (with PyYAML)

#### Common Issues
1. "SSH connection failed": Check network/credentials
2. "Workspace not found": Verify robot_info.yaml
3. "Sync failed": Check permissions/space
4. "Time sync failed": Check sudo access

Detailed Documentation is present [here](/usr/local/bin/docs/sync.md)

---

### Launch

#### Usage
```bash
airlab launch <yaml_file> [--system=<target_system>] [--stop] [--help]
```

#### Options
- `<yaml_file>`: launch file name (without .yaml)
- `--system=<target_system>`: Launch on remote system
- `--stop`: Stop tmux session
- `--help`: Show help

#### Configuration Files
- Launch files: `$AIRLAB_PATH/launch/<robot_name>.yaml`
- Robot config: `$AIRLAB_PATH/robot/robot.conf`
- Robot info: `$AIRLAB_PATH/robot/robot_info.yaml`

#### Quick Examples
```bash
# Local operations
airlab launch mt001              # Launch locally
airlab launch mt001 --stop       # Stop local session

# Remote operations
airlab launch mt001 --system=mt002       # Launch on mt002
airlab launch mt001 --system=mt002 --stop # Stop on mt002
```

#### Dependencies
- tmuxp
- ssh
- python3 (with PyYAML)
- sshpass (remote only)

#### Common Issues
1. "YAML file not found": Check file exists in launch directory
2. "System not found": Verify system name in robot.conf
3. "Cannot connect": Check network and SSH credentials
4. "Failed to get workspace": Verify robot_info.yaml entries

Detailed Documentation is present [here](/usr/local/bin/docs/launch.md)

---

### Docker Commands

#### docker-build
Builds Docker images locally or remotely.
```bash
airlab docker-build [--system=<system_name>] [--compose=<compose_file>]
# Examples:
airlab docker-build
airlab docker-build --system=robot1 --compose=docker-compose-orin.yml
```

#### docker-list
Lists Docker containers or images.
```bash
airlab docker-list [--system=<system_name>] [--images]
# Examples:
airlab docker-list
airlab docker-list --system=robot1 --images
```

#### docker-join
Joins a running container with interactive shell.
```bash
airlab docker-join [--system=<system_name>] [--name=<container_name>]
# Examples:
airlab docker-join --name=testcontainer
airlab docker-join --system=robot1 --name=testcontainer
```

#### docker-up
Starts containers using Docker Compose.
```bash
airlab docker-up [--system=<system_name>] [--compose=<compose_file>]
# Examples:
airlab docker-up
airlab docker-up --system=robot1 --compose=docker-compose-orin.yml
```

#### Common Notes
- All commands support both local and remote operations
- Remote operations require:
  - Valid system name in robot.conf
  - SSH credentials
  - Proper configuration in robot_info.yaml
- Required dependencies: docker, docker-compose, ssh, sshpass

Detailed Documentation is present [here](/usr/local/bin/docs/docker-commands.md)

---

### VCSTool Commands

#### init
Initialize local repositories based on a YAML configuration.

**Usage:**
```bash
airlab vcstool init [OPTIONS]
```

**Options:**
- `--repo_file=FILE`: YAML file (default: `repos.yaml`)
- `--path=DIR`: Local directory (default: `ws/src/`)
- `--help`: Display help

**Features:**
- Clones repositories to local workspace
- Updates repository configuration in `/tmp/repo_config.txt`

#### pull
Pull changes from remote repositories to local workspace.

**Usage:**
```bash
airlab vcstool pull [OPTIONS]
```

**Options:**
- `--repo_file=FILE`: Repository config (defaults to base path)
- `--no-rebase`: Disable rebasing
- `--help`: Display help

#### push
Push local changes to remote repositories.

**Usage:**
```bash
airlab vcstool push [OPTIONS]
```

**Options:**
- `--repo_file=FILE`: Repository config (defaults to base path)
- `--help`: Display help

#### status
Displays the status of local repositories.

**Usage:**
```bash
airlab vcstool status [OPTIONS]
```

**Options:**
- `--repo_file=FILE`: Repository config (defaults to base path)
- `--help`: Display help

#### Common Features
- **Error Handling**: Colored error messages and validation before operations.
- **Dependencies**: git, vcstool, bash
- **Environment**: Requires `$AIRLAB_PATH` to be set.

---
## Workspace Structure Documentation

### Overview

This workspace is designed to streamline the integration and operation of robotics systems using ROS 2 and Docker. The workspace is structured into several key folders, each dedicated to specific tasks within the system. This organization ensures efficient management of configurations, dependencies, and runtime environments, enabling a smooth and scalable development process.

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

#### 1. **docker/**

This folder contains all Docker-related files, including the **Dockerfile** and **docker-compose.yml**, which are essential for setting up the containerized environment.

- **sample.dockerfile**: The primary Dockerfile used to build the robot's container.
- **docker-compose.yml**: A Docker Compose file for managing multi-container setups, which simplifies running and scaling multiple services or systems simultaneously.

##### Usage:
- Add additional Dockerfiles and compose files to this directory as needed. Ensure that any changes align with the standard structure and naming conventions.


#### 2. **launch/**

This folder holds all **launch** files in the [tmuxp format](https://github.com/tmux-python/tmuxp), a powerful tool for managing tmux sessions programmatically. Launch files specify the startup procedures for nodes or systems and are crucial for orchestrating the robot's operational flow.

- **sample.yaml**: A sample launch file configured to use tmuxp format for managing multi-session tmux setups.

##### Usage:
- Add new launch files as needed, ensuring that they follow the tmuxp format to maintain consistency and compatibility.


#### 3. **robot/**

This folder contains the configuration files that define robot-specific settings and metadata. It is essential for ensuring that the robot's environment is properly configured and that the system can integrate various robots into the workspace.

- **robot.conf**: A configuration file to define the IP addresses of remote systems. The format is simple:
  ```
  mt001=dtc@10.223.1.99
  mt002=dtc@10.3.1.102
  ```
  Each line maps a robot identifier (e.g., `mt001`) to an IP address and a username.

- **robot_info.yaml**: A dynamically generated YAML file that contains detailed information about the robots in the system, including metadata such as IP addresses, usernames, and robot models.
  Example:
  ```yaml
  spot1:
    ws_path: "/home/airlab/airlab_ws"
    robot_ssh: "airlab@10.3.1.14"
    last_updated: "2024-12-22 19:48:31"
  ```

#### Usage:
- The **robot_info.yaml** file is automatically updated by the `airlab` command to reflect the latest robot configurations.
- The **robot.conf** file must be manually updated to include the IP addresses of new robots as they are added to the system.


Here's an enhanced version of the **version_control/** section:

---

#### 4. **version_control/**

This folder is responsible for managing the version control configurations for the repositories used in the project. It utilizes [python-vcstool](https://github.com/dirk-thomas/vcstool) to streamline version management and facilitate easy integration of external repositories.

- **repos.yaml**: This file lists all the repositories required for the project. The file follows the vcs format supported by vcstool. Each repository is defined by its type, URL, and the version/branch to be used.

  Example format:
  ```yaml
  repositories:
    vcstool:
      type: git
      url: git@github.com:dirk-thomas/vcstool.git
      version: master
  ```

  In this example, `type` specifies the version control system (e.g., `git`), `url` provides the repository location, and `version` refers to the branch (e.g., `master`).

##### Usage:
- Regularly update the **repos.yaml** file to add new repositories, update existing ones, or change versions to ensure your workspace stays synchronized with the latest code and dependencies.
- You can also add other yaml files to **version_control/** for specific purposes.

#### 5. **airlab.env**

The **airlab.env** file configures the environment variables and runtime settings specific to the `airlab` command. It is essential for ensuring that the necessary paths, configurations, and system parameters are set up correctly.

##### Key points:
- This file defines system paths, environment variables, and settings unique to the robot's workspace.
- **airlab.env** is **system-specific** and **not synchronized** when you run the sync or setup commands. This means each system or robot may have a different configuration.

##### Usage:
- Make sure to configure this file correctly for each system to ensure that the `airlab` command functions as expected.

**IMPORTANT NOTE**: You are welcome to rename or create new files as needed, but **please do not modify the folder structure**. Renaming or deleting folders like `docker/` or altering their names may cause the tool to malfunction and prevent it from working properly.


## Future Work

This was a weekend project through which I learned scripting. I would love new ideas that we can add here. It should probably be adding ROS2 functionality to the tool!


## Contributing

Contributions are welcome! Feel free to fork the repository, make changes, and submit a pull request. Please ensure any changes follow coding standards and include relevant tests if applicable.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


