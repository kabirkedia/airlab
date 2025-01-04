# Launch Command Documentation

## Overview
The `airlab launch` command manages tmux sessions for robot control, supporting both local and remote operations through YAML configuration files.

## Syntax
```
airlab launch <robot_name> [options]
```

## Arguments
- `<robot_name>`: Name of the robot to launch (must be defined in robot.conf)
  - Use 'local' as the robot name to launch locally

## Options
- `--yaml_file=<file_name>`: Specify an alternative YAML launch file
  - Defaults to the path specified in LAUNCH_FILE_PATH environment variable
  - Path should be relative to the robot's workspace
- `--stop`: Stop the tmux session instead of starting it
- `--help`: Display usage information

## Environment Variables
- `LAUNCH_FILE_PATH`: Default path to the launch file in the robot's workspace
  - Can be modified using the `airlab set_env` command

## Examples
```bash
# Launch locally using default launch file
airlab launch local

# Launch on remote system using default launch file
airlab launch mt001

# Stop tmux session on remote system
airlab launch mt001 --stop

# Launch specific YAML file on remote system
airlab launch mt001 --yaml_file=mt002.yaml

# Stop specific YAML file's tmux session on remote system
airlab launch mt001 --yaml_file=mt002.yaml --stop
```

## Configuration
### Robot Configuration
- Defined in `robot.conf`
- Must contain robot definitions for remote operations
- Robot names in the command must match entries in this configuration

## Important Notes
1. The YAML file path should always be relative to the robot's workspace
2. Use 'local' as the robot name for local operations
3. The default launch file can be changed using the `airlab set_env` command
4. Remote operations require proper configuration in robot.conf

## Error Handling
The command includes error checking for:
- Invalid robot names
- Missing YAML files
- Invalid options
- Configuration errors

## Dependencies
Required components:
- tmux
- Robot configuration file (robot.conf)
- YAML launch files