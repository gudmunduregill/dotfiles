# Set tmux pane title to the current project name, then launch claude
claude() {
    if [ -n "$TMUX" ]; then
        local dir="$PWD" project=""
        if [ "$dir" != "$HOME" ]; then
            local check="$dir"
            while [ "$check" != "$HOME" ] && [ "$check" != "/" ]; do
                if [ -f "$check/CLAUDE.md" ]; then
                    project="$(basename "$check")"
                    break
                fi
                check="$(dirname "$check")"
            done
        fi
        printf '\033]2;%s\033\\' "${project:-claude}"
    fi
    command claude "$@"
}
