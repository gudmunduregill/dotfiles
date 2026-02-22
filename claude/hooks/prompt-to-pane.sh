#!/bin/bash
# Capture user prompt and display it in the tmux pane title
# Called by UserPromptSubmit hook

[ -z "$TMUX" ] && exit 0

INPUT=$(cat)

# Parse JSON without jq — extract .prompt and .cwd
PROMPT=$(echo "$INPUT" | grep -oP '"prompt"\s*:\s*"\K[^"]*')
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

# Clean up prompt: collapse whitespace, strip newlines
PROMPT=$(echo "$PROMPT" | tr '\n' ' ' | sed 's/  */ /g')

# Truncate prompt to fit in pane title
MAX_LEN=50
if [ ${#PROMPT} -gt $MAX_LEN ]; then
    PROMPT="${PROMPT:0:$MAX_LEN}…"
fi

tmux select-pane -T "$PROJECT | $PROMPT"
