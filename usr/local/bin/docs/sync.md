# Sync 

## Overview
The `airlab sync` command facilitates file synchronization between local and remote robot systems using rsync, with support for selective syncing, dry runs, and time synchronization.

## Syntax
```bash
airlab sync <robot_name> [options]
```

## Arguments
- `<robot_name>`: Name of the target robot (must be defined in robot.conf)

## Options
- `--dry-run`: Preview synchronization without making changes
- `--delete`: Remove files on remote that don't exist locally
- `--path=<relative_path>`: Sync specific directory relative to workspace
- `--exclude=<pattern>`: Skip files/directories matching pattern
- `--time`: Synchronize system time between local and remote
- `--help`: Display usage information

## Configuration Files

### Robot Configuration (`robot.conf`)
- Location: `$AIRLAB_PATH/robot/robot.conf`
- Format: `robot_name=user@host`
- Example:
  ```
  mt001=airlab@192.168.1.100
  mt002=airlab@192.168.1.101
  ```

### Robot Information (`robot_info.yaml`)
- Location: `$AIRLAB_PATH/robot/robot_info.yaml`
- Contains workspace paths for remote systems
- Format:
  ```yaml
  robot_name:
    ws_path: /path/to/workspace
  ```

## Default Exclusions
The following patterns are automatically excluded from synchronization:
- `.git/`: Version control files
- `build/`: Build directories
- `devel/`: Development directories
- `log/`: Log files
- `install/`: Installation files
- `*.pyc`: Python bytecode
- `__pycache__`: Python cache directories
- `*.env`: Environment files

## Features

### File Synchronization
1. Basic sync:
   ```bash
   airlab sync mt001
   ```

2. Selective sync:
   ```bash
   airlab sync mt001 --path=src/controllers
   ```

3. Preview changes:
   ```bash
   airlab sync mt001 --dry-run
   ```

### Time Synchronization
- Automatically syncs system time when `--time` flag is used
- Falls back to hardware clock if date command fails
- Reports time difference after synchronization

### Security Features
- Password-protected SSH authentication
- Connection timeout handling
- Verification of remote paths
- Error handling for failed operations

## Examples

### Basic Usage
```bash
# Simple sync
airlab sync mt001

# Sync with preview
airlab sync mt001 --dry-run

# Sync and remove extra files
airlab sync mt001 --delete
```

### Advanced Usage
```bash
# Sync specific directory
airlab sync mt001 --path=src/config

# Exclude specific files
airlab sync mt001 --exclude='*.log'

# Multiple excludes
airlab sync mt001 --exclude='temp/' --exclude='*.bak'

# Combine options
airlab sync mt001 --path=src/config --exclude='*.log' --dry-run
```

## Dependencies
Required software:
- rsync
- ssh
- sshpass
- date
- python3 with PyYAML (for config parsing)

## Error Handling
The script includes comprehensive error checking for:
- Missing dependencies
- Invalid configuration files
- SSH connection failures
- Remote path verification
- Synchronization failures
- Time synchronization issues

## Best Practices

### Synchronization
1. Always use `--dry-run` first for important syncs
2. Be cautious with `--delete` option
3. Use specific paths when possible
4. Verify remote workspace paths

### Configuration
1. Keep robot.conf up to date
2. Verify workspace paths in robot_info.yaml
3. Use meaningful robot names
4. Document custom exclude patterns

## Troubleshooting

### Common Issues
1. "SSH connection failed":
   - Check network connectivity
   - Verify robot.conf entries
   - Check SSH credentials

2. "Workspace path not found":
   - Verify robot_info.yaml entries
   - Check remote directory permissions
   - Ensure paths exist on remote system

3. "Sync failed":
   - Check disk space
   - Verify file permissions
   - Review rsync error messages

4. "Time sync failed":
   - Check sudo permissions
   - Verify system clock access
   - Check NTP settings

### Debug Steps
1. Use `--dry-run` to verify sync targets
2. Check SSH connection:
   ```bash
   ssh <robot_ssh_address>
   ```
3. Verify remote paths:
   ```bash
   ssh <robot_ssh_address> "ls -la <workspace_path>"
   ```
4. Test rsync manually:
   ```bash
   rsync -avz --dry-run <source> <destination>
   ```