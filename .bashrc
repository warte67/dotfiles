# ~/.bashrc: Customized Bash Configuration File

# 1. Check if not running interactively, exit
[ -z "$PS1" ] && return

# 2. History Settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups  # No duplicate entries
HISTIGNORE="ls:cd:cd -:pwd:exit:clear"  # Ignore common commands
shopt -s histappend               # Append to history, don't overwrite

# 3. Alias Definitions
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias gs='git status'
alias gf='git fetch'
alias gp='git pull'
#alias update='sudo pacman -Syu'
#alias upgrade='sudo pacman -Syu --noconfirm'
alias c='clear'
alias v='kate'  # Replace with your preferred editor
alias ..='cd ..'
alias ...='cd ../..'

# 4. Prompt Customization
PS1='\[\033[1;34m\]\u@\h\[\033[0m\]:\[\033[1;32m\]\w\[\033[0m\]$ '

# 5. Color Support for `ls` and Other Commands
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# 6. Path Enhancements
# Ensure ~/.local/bin exists and is added to PATH if not already present
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# 7. Convenient Functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *.xz) tar xf "$1" ;;
            *) echo "Cannot extract $1: unknown file type" ;;
        esac
    else
        echo "$1 is not a valid file"
    fi
}

# 8. Enable Autojump (if installed)
if command -v autojump > /dev/null 2>&1; then
    . /usr/share/autojump/autojump.sh
fi

# 9. Custom PS1 with Git Support (if `git` is installed)
if command -v git > /dev/null 2>&1; then
    git_branch() {
        branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
        [ -n "$branch" ] && echo " ($branch)"
    }
    PS1='\[\033[1;34m\]\u@\h\[\033[0m\]:\[\033[1;32m\]\w\[\033[0;33m\]$(git_branch)\[\033[0m\]$ '
fi

# 10. Source User-Specific Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# 11. Performance Tweaks
export EDITOR="nano"  # Replace with your preferred editor
export PAGER="less"
export LESS="-R"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Starship Prompt
#
# available colors:  blue, green, red, violet, brown, teal, purple, olive, gray, or default
#
# sed -i 's/^palette = .*/palette = "blue"/' test.toml
STARSHIP_TOML="$HOME/.config/starship.toml"
if [[ "$(hostname)" == "coffee-table" ]]; then
    sed -i 's/^palette = .*/palette = "teal"/' $STARSHIP_TOML
elif [[ "$(hostname)" == "framework" ]]; then
    sed -i 's/^palette = .*/palette = "olive"/' $STARSHIP_TOML
elif [[ "$(hostname)" == "tux" ]]; then
    sed -i 's/^palette = .*/palette = "purple"/' $STARSHIP_TOML
else
    sed -i 's/^palette = .*/palette = "gray"/' $STARSHIP_TOML
fi
eval "$(starship init bash)"

