# ~/.bashrc: Customized Bash Configuration File
#
#         $$\                           $$\
#         $$ |                          $$ |
#         $$$$$$$\   $$$$$$\   $$$$$$$\ $$$$$$$\   $$$$$$\   $$$$$$$\
#         $$  __$$\  \____$$\ $$  _____|$$  __$$\ $$  __$$\ $$  _____|
#         $$ |  $$ | $$$$$$$ |\$$$$$$\  $$ |  $$ |$$ |  \__|$$ /
#         $$ |  $$ |$$  __$$ | \____$$\ $$ |  $$ |$$ |      $$ |
#     $$\ $$$$$$$  |\$$$$$$$ |$$$$$$$  |$$ |  $$ |$$ |      \$$$$$$$\
#     \__|\_______/  \_______|\_______/ \__|  \__|\__|       \_______|
#
#
#
#  Check if not running interactively, exit
[ -z "$PS1" ] && return


#    ______                _   _
#   |  ____|              | | (_)
#   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
#   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#

function work() {
    # Define the target directory and repository URL
    TARGET_DIR="$HOME/Documents/GitHub/alpha_6809"
    REPO_URL="https://github.com/warte67/alpha_6809"

    # Check if Git is installed
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Trying to install it..."

        # Check for the availability of package managers
        if command -v pacman &> /dev/null; then
            echo "Installing Git using pacman (Arch-based system)..."
            sudo pacman -S --noconfirm git || { echo "Failed to install Git using pacman. Exiting."; return 1; }
        elif command -v apt &> /dev/null; then
            echo "Installing Git using apt (Debian/Ubuntu-based system)..."
            sudo apt update && sudo apt install -y git || { echo "Failed to install Git using apt. Exiting."; return 1; }
        elif command -v dnf &> /dev/null; then
            echo "Installing Git using dnf (Fedora-based system)..."
            sudo dnf install -y git || { echo "Failed to install Git using dnf. Exiting."; return 1; }
        else
            echo "No supported package manager found. Please install Git manually."
            return 1
        fi
    fi
    # Check if the target directory exists
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Target directory $TARGET_DIR does not exist. Cloning repository..."
        git clone "$REPO_URL" "$TARGET_DIR" || { echo "Failed to clone repository. Exiting."; return 1; }
    fi

    # Ensure the directory is a Git repository
    if [ ! -d "$TARGET_DIR/.git" ]; then
        echo "Target directory exists but is not a Git repository. Initializing and linking to remote..."
        cd "$TARGET_DIR" || { echo "Failed to change directory to $TARGET_DIR. Exiting."; return 1; }
        git init
        git remote add origin "$REPO_URL"
        git fetch || { echo "Failed to fetch repository. Exiting."; return 1; }
        git reset --hard origin/master || { echo "Failed to reset repository to origin/master. Exiting."; return 1; }
    else
        echo "Target directory exists and is a valid Git repository."
        cd "$TARGET_DIR" || { echo "Failed to change directory to $TARGET_DIR. Exiting."; return 1; }
    fi
    # Pull the latest changes from the repository
    echo "Pulling the latest changes from the repository..."
    git pull || { echo "Failed to pull changes from the repository. Exiting."; return 1; }
}



# function work() {
#     # Define the target directory and repository URL
#     TARGET_DIR="$HOME/Documents/GitHub/retro_6809"
#     REPO_URL="https://github.com/warte67/retro_6809"
#
#     # Check if the current directory is not the target directory
#     if [ "$(pwd)" != "$(realpath "$TARGET_DIR")" ]; then
#         echo "Current directory is not $TARGET_DIR. Changing directory..."
#         cd "$TARGET_DIR" || {
#             echo "Failed to change directory to $TARGET_DIR."
#             echo "Please Clone the REPO_URL from GitHub-Desktop."
#             echo "Exiting."; exit 1;
#         }
#     else
#         echo "Already in the target directory $TARGET_DIR."
#     fi
#
#     # Pull the latest changes from the repository
#     echo "Pulling the latest changes from the repository..."
#     git pull "$REPO_URL"
# }






#   _    _ _     _                      _____      _   _   _
#  | |  | (_)   | |                    / ____|    | | | | (_)
#  | |__| |_ ___| |_ ___  _ __ _   _  | (___   ___| |_| |_ _ _ __   __ _ ___
#  |  __  | / __| __/ _ \| '__| | | |  \___ \ / _ \ __| __| | '_ \ / _` / __|
#  | |  | | \__ \ || (_) | |  | |_| |  ____) |  __/ |_| |_| | | | | (_| \__ \
#  |_|  |_|_|___/\__\___/|_|   \__, | |_____/ \___|\__|\__|_|_| |_|\__, |___/
#                               __/ |                               __/ |
#                              |___/                               |___/
#  History Settings
#
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups        # No duplicate entries
HISTIGNORE="ls:cd:cd -:pwd:exit:clear"  # Ignore common commands
shopt -s histappend                     # Append to history, don't overwrite


#            _ _             _____        __ _       _ _   _
#      /\   | (_)           |  __ \      / _(_)     (_) | (_)
#     /  \  | |_  __ _ ___  | |  | | ___| |_ _ _ __  _| |_ _  ___  _ __  ___
#    / /\ \ | | |/ _` / __| | |  | |/ _ \  _| | '_ \| | __| |/ _ \| '_ \/ __|
#   / ____ \| | | (_| \__ \ | |__| |  __/ | | | | | | | |_| | (_) | | | \__ \
#  /_/    \_\_|_|\__,_|___/ |_____/ \___|_| |_|_| |_|_|\__|_|\___/|_| |_|___/
#
#  Alias Definitions
#
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias gs='git status'
alias gf='git fetch'
alias gp='git pull'
alias c='clear'
alias v='kate'  # Override in .bash_aliases
alias ..='cd ..'
alias ...='cd ../..'
# Source User-Specific Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


