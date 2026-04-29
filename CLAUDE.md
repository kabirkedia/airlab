# Airlab - Claude Code Context

## Project Overview

`airlab` is a Bash-based CLI tool for deploying and managing robotic systems. It is packaged as a `.deb` and installs to `/usr/local/bin/`. The tool wraps `rsync`, `ssh`, `docker`, `tmux`, and `vcs` (vcstool) under a unified interface.

## Repository Structure

```
usr/local/bin/
  airlab                          # Main entrypoint (case dispatcher)
  cmds/
    ssh                           # SSH into a robot
    ping                          # Ping a robot
    auth                          # Install SSH public key on a robot
    robot-sync                    # Sync files via rsync
    robot-setup                   # Setup local/remote environment
    robot-launch                  # Launch tmux sessions
    docker-build                  # Build Docker images
    docker-up                     # Start Docker containers
    docker-join                   # Attach to running containers
    docker-list                   # List Docker containers/images
    set_env                       # Set environment variables
    version-control/
      vcs                         # VCS sub-command dispatcher
      init                        # Clone repos from YAML (--here, --check, --from-scratch)
      pull                        # Pull repos
      push                        # Push repos
      status                      # Status with branch/remote/dirty/submodule checks
      update                      # Pull + init missing + pull again with summary
usr/share/zsh/vendor-completions/
  _airlab                         # Zsh completion function (auto-discovered via fpath)
etc/airlab/                       # Default config templates (copied to workspace on setup)
  airlab.zsh                      # Zsh shell function wrapper (sourced from ~/.zshrc)
  robot/robot.conf                # Robot SSH address mappings (name=user@host)
  robot/robot_info.yaml           # Robot metadata (YAML)
  version_control/repos.yaml      # Repository definitions for vcstool
etc/bash_completion.d/
  airlab                          # Bash completion + shell function wrapper
```

## Key Conventions

- **All commands are standalone Bash scripts** with no shared library. Each script defines its own utility functions (`log_info`, `log_warn`, `log_error`, `parse_yaml`, `ssh_authenticate`, etc.).
- **SSH authentication pattern**: Every SSH-using command has an `ssh_authenticate()` function that tries key-based SSH first (`BatchMode=yes`), falls back to password via `sshpass`. The result is stored in the global `robot_password` variable. Callers must NOT declare `local robot_password` before calling `ssh_authenticate` — use `robot_password=""` instead.
- **SSHPASS_PREFIX pattern**: After `ssh_authenticate`, commands set up `SSHPASS_PREFIX=()` (empty for key-based) or `SSHPASS_PREFIX=(sshpass -p "$robot_password")`. All SSH/rsync/scp calls use `"${SSHPASS_PREFIX[@]}"` as a prefix.
- **`--password` flag**: All SSH-using commands accept `--password` to skip key-based auth and prompt directly.
- **YAML parsing**: Done via inline `python3 -c "import yaml; ..."` calls. PyYAML is a dependency.
- **AIRLAB_REPO_FILE**: A marker file placed in repo directories by `vcs init`. Contains the YAML filename used for initialization. Used by `--here`, `--check`, `--from-scratch`, `vcs status`, and `vcs update`.
- **Config path**: `$AIRLAB_PATH` env var points to the workspace root (set in `~/.bashrc` or `~/.zshrc` during `airlab setup local`).
- **Shell support**: Both Bash and Zsh are supported. Bash completion uses the traditional `complete -F` API in `etc/bash_completion.d/airlab`. Zsh completion uses `_arguments` in `usr/share/zsh/vendor-completions/_airlab`. The `airlab cd` shell function is defined in both completion files (Bash) and `etc/airlab/airlab.zsh` (Zsh). The install script configures `~/.zshrc` when zsh is detected.

## Testing

To test without building a .deb, run scripts directly from the repo:
```bash
./usr/local/bin/cmds/ssh mt001
./usr/local/bin/cmds/robot-sync mt001 --dry-run
```
The scripts only depend on `$AIRLAB_PATH` being set (from an existing install).

## Known Issues

- `robot-launch` uses `error_exit()` which is not defined in that file (should be `log_error` + `exit 1`).
- `docker-join` default `CONTAINER_NAME` is `"docker-compose.yml"` which is a filename, not a container name.
- `robot-sync` port extraction logic (lines ~303-311) is fragile for addresses with ports.

## Build & Install

```bash
# Build .deb
sudo dpkg-deb --build /path/to/airlab
# Install
sudo dpkg -i airlab.deb
# Install dependencies
./install_dependencies_ubuntu24.sh
```
