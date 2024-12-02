#!/bin/bash

# Function to set colors for Bash
set_colors_bash() {
  #echo "set_colors_bash"

  RED     =$(tput setaf 1)
  GREEN   =$(tput setaf 2)
  YELLOW  =$(tput setaf 3)
  BLUE    =$(tput setaf 4)
  MAGENTA =$(tput setaf 5)
  CYAN    =$(tput setaf 6)
  WHITE   =$(tput setaf 7)
  RESET   =$(tput sgr0)
}

# Function to set colors for Fish
set_colors_fish() {
  #echo "set_colors_fish"

  set RED     $(tput setaf 1)
  set GREEN   $(tput setaf 2)
  set YELLOW  $(tput setaf 3)
  set BLUE    $(tput setaf 4)
  set MAGENTA $(tput setaf 5)
  set CYAN    $(tput setaf 6)
  set WHITE   $(tput setaf 7)
  set RESET   $(tput sgr0)
}

# Set colors based on the shell
if [[ "$SHELL" == *"bash"* ]]; then
  set_colors_bash
elif [[ "$SHELL" == *"fish"* ]]; then
  set_colors_fish
fi

## Ensure the 32-bit stuff is good to go for steam
#sudo dpkg --add-architecture i386

# Ensure admin privileges
sudo echo

# apt is present?
if command -v apt &> /dev/null; then
  echo $GREEN"<<<"$BLUE"===== "$WHITE" UPDATING APTS"$BLUE" ====="$GREEN">>>"$RESET
  echo ""
  echo $YELLOW" sudo apt update"$RESET
  echo ""
  sudo apt update
  echo ""
  echo $GREEN"<<<"$BLUE"===== "$WHITE" UPGRADING APTS"$BLUE" ====="$GREEN">>>"$RESET
  echo ""
  echo $YELLOW" sudo apt upgrade -y"$RESET
  echo ""
  sudo apt upgrade -y
  echo ""
fi

# pacman is present
if command -v pacman &> /dev/null; then
  echo $GREEN"<<<"$BLUE"===== "$WHITE"UPDATING PACMAN"$BLUE "====="$GREEN">>>"$RESET
  echo ""
  echo $YELLOW" sudo pacman -Syu "$RESET
  echo ""
  sudo pacman -Syu
  echo ""
fi

# yay is present
if command -v yay &> /dev/null; then
  echo "$GREEN<<<$BLUE===== $WHITE UPDATING YAY$BLUE ==== $GREEN >>>$RESET"
  echo ""
  echo "$YELLOW yay -Syu $RESET"
  echo ""
  yay -Syu
  echo ""
elif command -v paru &> /dev/null; then
  echo "$GREEN<<<$BLUE===== $WHITE UPDATING PARU$BLUE ==== $GREEN >>>$RESET"
  echo ""
  echo "$YELLOW paru -Syu $RESET"
  echo ""
  paru -Syu
  echo ""
fi

# flatpak is installed?
if command -v flatpak &> /dev/null; then
  echo "$GREEN<<$BLUE== $WHITE UPDATING FLATPAKS $BLUE ==$GREEN>>$RESET"
  echo ""
  echo "$YELLOW sudo flatpak update -y$RESET"
  echo ""
  sudo flatpak update -y
  echo ""
else
  echo "$GREEN<<<$BLUE=== $WHITE FLATPAK IS NOT INSTALLED $BLUE ===$GREEN >>>$RESET"
  echo ""
fi

# sudo snap refresh
if command -v snap &> /dev/null; then
  echo "$GREEN<<<$BLUE=== $WHITE UPDATING SNAPS $BLUE ===$GREEN >>>$RESET"
  echo ""
  echo "$YELLOW sudo snap refresh$RESET"
  echo ""
  sudo snap refresh --list
  sudo snap refresh
  echo ""
else
  echo "$GREEN<<<$BLUE=== $WHITE SNAP IS NOT INSTALLED $BLUE ===$GREEN >>>$RESET"
  echo ""
  echo "$YELLOW Skipping 'sudo snap refresh'...$RESET"
  echo ""
fi

# Continue with the rest of the script
echo "Update Complete..."
