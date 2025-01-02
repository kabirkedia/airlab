# VCS Tool Commands Documentation

A suite of local version control system (VCS) commands for managing multiple repositories using vcstool.

## Commands Overview
- [init](#init): Initialize local repositories from a YAML configuration
- [pull](#pull): Pull changes from remote repositories to local workspace
- [push](#push): Push local changes to remote repositories
- [status](#status): Check local repository status

## init

### Description
Clones and sets up repositories in your local workspace based on a YAML configuration file.

### Usage
```bash
airlab vcs init [OPTIONS]
```

### Options
- `--repo_file=FILE`: YAML file containing repository information (default: repos.yaml)
- `--path=DIR`: Local directory to clone repositories into (default: ws/src/)
- `--help`: Display help message

### Features
- Creates local directory structure
- Copies YAML configuration to workspace
- Clones repositories to the directory
- Updates repository configuration in /tmp/repo_config.txt (For system use)
- Path is relative to your workspace path ($AIRLAB_PATH)

Note: if repo_file is perception.yaml it will create a folder named perception and clone all repositories in the perception folder

### Dependencies
- git
- python3 with vcstool module

## pull

### Description
Pulls changes from remote repositories to your local workspace.

### Usage
```bash
airlab vcs pull [OPTIONS]
```

### Options
- `--no-rebase`: Perform pull without rebasing
- `--help`: Display help message

### Features
- Supports rebasing (default) or regular pulls
- Updates all repositories specified in the YAML file

## push

### Description
Pushes changes from your local workspace to remote repositories.

### Usage
```bash
airlab vcs push [OPTIONS]
```

### Options
- `--help`: Display help message

### Features
- Pushes local changes to remote repositories specified in YAML file
- Provides colored output for status updates

## status

### Description
Displays the current status of local repositories.

### Usage
```bash
airlab vcs status [OPTIONS]
```

### Options
- `--repo_file=FILE`: Repository configuration file (defaults to base path) \
Base Path means it recursively searched for git repositories and performs operations on it!
- `--help`: Display help message

### Features
- Shows status of all repositories in configuration file
- Provides colored output for better visibility
- Uses stored repository paths from config

## Common Features

### Configuration
- Uses YAML configuration file from local version-control directory
- Repository paths are stored in /tmp/repo_config.txt (For system use)
- All paths are relative to $AIRLAB_PATH

### Error Handling
- Exits on errors, undefined variables, and pipe failures
- Provides colored error messages
- Validates configuration before operations

### Output
Color-coded logging for better visibility:
- Green: Information messages
- Yellow: Warnings
- Red: Error messages

### Dependencies
- git
- vcstool (Python package)
- bash

### Environment Requirements
- $AIRLAB_PATH environment variable must be set
- Valid repository configuration in version-control directory
- All operations are performed on local workspace