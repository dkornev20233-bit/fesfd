#!/bin/bash

ZSHRC="$HOME/.zshrc"

if ! grep -q "DebianHuinya" "$ZSHRC"; then
cat >> "$ZSHRC" << 'EOF'

# custom prompt
PROMPT="DebianHuinya %~ ~> "
EOF
fi

# применяем сразу если ты в zsh
if [ -n "$ZSH_VERSION" ]; then
  source "$ZSHRC"
else
  exec zsh
fi
