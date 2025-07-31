#!/bin/bash
# ~/.claude/hooks/slack-notify-only.sh

read -r input
session_id=$(echo "$input" | jq -r '.session_id')
tool_name=$(echo "$input" | jq -r '.tool_name')
command=$(echo "$input" | jq -r '.tool_input.command')
echo "$(date '+%Y-%m-%d %H:%M:%S') - Claude ran command: $tool_name - $command" >> ~/.claude/hooks/claude-events.log
echo '{"continue": true}'
