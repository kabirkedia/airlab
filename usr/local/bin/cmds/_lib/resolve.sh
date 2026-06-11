#!/usr/bin/env bash
# Shared SSH-address resolution for airlab commands.
#
# Source this from a command:  source "$(dirname "$0")/_lib/resolve.sh"
# Requires AIRLAB_PATH to be set.
#
# resolve_ssh_address <system> [address_name]
#   Prefers the target registry (robots.yaml via robots.py, which supports named
#   addresses like internet/vpn); falls back to robot.conf — the bare name, or
#   "<name>-<address>" for the legacy -internet convention — so behavior is
#   unchanged when robots.yaml is absent. Prints the ssh target:
#     no port -> user@host        w/ port -> ssh://user@host:port
resolve_ssh_address() {
    local name="$1" address="${2:-}"
    local robots_py="$AIRLAB_PATH/robot/robots.py"
    local robot_conf="$AIRLAB_PATH/robot/robot.conf"
    local out
    if [[ -f "$robots_py" ]]; then
        if [[ -n "$address" ]]; then
            out=$(python3 "$robots_py" resolve "$name" --address "$address" 2>/dev/null)
        else
            out=$(python3 "$robots_py" resolve "$name" 2>/dev/null)
        fi
        if [[ -n "$out" ]]; then echo "$out"; return 0; fi
    fi
    local key="$name"
    [[ -n "$address" ]] && key="${name}-${address}"
    grep "^${key}=" "$robot_conf" 2>/dev/null | cut -d= -f2
}