#   _____        __            _ _     _____                           _
#  |  __ \      / _|          | | |   |  __ \                         | |
#  | |  | | ___| |_ __ _ _   _| | |_  | |__) | __ ___  _ __ ___  _ __ | |_
#  | |  | |/ _ \  _/ _` | | | | | __| |  ___/ '__/ _ \| '_ ` _ \| '_ \| __|
#  | |__| |  __/ || (_| | |_| | | |_  | |   | | | (_) | | | | | | |_) | |_
#  |_____/ \___|_| \__,_|\__,_|_|\__| |_|   |_|  \___/|_| |_| |_| .__/ \__|
#                                                               | |
#                                                               |_|
#  Default Prompt Customization
#
PS1='\[\033[1;34m\]\u@\h\[\033[0m\]:\[\033[1;32m\]\w\[\033[0m\]$ '


# Color Support for `ls` and Other Commands
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


#   _____      _   _       ______       _                                               _
#  |  __ \    | | | |     |  ____|     | |                                             | |
#  | |__) |_ _| |_| |__   | |__   _ __ | |__   __ _ _ __   ___ ___ _ __ ___   ___ _ __ | |_
#  |  ___/ _` | __| '_ \  |  __| | '_ \| '_ \ / _` | '_ \ / __/ _ \ '_ ` _ \ / _ \ '_ \| __|
#  | |  | (_| | |_| | | | | |____| | | | | | | (_| | | | | (_|  __/ | | | | |  __/ | | | |_
#  |_|   \__,_|\__|_| |_| |______|_| |_|_| |_|\__,_|_| |_|\___\___|_| |_| |_|\___|_| |_|\__|
#
#  Path Enhancement
#
# Ensure ~/.local/bin exists and is added to PATH if not already present
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
# Custom PS1 with Git Support (if `git` is installed)
if command -v git > /dev/null 2>&1; then
    git_branch() {
        branch=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
        [ -n "$branch" ] && echo " ($branch)"
    }
    PS1='\[\033[1;34m\]\u@\h\[\033[0m\]:\[\033[1;32m\]\w\[\033[0;33m\]$(git_branch)\[\033[0m\]$ '
fi


#    _____                 _            _            _     ______                _   _
#   / ____|               (_)          (_)          | |   |  ____|              | | (_)
#  | |     ___  _ ____   ___  ___ _ __  _  ___ _ __ | |_  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
#  | |    / _ \| '_ \ \ / / |/ _ \ '_ \| |/ _ \ '_ \| __| |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  | |___| (_) | | | \ V /| |  __/ | | | |  __/ | | | |_  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#   \_____\___/|_| |_|\_/ |_|\___|_| |_|_|\___|_| |_|\__| |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#
#  Convenient Functions
#
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


#   _____           __                                            _______                 _
#  |  __ \         / _|                                          |__   __|               | |
#  | |__) |__ _ __| |_ ___  _ __ _ __ ___   __ _ _ __   ___ ___     | |_      _____  __ _| | _____
#  |  ___/ _ \ '__|  _/ _ \| '__| '_ ` _ \ / _` | '_ \ / __/ _ \    | \ \ /\ / / _ \/ _` | |/ / __|
#  | |  |  __/ |  | || (_) | |  | | | | | | (_| | | | | (_|  __/    | |\ V  V /  __/ (_| |   <\__ \
#  |_|   \___|_|  |_| \___/|_|  |_| |_| |_|\__,_|_| |_|\___\___|    |_| \_/\_/ \___|\__,_|_|\_\___/
#
#  Performance Tweaks
#
export EDITOR="nano"  # Replace with your preferred editor
export PAGER="less"
export LESS="-R"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi


##################################################################################
#   ____  _                 _     _         ____                            _    #
#  / ___|| |_ __ _ _ __ ___| |__ (_)_ __   |  _ \ _ __ ___  _ __ ___  _ __ | |_  #
#  \___ \| __/ _` | '__/ __| '_ \| | '_ \  | |_) | '__/ _ \| '_ ` _ \| '_ \| __| #
#   ___) | || (_| | |  \__ \ | | | | |_) | |  __/| | | (_) | | | | | | |_) | |_  #
#  |____/ \__\__,_|_|  |___/_| |_|_| .__/  |_|   |_|  \___/|_| |_| |_| .__/ \__| #
#                                  |_|                               |_|         #
#                                                                                #
# Available Colors:                                                              #
#   blue, green, red, violet, brown, teal, purple, olive, gray, or default       #
#                                                                                #
##################################################################################
if command -v starship > /dev/null 2>&1; then
    STARSHIP_TOML="$HOME/.config/starship.toml"
    if [[ "$(hostname)" == "coffee-table" ]]; then
        sed -i 's/^palette = .*/palette = "blue"/' $STARSHIP_TOML

    elif [[ "$(hostname)" == "framework" ]]; then
        sed -i 's/^palette = .*/palette = "teal"/' $STARSHIP_TOML

    elif [[ "$(hostname)" == "tux" ]]; then
        sed -i 's/^palette = .*/palette = "olive"/' $STARSHIP_TOML

    elif [[ "$(hostname)" == "Mint22-vm" ]]; then
        sed -i 's/^palette = .*/palette = "green"/' $STARSHIP_TOML

    elif [[ "$(hostname)" == "debian" ]]; then
        sed -i 's/^palette = .*/palette = "brown"/' $STARSHIP_TOML

    else
        sed -i 's/^palette = .*/palette = "gray"/' $STARSHIP_TOML
    fi
    eval "$(starship init bash)"
fi


