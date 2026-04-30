#!/bin/bash

ZSHRC="$HOME/.zshrc"

grep -q 'DebianHuinya' "$ZSHRC" && exit 0

cat >> "$ZSHRC" << 'EOF'

# custom prompt
PROMPT="DebianHuinya %~ ~> "
EOF

exec zsh -i
