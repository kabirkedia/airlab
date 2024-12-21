# Airlab

`airlab` is a command-line tool designed to streamline interactions between a local environment and remote robotic systems. It supports file synchronization, launch file management, and setup for both local and remote environments. `airlab` can also be installed as a Debian package, allowing easy deployment and updates.

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

## Installation

To install `airlab`, you can either build the Debian package (see [Building the Debian Package](#building-the-debian-package)) or manually copy the script to a directory in your `PATH`.

### Manual Installation

Clone the repository and place the `airlab` script in a directory that's included in your system's `PATH`:

Ensure you have `dpkg-deb` installed:

   ```bash
   sudo apt-get install dpkg-dev
   ```
Now you can proceed to installation using the following commands. The chmod command might be confusing. You may using something else but the goal should be that all files inside the airlab directory should be executable.

```bash
git clone <repository-url>
cd airlab
chmod -R a+rX *           # To set all files as executable
cd ..
dpkg-deb --build airlab
sudo dpkg -i airlab.deb
```

### Installing from Debian Package
You can also it directly using the deb package:

```bash
sudo dpkg -i airlab_<version>.deb
```

## Configuration

*Before configuring please setup the workspace using airlab setup. Details are in [usage](#usage) below*

To use `airlab`, you need to set up configuration files for the robots you want to manage:

`$AIRLAB_PATH` is a variable that contains your workspace for configuration files. it defaults to `$HOME/airlab` but can be customized while setting up the workspace configuration using the setup command.

1. **robot.conf**: Contains SSH addresses for each robot. It should be located at `$AIRLAB_PATH/robot/robot.conf`. The format is:

   ```
   <robot_name>=<robot_ssh_address>
   spot1=192.168.0.0
   ```

2. **launch/sample.yaml**: Contains sample launch files for each robot. It should be located at `$AIRLAB_PATH/launch/launch.conf`.  
I use **tmuxp** as the underlying tool for launch file configurations. More details about tmuxp can be found [here](https://github.com/tmux-python/tmuxp).

2. **dcoker/sample.yaml**: Contains sample docker and docker-compose files for each robot. It should be located at `$AIRLAB_PATH/docker`.  
I use **tmuxp** as the underlying tool for launch file configurations. More details about tmuxp can be found [here](https://github.com/tmux-python/tmuxp).



**PLEASE DON'T DELETE THEM OR MODIFY THEIR NAME.** \
You may modify the contents in them as per your need.

`airlab.env` is the primary source for all the enviornment variables and is sourced by the bashrc. It has to remain different across all the remote systems.

## Usage

Once installed, you can use the `airlab` command to perform various tasks. Below are the usage details for each command.

*Remember while using **--system** arguement, the system has to be defined in the **robot.conf** file*

### setup

Set up the environment for a robot either locally or remotely. You can also customize the installation path and force overwrite. 

*Note:Please use sudo while using the command.*

```bash
Usage:
  airlab setup command [options]

Commands:
  local                   Setup local environment
  <system_name>           Setup remote robot environment

Options:
  --path=<path>           Custom installation path (default: ~/.airlab)
  --force                 Force overwrite without prompting (use with caution)

Examples:
  airlab setup local --path=/custom/path
  airlab setup mt001 --path=~/custom/path --force
```


### launch

Launch a robot configuration or stop a tmux session. You can launch configurations locally or on a remote system.

```bash
Usage:
  airlab launch <yaml_file> [options]

Arguments:
  <robot_name>              Name of the robot/launch file (without .yaml extension)

Options:
  --system=<target_system>  Launch on a remote system defined in robot.conf
  --stop                    Stop the tmux session instead of starting it
  --help                    Show this help message

Examples:
  airlab launch mt001                       # Launch mt001.yaml locally
  airlab launch mt001 --stop               # Stop local mt001 tmux session
  airlab launch mt001 --system=mt002       # Launch mt001.yaml on mt002
  airlab launch mt001 --system=mt002 --stop # Stop mt001 tmux session on mt002
```

### sync

Synchronize code with a remote robot. This command supports various options to control what is synced, such as excluding files or syncing specific paths.

*Uses rsync as the default way to sync*

```bash
Usage:
  airlab sync <robot_name> [options]

Options:
  --dry-run                 Show what would be synchronized without making changes
  --delete                  Overwrite the current contents in the directory on the remote machine
  --path=<relative_path>    Sync only the contents of the given path
  --exclude=<pattern>       Exclude files or directories matching the pattern
  --help                    Show this help message

Examples:
  airlab sync mt001                       #Sync files to mt001
  airlab sync mt001 --dry-run             #Show files that will be changed
  airlab sync mt001 --delete              #Same as --delete in rsync
  airlab sync mt001 --path=src/path       #Sync only the contents of src/path to mt001
  airlab sync mt001 --exclude='*.log'     #Exclude all .log files from being synced
  airlab sync mt001 --exclude='temp/'     #Exclude the 'temp' directory from being synced
  airlab sync mt001 --exclude='*.log' --path=src/path  
```

### docker-build

Build Docker images using `docker-compose`. This command allows you to specify a custom Docker Compose file and a system for remote operations.

```bash
Usage:
  airlab docker-build [--system=<system_name>] [--compose=<compose_file>]

Options:
  --system=<system_name>    Specify the system name for remote operations.
  --compose=<compose_file>  Specify a Docker Compose file (default: docker-compose.yml).
  --help                    Display this help message.

Examples:
  airlab docker-build
  airlab docker-build --compose=docker-compose-orin.yml
  airlab docker-build --system=robot1 --compose=docker-compose-orin.yml
```

### docker-join

Attach to a running Docker container. You can specify the container name and target a remote system.

```bash
Usage:
  airlab docker-join [--system=<system_name>] [--name=<container_name>]

Options:
  --system=<system_name>    Specify the system name for remote operations.
  --name=<container_name>   Specify the container to join.
  --help                    Display this help message.

Examples:
  airlab docker-join
  airlab docker-join --name=testcontainer
  airlab docker-join --system=robot1 --name=testcontainer
```

### docker-list

List active Docker containers. You can list running containers locally or on a remote system and optionally display images.

```bash
Usage:
  airlab docker-list [--system=<system_name>] [--images]

Options:
  --system=<system_name>    Specify the system name for remote operations.
  --images                  List Docker images.
  --help                    Display this help message.

Examples:
  airlab docker-list
  airlab docker-list --images
  airlab docker-list --system=robot1 --images
```

### docker-up

Start Docker containers using `docker-compose`. You can specify a custom Docker Compose file and target a remote system.

```bash
Usage:
  airlab docker-up [--system=<system_name>] [--compose=<compose_file>]

Options:
  --system=<system_name>    Specify the system name for remote operations.
  --compose=<compose_file>  Specify a Docker Compose file (default: docker-compose.yml).
  --help                    Display this help message.

Examples:
  airlab docker-up
  airlab docker-up --compose=docker-compose-orin.yml
  airlab docker-up --system=robot1 --compose=docker-compose-orin.yml
```

## Dependencies

`airlab` requires several tools to function correctly:

- **rsync**:            For file synchronization.
- **ssh**, **ssh-askpass**:              For remote connections.
- **sshpass**:          For non-interactive SSH authentication.
- **tmux**:             For managing sessions.
- **date**:             For time synchronization.
- **docker**:           For docker operations.
- **docker-compose-plugin**: For building docker files using docker compose
- **python3** and **PyYAML**: For YAML configuration parsing.

The dependencies on a Debian/Ubuntu system are installed uing the presinst sciprt but make sure you have `dpkg-deb` installed if you want to build the repo:

## Contributing

Contributions are welcome! Feel free to fork the repository, make changes, and submit a pull request. Please ensure any changes follow coding standards and include relevant tests if applicable.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

