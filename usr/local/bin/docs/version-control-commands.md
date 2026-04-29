# VCS Tool Commands Documentation

A suite of local version control system (VCS) commands for managing multiple repositories using vcstool.

## Commands Overview
- [init](#init): Initialize local repositories from a YAML configuration
- [pull](#pull): Pull changes from remote repositories to local workspace
- [push](#push): Push local changes to remote repositories
- [status](#status): Check local repository status
- [update](#update): Pull, init missing repos, and pull again with summary
- [examples](#examples)

## init

### Description
Clones and sets up repositories in your local workspace based on a YAML configuration file.

### Usage
```bash
airlab vcs init [OPTIONS]
```

### Options
- `--repo_file=FILE`: YAML file containing repository information (default: repos.yaml)
- `--path=DIR`: Local directory to clone repositories into (default: defined by dir in repos.yaml)
- `--all`: Apply the operation to all YAML files in the version-control directory. Cannot be used with `--repo_file` or `--path`.
- `--here`: Re-initialize repos in the current directory using its `AIRLAB_REPO_FILE` marker.
- `--here --check`: Compare the current directory structure against the YAML defined in `AIRLAB_REPO_FILE`.
- `--here --from-scratch`: Delete all YAML-defined repo folders and re-clone from scratch. Only proceeds if `--check` finds no discrepancies (no missing, no extra folders).
- `--entry=NAME`: Only initialize the single repository entry NAME from the YAML file. Valid with `--repo_file` or `--here`. Incompatible with `--all`, `--check`, and `--from-scratch`.
- `--help`: Display help message

### Features
- Creates local directory structure
- Copies YAML configuration to workspace
- Clones repositories to the directory
- Path is relative to your workspace path ($AIRLAB_PATH)
- `--here` reads the `AIRLAB_REPO_FILE` marker from the current directory to determine which YAML file to use

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
- Provides colored output for status updates

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
- `--show-branch`: Show the current branch of the repository
- `--help`: Display help message

### Features
- Shows status of all repositories in configuration file
- Provides colored output for better visibility
- Uses stored repository paths from config

## update

### Description
Updates repositories by pulling latest changes and initializing any new repos from the AIRLAB_REPO_FILE marker in the current directory.

### Usage
```bash
airlab vcs update [OPTIONS]
```

### Options
- `--help`: Display help message

### Steps
1. Pull all existing repos (stops on first failure).
2. Run `airlab vcs init --here` to clone any missing repos.
3. Pull all repos again (collects failures and shows a summary).

### Features
- Must be run from the directory containing `AIRLAB_REPO_FILE`
- Provides a colored summary of succeeded and failed pulls
- Automatically initializes any newly added repos from the YAML file

## Common Features

### Configuration
- Uses YAML configuration file from local version-control directory
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

## Examples
```bash
# clone all repositories in all yaml files present in the version control directory
airlab vcs init --all

# clone all repositories in the repos.yaml into path present in repos.yaml
airlab vcs init --repo_file=repo.yaml

# clone all repositories in the repos.yaml into a specified path
airlab vcs init --repo_file=repo.yaml --path=/my/custom/path

# re-initialize repos in the current directory using its AIRLAB_REPO_FILE
airlab vcs init --here

# check current directory structure against the YAML
airlab vcs init --here --check

# delete and re-clone all repos from scratch
airlab vcs init --here --from-scratch

# initialize only a single repo entry
airlab vcs init --repo_file=repos.yaml --entry=my_repo

# pull changes from remote repositories with rebase
airlab vcs pull

# pull changes from remote repositories without rebase
airlab vcs pull --no-rebase

# push local changes to remote repositories
airlab vcs push

# check the status of all repositories in the default configuration file
airlab vcs status

# show branch of all repositories
airlab vcs status --show-branch

# pull, init missing repos, and pull again with summary
airlab vcs update
```
