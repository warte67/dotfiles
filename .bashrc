# ~/.bashrc: This file is sourced by bash for interactive shells.
#
#      $$\                           $$\
#      $$ |                          $$ |
#      $$$$$$$\   $$$$$$\   $$$$$$$\ $$$$$$$\   $$$$$$\   $$$$$$$\
#      $$  __$$\  \____$$\ $$  _____|$$  __$$\ $$  __$$\ $$  _____|
#      $$ |  $$ | $$$$$$$ |\$$$$$$\  $$ |  $$ |$$ |  \__|$$ /
#      $$ |  $$ |$$  __$$ | \____$$\ $$ |  $$ |$$ |      $$ |
#  $$\ $$$$$$$  |\$$$$$$$ |$$$$$$$  |$$ |  $$ |$$ |      \$$$$$$$\
#  \__|\_______/  \_______|\_______/ \__|  \__|\__|       \_______|
#

# Neofetch
# Run neofetch if it is installed
if command -v neofetch &> /dev/null; then
    neofetch
fi

# Ensure the terminal supports color
force_color_prompt=yes

# Color prompt settings (adjust as needed)
if [[ -n "$force_color_prompt" ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Enable command history search with Up/Down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Alias definitions for common commands
alias ll='ls -lah'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -lFh'
alias update='sudo pacman -Syu'

# Enable completion features (tab completion, etc.)
shopt -s histappend       # Append to history, don't overwrite it
shopt -s cmdhist          # Save multi-line commands as one entry in history

# Make history immediately available for new shells
PROMPT_COMMAND="history -a; history -n"

# Set history size
HISTSIZE=10000             # Number of commands to save in history
HISTFILESIZE=10000         # Number of commands to save in history file

# Auto-complete commands with a case-insensitive match
bind "set completion-ignore-case On"

# Set default editor (useful for editing files with commands like `crontab`)
export EDITOR=nano

# Set up the path to include local binaries (useful for user-installed software)
# Add ~/.local/bin to PATH if it exists and isn't already in the PATH
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Customizable environment variables for your system
export LANG="en_US.UTF-8"
export TERM="xterm-256color"
export VISUAL=kate
export EDITOR=kate

# Set up `ls` aliases for better listing formats
alias ll='ls -lFh --color=auto'
alias la='ls -A --color=auto'

# Enable automatic updates for the shell prompt
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Custom prompt (with colors)
PS1="\[\033[01;34m\]\u@\h\[\033[00m\] \[\033[01;32m\]\w\[\033[00m\] \$ "

# Make sure the terminal supports utf-8
export LANG=en_US.UTF-8

# Useful for editing commands with long lines, enabling a multiline prompt:
shopt -s cmdhist
shopt -s lithist

# Autocd: Allows you to change directories just by typing the directory name.
shopt -s autocd

# Auto-correct typos for common commands
shopt -s cdspell
shopt -s dirspell

# Set history options
export HISTCONTROL=ignoredups:erasedups  # Ignore duplicate commands
export HISTIGNORE="ls:cd:cd ~:pwd"       # Don't save common commands to history

# Starship Prompt
eval "$(starship init bash)"
