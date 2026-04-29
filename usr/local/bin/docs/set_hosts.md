# set_hosts

## Overview
The `airlab set_hosts` command updates `/etc/hosts` on a local or remote machine with hostname-to-IP mappings derived from `robot.conf`. This allows robot names to be used directly in commands like `ping mt001` or `ssh mt001` without needing to remember IP addresses.

## Syntax
```bash
airlab set_hosts <target> [options]
```

## Arguments
- `<target>`: Either `local` (update the local machine) or a robot name from `robot.conf` (update the remote robot via SSH).

## Options
- `--password`: Skip key-based SSH authentication and prompt for a password directly (remote targets only).
- `--help`: Display usage information.

## How It Works

### Entry Generation
The command reads all entries from `$AIRLAB_PATH/robot/robot.conf` (format: `name=user@ip`) and generates `/etc/hosts` lines:
```
10.223.1.99     mt001
10.3.1.102      mt002
```

### Markers
Entries are placed between fenced markers in `/etc/hosts`:
```
# Airlab Hosts Start
10.223.1.99     mt001
10.3.1.102      mt002
# Airlab Hosts End
```

- If the markers already exist, only the content between them is replaced (everything between the markers is removed and new entries are inserted).
- If the markers don't exist, a new section is appended to the end of the file.

### Backup
Before any modification, a timestamped backup of `/etc/hosts` is created:
```
/etc/hosts_20260429_160345
```

### Conflict Detection
Before writing, the command checks for conflicts between the new entries and existing `/etc/hosts` entries **outside** the airlab markers:
- **Hostname conflict**: A robot name already appears in `/etc/hosts` mapped to a different IP.
- **IP overlap**: An IP from `robot.conf` already appears in `/etc/hosts` mapped to a different hostname.

If any conflicts are detected, the command warns and aborts without modifying the file.

### Remote Operation
When targeting a remote robot, the command:
1. Looks up the robot's SSH address from `robot.conf`.
2. Authenticates via SSH (key-based first, falls back to password, or uses `--password` to skip key-based).
3. Reads the remote `/etc/hosts`, performs conflict checks, creates a remote backup, and writes the updated file.

## Examples

### Local
```bash
# Update local /etc/hosts with all robots from robot.conf
airlab set_hosts local
```

### Remote
```bash
# Update /etc/hosts on mt001
airlab set_hosts mt001

# Use password authentication
airlab set_hosts mt001 --password
```

## Configuration Files
- **Robot config**: `$AIRLAB_PATH/robot/robot.conf` — source of hostname-to-IP mappings.

## Dependencies
- `ssh`, `sshpass` — for remote operations
- `sudo` — required to modify `/etc/hosts`

## Error Handling
- Validates that `robot.conf` exists and contains entries.
- Validates that the target robot exists in `robot.conf` (for remote targets).
- Checks for hostname/IP conflicts before writing.
- Creates a backup before every modification.
- Provides colored error/warning/info messages.

## Troubleshooting

### Common Issues
1. "Permission denied": The command uses `sudo` to modify `/etc/hosts`. Ensure your user has `sudo` privileges.
2. "Conflicts detected": Another entry in `/etc/hosts` (outside the airlab markers) uses the same hostname or IP. Resolve the conflict manually, then re-run.
3. "Robot not found in robot.conf": Verify the robot name matches an entry in `$AIRLAB_PATH/robot/robot.conf`.
4. "SSH connection failed": Check network connectivity and credentials, or use `--password`.
