# Zsh shell function wrapper for airlab.
# Sourced from ~/.zshrc to enable "airlab cd" (which must run in the current shell).
#
# Installed to /etc/airlab/airlab.zsh

airlab() {
    if [[ "${1:-}" == "cd" ]]; then
        shift
        local target="${AIRLAB_PATH:-}"
        if [[ -z "$target" ]]; then
            echo "Error: AIRLAB_PATH is not set. Run 'airlab setup local' first." >&2
            return 1
        fi
        if [[ "$1" == "--help" || "$1" == "-h" ]]; then
            echo "Usage: airlab cd [path]"
            echo ""
            echo "Change directory to a path relative to \$AIRLAB_PATH ($AIRLAB_PATH)."
            echo ""
            echo "  airlab cd              # cd to \$AIRLAB_PATH"
            echo "  airlab cd docker       # cd to \$AIRLAB_PATH/docker"
            echo "  airlab cd robot        # cd to \$AIRLAB_PATH/robot"
            return 0
        fi
        if [[ -n "$1" ]]; then
            target="$target/$1"
        fi
        builtin cd "$target"
    else
        command airlab "$@"
    fi
}
