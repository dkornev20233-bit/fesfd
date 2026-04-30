#!/usr/bin/env bash

r="\033[0m";g="\033[32m";y="\033[33m";b="\033[34m";r2="\033[31m"

log(){ echo -e "${g}[+]${r} $1"; }
warn(){ echo -e "${y}[!]${r} $1"; }
err(){ echo -e "${r2}[-]${r} $1"; }

pm=""

if command -v pacman >/dev/null 2>&1; then pm="pacman"
elif command -v apt >/dev/null 2>&1; then pm="apt"
elif command -v dnf >/dev/null 2>&1; then pm="dnf"
fi

install(){
  log "installing $*"
  case $pm in
    pacman) sudo pacman -Sy --noconfirm $* ;;
    apt) sudo apt update && sudo apt install -y $* ;;
    dnf) sudo dnf install -y $* ;;
    *) err "no package manager"; exit 1 ;;
  esac
}

log "checking zsh"
command -v zsh >/dev/null 2>&1 || install zsh
command -v git >/dev/null 2>&1 || install git
command -v curl >/dev/null 2>&1 || install curl

log "installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  warn "oh-my-zsh already exists"
fi

log "configuring zshrc"

cp "$HOME/.zshrc" "$HOME/.zshrc.bak_$(date +%s)" 2>/dev/null

cat > "$HOME/.zshrc" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)

source $ZSH/oh-my-zsh.sh

parse_git(){
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  b=$(git branch --show-current 2>/dev/null)
  [ -z "$b" ] && b="detached"
  echo "[$b]"
}

PROMPT='%n@%m %~ $(parse_git) ~> '
EOF

log "changing default shell"
chsh -s "$(which zsh)" "$USER" 2>/dev/null || warn "chsh failed (run manually)"

log "done. restart terminal"
