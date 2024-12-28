# Launch

## Overview
The `airlab launch` command is a bash script designed to manage tmux sessions for robot control, supporting both local and remote operations. It provides functionality to launch and stop tmux sessions using YAML configuration files, with robust error handling and dependency checking.

## Syntax
```
airlab launch <yaml_file> [options]
```

## Arguments
- `<robot_name>`: The name of the robot/launch file (without .yaml extension)
  - This corresponds to a YAML file located in `$AIRLAB_PATH/launch/<robot_name>.yaml`

## Options
- `--system=<target_system>`: Launch on a remote system defined in robot.conf
- `--stop`: Stop the tmux session instead of starting it
- `--help`: Display usage information

## Configuration Files

### Robot Configuration (`robot.conf`)
- Location: `$AIRLAB_PATH/robot/robot.conf`
- Format: Simple key-value pairs defining robot SSH addresses
- Example:
  ```
  mt001=user@192.168.1.100
  mt002=user@192.168.1.101
  ```

### Robot Information (`robot_info.yaml`)
- Location: `$AIRLAB_PATH/robot/robot_info.yaml`
- Contains workspace paths for remote systems
- Required for remote operations
- Format:
  ```yaml
  system_name:
    ws_path: /path/to/workspace
  ```

### Launch Files
- Location: `$AIRLAB_PATH/launch/<robot_name>.yaml`
- Contains tmux session configuration
- Required for both local and remote operations

## Features

### Local Operations
1. Launch a tmux session:
   ```bash
   airlab launch mt001
   ```
2. Stop a tmux session:
   ```bash
   airlab launch mt001 --stop
   ```

### Remote Operations
1. Launch on remote system:
   ```bash
   airlab launch mt001 --system=mt002
   ```
2. Stop remote session:
   ```bash
   airlab launch mt001 --system=mt002 --stop
   ```

### Security Features
- SSH password authentication
- Connection timeout handling
- StrictHostKeyChecking disabled for convenience
- Error handling for SSH connections

### Error Handling
The script includes comprehensive error checking for:
- Missing dependencies
- Invalid configuration files
- SSH connection failures
- YAML parsing errors
- Missing workspace paths
- Invalid command options

## Dependencies
Required software:
- tmuxp
- ssh
- python3 with PyYAML module
- sshpass (for remote operations)

## Exit Codes
- 0: Successful execution
- 1: Various error conditions (missing files, connection failures, etc.)

## Logging
The script provides colored output for different types of messages:
- Green: Information messages
- Yellow: Warnings
- Red: Errors

## Examples

### Basic Usage
```bash
# Launch locally
airlab launch mt001

# Stop local session
airlab launch mt001 --stop
```

### Remote Operations
```bash
# Launch on remote system
airlab launch mt001 --system=mt002

# Stop remote session
airlab launch mt001 --system=mt002 --stop
```

## Best Practices
1. Ensure all configuration files are properly set up before running remote operations
2. Verify SSH access to remote systems before attempting launches
3. Keep robot.conf and robot_info.yaml up to date
4. Use meaningful robot names that correspond to their configuration files

## Troubleshooting

### Common Issues
1. "YAML file not found":
   - Verify the launch file exists in `$AIRLAB_PATH/launch/`
   - Check file permissions

2. "System not found in robot.conf":
   - Verify the system name in robot.conf
   - Check for typos in the --system argument

3. "Cannot connect to remote system":
   - Verify network connectivity
   - Check SSH credentials
   - Ensure the remote system is online

4. "Failed to get workspace path":
   - Verify robot_info.yaml contains the correct system entry
   - Check YAML syntax in robot_info.yaml

### Debug Tips
1. Check tmux session status:
   ```bash
   tmux ls
   ```
2. Verify SSH connectivity:
   ```bash
   ssh <robot_ssh_address>
   ```
3. Validate YAML files:
   ```bash
   python3 -c 'import yaml; yaml.safe_load(open("file.yaml"))'
   ```