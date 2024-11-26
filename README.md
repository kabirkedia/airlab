Here's an updated `README.md` for the `airlab` command, incorporating the new `launch` and `setup` functionalities as well as the fact that it's a Debian package:

---

# Airlab

`airlab` is a command-line tool designed to streamline interactions between a local environment and remote robotic systems. It supports file synchronization, launch file management, and setup for both local and remote environments. `airlab` can also be installed as a Debian package, allowing easy deployment and updates.

## Table of Contents
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Sync Command](#sync-command)
  - [Launch Command](#launch-command)
  - [Setup Command](#setup-command)
- [Examples](#examples)
- [Dependencies](#dependencies)
- [Building the Debian Package](#building-the-debian-package)
- [Contributing](#contributing)
- [License](#license)

## Installation

To install `airlab`, you can either build the Debian package (see [Building the Debian Package](#building-the-debian-package)) or manually copy the script to a directory in your `PATH`.

### Manual Installation

Clone the repository and place the `airlab` script in a directory that's included in your system's `PATH`:

```bash
git clone <repository-url>
cd airlab
chmod +x airlab
cd ..
dpkg-deb --build airlab
```

### Installing from Debian Package

Once the package is built, install it using `dpkg`:

```bash
sudo dpkg -i airlab_<version>.deb
```

## Configuration

To use `airlab`, you need to set up configuration files for the robots you want to manage:

1. **robot.conf**: Contains SSH addresses for each robot. It should be located at `$AIRLAB_PATH/robot/robot.conf`. The format is:

   ```
   <robot_name>=<robot_ssh_address>
   ```

   Example:
   
   ```
   mt001=user@192.168.1.10
   mt002=user@192.168.1.11
   ```

2. **robot_info.yaml**: Contains additional robot information, like workspace paths. It should be located at `$AIRLAB_PATH/robot/robot_info.yaml`. It is automatically geenrated when you run the setup command on a new robot:

   ```yaml
   mt001:
     ws_path: "/home/user/robot_ws"
   mt002:
     ws_path: "/home/user/another_ws"
   ```

Make sure to set the `AIRLAB_PATH` environment variable to the root directory of your airlab setup:


## Usage

### Setup Command

The `setup` command initializes the local or remote environment for `airlab`. You can specify custom paths and force overwrites.

```bash
airlab setup <command> [options]
```

#### Commands

- `local`: Set up the local environment.
- `<robot_name>`: Set up a remote robot environment.

#### Options

- `--path=<path>`: Specify a custom installation path (default is `$HOME/.airlab`).
- `--force`: Force overwrites without prompting (use cautiously).
- `--help`: Display usage information for the `setup` command.

Make sure to source ~/.bashrc if you are on the local computer

### Sync Command

The `sync` command is used to synchronize files between the local environment and the robot's remote workspace.

```bash
airlab sync <robot_name> [options]
```

#### Options

- `--dry-run`: Show what would be synchronized without making any changes.
- `--delete`: Overwrite the current contents in the directory on the remote machine (same as `--delete` in `rsync`).
- `--path=<relative_path>`: Sync only the contents of the specified relative path within the workspace.
- `--exclude=<pattern>`: Exclude files or directories matching the pattern from synchronization.
- `--help`: Display usage information for the `sync` command.

### Launch Command

The `launch` command is used to start or stop tmux sessions for robots, either locally or on a remote system.

```bash
airlab launch <robot_name> [options]
```

#### Options

- `--system=<target_system>`: Launch or stop a session on a remote system specified in `robot.conf`.
- `--stop`: Stop the tmux session instead of starting it.
- `--help`: Display usage information for the `launch` command.

## Examples

### Sync Examples

Sync all files to the robot `mt001`:

```bash
airlab sync mt001
```

Perform a dry-run to see what would be synced:

```bash
airlab sync mt001 --dry-run
```

Sync and remove any files on the remote that are not in the local directory:

```bash
airlab sync mt001 --delete
```

Sync only the contents of `src/path`:

```bash
airlab sync mt001 --path=src/path
```

Exclude `.log` files while syncing:

```bash
airlab sync mt001 --exclude='*.log'
```

### Launch Examples

Launch `mt001.yaml` locally:

```bash
airlab launch mt001
```

Stop the local `mt001` tmux session:

```bash
airlab launch mt001 --stop
```

Launch `mt001.yaml` on the remote system `mt002`:

```bash
airlab launch mt001 --system=mt002
```

### Setup Examples

Set up the local environment with a custom path:

```bash
airlab setup local --path=/custom/path
```

Set up the environment for `robot1` with a custom path, forcing overwrites:

```bash
airlab setup robot1 --path=/custom/path --force
```

## Dependencies

`airlab` requires several tools to function correctly:

- **rsync**: For file synchronization.
- **ssh**: For remote connections.
- **sshpass**: For non-interactive SSH authentication.
- **tmux**: For managing sessions.
- **date**: For time synchronization.
- **python3** and **PyYAML**: For YAML configuration parsing.

To install dependencies on a Debian/Ubuntu system:

```bash
sudo apt-get update
sudo apt-get install rsync ssh sshpass tmux python3 python3-pip
pip3 install PyYAML
```

## Building the Debian Package

To create the Debian package:

1. Ensure you have `dpkg-deb` installed:

   ```bash
   sudo apt-get install dpkg-dev
   ```

2. Navigate to the project directory and build the package:

   ```bash
   dpkg-deb --build airlab
   ```

3. Install the package:

   ```bash
   sudo dpkg -i airlab_<version>.deb
   ```

## Contributing

Contributions are welcome! Feel free to fork the repository, make changes, and submit a pull request. Please ensure any changes follow coding standards and include relevant tests if applicable.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This version covers the new `launch` and `setup` commands, along with details on how to build and use the Debian package. Let me know if there are any adjustments or additional details you'd like to include!
