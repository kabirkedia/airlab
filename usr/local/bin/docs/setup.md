# Setup

This script facilitates the setup of the Airlab environment for both local and remote systems, providing robust management of configuration, installation, and deployment.

## Features

- **Local Environment Setup**: Configure and initialize the environment on your local machine.
- **Remote Environment Setup**: Set up the environment on a remote robot system using SSH.
- **Configuration Management**: Save and load environment configurations.
- **Customizable Paths**: Specify custom installation paths with options for overwriting. Users can define custom paths via the `--path` option during setup. If no custom path is specified, the script defaults to `~/airlab_ws`. For clarity, always ensure the desired paths are accessible and provide examples when possible.
- **Error Handling**: Logs warnings and errors for better debugging.
- **YAML Configuration**: Updates and manages robot-specific YAML configuration files.

## Usage

Run the script with the desired mode and options. The primary modes are `setup_local` and `setup_remote`.

### Local Setup

To configure the environment locally:

```bash
airlab setup local --path=/desired/installation/path
```

#### Options:
- `--path` : Specify the custom installation path. If not provided, defaults to ~/airlab_ws
- `--force`: Overwrite existing installations.

When running airlab setup local, the command:
- Creates the Airlab directory structure
- Copies initial configuration files
- Sets up the environment variables
- Updates the user's .bashrc file
- Creates an initial airlab.env file

---

### Remote Setup

To configure the environment on a remote robot system, add the name of your robot to the `robot.conf` file, located in the `robot` folder of your workspace. For example, if your workspace is structured as follows:

The syntax should be something like:
```bash
robot1=airlab@192.45.34.1
```

After that you can run the command:
```bash
airlab setup robot1 --path=/desired/installation/path
airlab setup robot1 --path=/desired/installation/path --force
```

#### Options:
- `--path` : Specify the custom installation path.
- `--force`: Overwrite existing installations.

When running airlab setup <system_name>, the command:
- Validates the robot configuration
- Connects to the remote system via SSH
- Sets up the remote environment
- Copies initial files
- Installs or updates the Airlab package
- Configures the remote environment
- Updates the remote .bashrc file
- Updates the /etc/hosts file on host system. It creates an alias so that you directly ssh using hostname like `ping robot1`
- Syncs the /etc/hosts file to the remote system so that it remains consistent across systems. It does not change system generated information

## Error Handling

The script provides color-coded output for different types of messages:
- Green: Information messages (`[INFO]`)
- Yellow: Warning messages (`[WARN]`)
- Red: Error messages (`[ERROR]`)

## Configuration Files

### airlab.env
Contains environment variables for the Airlab workspace:
```bash
AIRLAB_PATH=/path/to/workspace
AIRLAB_SYSTEM=local|<robot_name>
```

### robot.conf
Contains robot SSH configurations in the format:
```bash
robot_name=username@ip_address
```

### Robot Information YAML
Located at `$AIRLAB_PATH/robot/robot_info.yaml`, stores robot-specific information:
```yaml
robots:
  robot_name:
    robot_ssh: "username@ip_address"
    ws_path: "/path/to/workspace"
    last_updated: "YYYY-MM-DD HH:MM:SS"
```

## Best Practices

1. Always backup existing configurations before using the `--force` option
2. Use absolute paths or `~` notation when specifying custom paths
3. Verify robot configurations in `robot.conf` before attempting remote setup
4. Test SSH connectivity before initiating remote setup
5. Review host file modifications after setup completion

## Notes

- Run `source ~/.bashrc` after setup to apply environment changes
- Remote setup may require system restart for all changes to take effect
- Host file modifications require sudo privileges
- Keep robot.conf entries up to date with correct SSH addresses