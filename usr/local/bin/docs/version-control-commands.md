# VCS Tool Commands Documentation

A suite of local version control system (VCS) commands for managing multiple repositories using vcstool.

## Commands Overview
- [init](#init): Initialize local repositories from a YAML configuration
- [pull](#pull): Pull changes from remote repositories to local workspace
- [push](#push): Push local changes to remote repositories (or a tag with `--tags=`)
- [status](#status): Check local repository status
- [update](#update): Pull, init missing repos, and pull again with summary
- [check](#check): Find drift across cloned repos or version_control YAMLs
- [tag](#tag): Recursively tag git repositories under the current directory
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
Pushes changes from your local workspace to remote repositories. With `--tags=<name>`, pushes a single named tag, deduplicated by remote URL with the same drift gate as `tag --push`.

### Usage
```bash
airlab vcs push [OPTIONS]
```

### Options
- `--tags=<name>`: Push the named tag instead of branch refs. Walks PWD recursively, finds git repositories (skipping submodules), groups them by remote URL, and pushes from one clone per URL. Refuses if shared clones have the tag pointing at different commits, unless `--force` is also given.
- `--force`: With `--tags=`, overwrite the remote tag and skip the drift gate.
- `--dry-run`: With `--tags=`, show what would be pushed without actually pushing.
- `--help`: Display help message

### Features
- Default mode pushes local changes to remote repositories via `vcs push` (vcstool)
- `--tags=<name>` mode pushes a tag once per unique remote URL (deduplicated)
- Drift gate refuses to push if the same tag points at different commits across shared clones
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

## check

### Description
Find drift across repositories. Two complementary modes:

- **Default (filesystem mode)**: Walks the current directory recursively, finds every git repository (skipping submodules), groups them by remote URL, and flags any group whose clones are not all on the same commit. Run this from `$AIRLAB_PATH` before `airlab vcs tag` to make sure shared clones agree.
- **`--version-control` mode**: Reads every YAML file under `$AIRLAB_PATH/version_control/`. Flags any URL pinned to multiple `version:` values across YAMLs, and any duplicate URLs within a single YAML.

### Usage
```bash
airlab vcs check [OPTIONS]
```

### Options
- `--version-control`: Scan YAMLs in `$AIRLAB_PATH/version_control/` instead of walking PWD.
- `--no-progress`: Disable the progress bar (also auto-disabled when stderr is not a terminal).
- `--help`: Display help message.

### Features
- Skips submodules and linked worktrees automatically (`.git` as a file, or non-empty `git rev-parse --show-superproject-working-tree`).
- Normalizes equivalent ssh and https URLs (so `git@github.com:org/repo` and `https://github.com/org/repo` group together).
- Color-coded output: green when clean, yellow for branch-only skew or non-blocking notes, red for commit-level drift or duplicates.
- Exits 0 when clean, 1 on drift / duplicates / parse errors — usable in scripts.

### Output sections (filesystem mode)
- `[DRIFT]` — shared URLs whose clones are at different commits (red)
- `[BRANCH SKEW]` — same commit but different branches (yellow)
- `[OK]` — shared URLs all in sync (green)
- `[NO ORIGIN]` — repositories without an origin remote, excluded from grouping
- `[DIRTY]` — repositories with uncommitted changes

### Output sections (`--version-control` mode)
- `[VERSION DRIFT]` — URLs pinned to multiple `version:` values across YAMLs
- `[DUPLICATE URL]` — same URL listed under more than one repository name in a single YAML
- `[PARSE ERROR]` — YAML files that failed to load

## tag

### Description
Recursively create a git tag at HEAD of every repository under the current directory, skipping submodules. Optionally push the tag to origin once per unique remote URL (deduplicated, with a drift gate).

### Usage
```bash
airlab vcs tag <tag_name> [OPTIONS]
```

### Arguments
- `<tag_name>`: Name of the tag to create (e.g. `v1.0.0`).

### Options
- `-m, --message=<msg>`: Annotated tag message. Default: `airlab vcs tag <name> on <ISO date>`.
- `--lightweight`: Create a lightweight tag (no message). Mutually exclusive with `-m` / `--message`.
- `--force`: Overwrite an existing local tag. With `--push`, also overwrites the remote tag and skips the drift gate.
- `--push`: After tagging, push the tag to origin once per unique remote URL. Refuses to push if shared clones are not on the same commit, unless `--force` is also set. The repo with the lexicographically smallest path is chosen as the source for each push.
- `--dry-run`: Print what would be done without making any changes.
- `--help`: Display help message.

### Features
- Annotated tags by default, with an auto-generated message.
- Walks PWD with the same logic as `airlab vcs check` (skips submodules, descends through repos to find nested clones).
- Warns on dirty working trees but does not refuse to tag.
- With `--push`, deduplicates by URL — so a repo cloned in 19 workspaces is pushed once, not 19 times.
- Drift gate prevents publishing a tag whose underlying commit differs across shared clones.

### Recommended workflow
1. `airlab vcs check` (fix any `[DRIFT]` cases first)
2. `airlab vcs tag <name>` to validate locally
3. `airlab vcs push --tags=<name>` (or re-run `airlab vcs tag <name> --push`) to publish

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

# check for commit drift among shared repositories under PWD
airlab vcs check

# check for version drift across version_control YAMLs (and intra-YAML duplicates)
airlab vcs check --version-control

# create an annotated tag in every repo under PWD (skipping submodules)
airlab vcs tag v1.0.0

# tag and push, deduplicated by remote URL, with drift gate
airlab vcs tag v1.0.0 --push

# overwrite an existing tag locally and on the remote
airlab vcs tag v1.0.0 --push --force

# preview a tag operation without making changes
airlab vcs tag v1.0.0 --push --dry-run

# push an existing tag (after the fact), deduplicated
airlab vcs push --tags=v1.0.0
```
