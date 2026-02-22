#!/bin/bash
# Reset tmux pane title to just the project name when Claude finishes
# Called by Stop hook

[ -z "$TMUX" ] && exit 0

INPUT=$(cat)
CWD=$(echo "$INPUT" | grep -oP '"cwd"\s*:\s*"\K[^"]*')

# Determine project name (same logic as claude-pane.bash)
PROJECT=""
if [ -n "$CWD" ] && [ "$CWD" != "$HOME" ]; then
    CHECK="$CWD"
    while [ "$CHECK" != "$HOME" ] && [ "$CHECK" != "/" ]; do
        if [ -f "$CHECK/CLAUDE.md" ]; then
            PROJECT="$(basename "$CHECK")"
            break
        fi
        CHECK="$(dirname "$CHECK")"
    done
fi
PROJECT="${PROJECT:-claude}"

tmux select-pane -T "$PROJECT"
