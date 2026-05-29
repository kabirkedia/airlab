#!/bin/bash
# @desc: ONE-LINE description of what this alias does (shown by 'airlab a')
# @author: {{AUTHOR}}
#
# airlab alias: {{NAME}}
# Run as:  airlab a {{NAME}}
#
# Runs locally, in the caller's PWD, with airlab.env + the airlab venv active.
# Available: $AIRLAB_ALIAS_SELF, $AIRLAB_ALIAS_DIR, $AIRLAB_ALIAS_NAME.
# Note: v1 forwards no arguments except --help.

set -euo pipefail

show_help() {
    cat << EOF
Usage: airlab a {{NAME}}

<Describe what this alias does, and any prerequisites.>
EOF
}

case "${1:-}" in
    -h|--help) show_help; exit 0 ;;
esac

# ---- your commands below ----
# Example: wrap an Ansible play so operators don't type ansible-playbook.
# cd "$AIRLAB_PATH/scripts/ansible"
# exec ansible-playbook playbooks/build.yml --limit dtc-rog-old

echo "TODO: implement the {{NAME}} alias"
