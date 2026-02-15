# Auto-tag tmux pane when launching claude
# Uses Catppuccin Mocha palette (dark background tints)
claude() {
    if [ -n "$TMUX" ]; then
        local dir="$PWD"

        if [ "$dir" = "$HOME" ]; then
            tmux select-pane -T "CORE"
            tmux select-pane -P "bg=default"
        else
            # Walk up to find the nearest CLAUDE.md (stop before ~)
            local check="$dir"
            local project=""
            while [ "$check" != "$HOME" ] && [ "$check" != "/" ]; do
                if [ -f "$check/CLAUDE.md" ]; then
                    project="$(basename "$check")"
                    break
                fi
                check="$(dirname "$check")"
            done

            if [ -n "$project" ]; then
                # Assign a Catppuccin Mocha accent color per project
                # Dark background tints so text stays readable
                local -A catppuccin_bg=(
                    [mauve]="#2a1f3a"
                    [red]="#3a1f25"
                    [peach]="#3a2a1f"
                    [green]="#1f3a1f"
                    [teal]="#1f3a35"
                    [blue]="#1f2a3a"
                    [lavender]="#252a3a"
                    [pink]="#3a1f30"
                )
                local colors=(mauve red peach green teal blue lavender pink)

                # Stable hash (djb2-style): distribute projects across colors
                local hash=0
                local i
                for (( i=0; i<${#project}; i++ )); do
                    hash=$(( (hash * 31 + $(printf '%d' "'${project:$i:1}")) % 100003 ))
                done
                local idx=$(( hash % ${#colors[@]} ))
                local chosen="${colors[$idx]}"

                tmux select-pane -T "$project"
                tmux select-pane -P "bg=${catppuccin_bg[$chosen]}"
            fi
        fi
    fi

    command claude "$@"
}
