# Alias Commands (`airlab a`)

Run user-defined commands ("verbs") authored as plain `.sh` / `.py` scripts. Use it to turn a long `ansible-playbook` invocation, a multi-step recovery, or any local procedure into one short, tab-completable, shareable `airlab` command.

## Where aliases live

An alias is a `.sh` or `.py` file under one of the colon-separated directories in **`$AIRLAB_ALIAS_PATH`** (default: `$AIRLAB_PATH/alias`). The command name is the file path relative to its alias directory, with the extension dropped and folders kept as a slash-nested hierarchy:

```
$AIRLAB_ALIAS_PATH/fleet/build.sh        →  airlab a fleet/build
$AIRLAB_ALIAS_PATH/tools/report.py       →  airlab a tools/report
```

`$AIRLAB_ALIAS_PATH` is `$PATH`-style: searched left to right, first match wins. This lets a team ship shared aliases (e.g. in `airlab_ws/alias`) while an individual prepends a personal directory.

## Commands

| Command | Effect |
|---|---|
| `airlab a` | List every alias with its `@desc` and `@author`. |
| `airlab a <name>` | Run the alias (slash-nested path, no extension). |
| `airlab a <name> --help` | Forward `--help` to the alias (it prints its own usage). |
| `airlab a --new <name> [--py]` | Scaffold a new alias from the bundled template. |
| `airlab a --lint [PATH...]` | Check aliases satisfy the authoring contract (for CI). |
| `airlab a --help` | Show `airlab a`'s own help. |

## How an alias runs

- On the **local machine**, in the **caller's current directory**.
- With `airlab.env` and the airlab venv already active — so the alias can call other `airlab` verbs and read `$AIRLAB_PATH`.
- `.sh` runs under `bash`; `.py` runs under `python3` (the active venv).
- **Exit code is passed through.**
- **v1 forwards no arguments except `--help`/`-h`.** Argument passthrough (and per-alias argument completion) is deferred to a later version; passing other arguments is an error.
- Exported for the alias to use:
  - `AIRLAB_ALIAS_SELF` — absolute path to the alias file.
  - `AIRLAB_ALIAS_DIR` — the alias file's directory (find resources bundled beside it).
  - `AIRLAB_ALIAS_NAME` — the invoked name.

## Authoring contract

Every alias must declare two header comments and handle `--help`:

```bash
# @desc: one-line description (shown by 'airlab a')
# @author: Your Name <handle>
```

- `@desc` is shown in `airlab a`'s listing.
- `@author` records the owner so future changes can be PR-assigned to them.
- `--help` must print usage and exit 0.

Start from a compliant template with `airlab a --new <name>` (add `--py` for Python). `@author` is pre-filled from `git config user.name`.

### Linting / CI

`airlab a --lint [PATH...]` statically verifies each alias declares `@desc`, `@author`, and references `--help`. With no PATH it lints all of `$AIRLAB_ALIAS_PATH`; otherwise PATH may be directories or files. Exit status is non-zero if any alias fails.

The GitHub Action enforcing this belongs in the **repository that hosts the alias directory** (e.g. `airlab_ws`), not in the `airlab` tool repo. A minimal workflow runs `airlab a --lint <changed alias files>` on PRs to `main`.

## Resolution & collisions

The first `$AIRLAB_ALIAS_PATH` directory that owns a name wins (precedence). Within that directory, a name that resolves to **both** `.sh` and `.py`, or to both a file and a sub-directory, is a **collision**: `airlab a` reports it and refuses to run until disambiguated. A name that is only a directory is a "group", not runnable.

## Tab completion

`airlab a <TAB>` completes alias names from `$AIRLAB_ALIAS_PATH`: sub-groups are shown with a trailing `/`, leaf aliases with the extension stripped. Nested completion works (`airlab a fleet/<TAB>`).

## Example: wrap an Ansible play

`$AIRLAB_ALIAS_PATH/fleet/build.sh`:

```bash
#!/bin/bash
# @desc: build all ROS workspaces on this host (Ansible build play)
# @author: Yaoyu <yaoyuh-cmu>
case "${1:-}" in -h|--help) echo "Usage: airlab a fleet/build — build all workspaces"; exit 0 ;; esac
cd "$AIRLAB_PATH/scripts/ansible"
exec ansible-playbook playbooks/build.yml --limit "$(hostname)"
```

Now `airlab a fleet/build` runs the fleet build, and `airlab a fleet/build --help` prints its usage.
