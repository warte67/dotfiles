#!/bin/bash
#
# Enhanced Cross-Distro Update Script
# Author: Warte
# Purpose: Safe, automated system update with Timeshift backups
#

#==============================
# 🧩 COLOR DEFINITIONS
#==============================
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
VIOLET=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
GRAY=$(tput setaf 8)
RESET=$(tput sgr0)
BOLD=$(tput bold)

#==============================
# 🧠 SYSTEM INFO DETECTION
#==============================

USER_NAME="${USER}"
HOST_NAME="$(hostname)"
DISTRO="$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')"
KERNEL="$(uname -r)"
DESKTOP="${XDG_CURRENT_DESKTOP:-Unknown}"
CPU="$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | xargs)"

#=================================
# Package Manager Guard
#=================================

if ! command -v apt >/dev/null 2>&1; then
    echo ""
    echo "${YELLOW}Not applicable to ${DISTRO}.${RESET}"
    echo "${YELLOW}APT package manager not found.${RESET}"
    echo ""
    exit 0
fi

#==============================
# ✨ BANNER
#==============================
# clear
echo ""

echo "${WHITE}"
echo -e "      ████  ██████ ████  █  ████  ██████      "
echo -e "      █   █ █      █   █ █  █   █ █    █      ${GRAY}"
echo -e "      ██  █ ███    █████ ██ █████ ██   █      ${CYAN}"
echo -e "      ██  █ ██     ██  █ ██ ██  █ ██   █      ${BLUE}"
echo -e "      █████ ██████ █████ ██ ██  █ ██   █      ${WHITE}"
echo -e "                                              "
echo -e " █    █ █████ ████  ████  █████ ██████ █████  "
echo -e " █    █ █   █ █   █ █   █   █   █      █   █  ${GRAY}"
echo -e " ██   █ █████ ██  █ █████   ██  ███    ██████ ${CYAN}"
echo -e " ██   █ ██    ██  █ ██  █   ██  ██     ██   █ ${BLUE}"
echo -e " ██████ ██    █████ ██  █   ██  ██████ ██   █ ${WHITE}"
echo ""

echo -e "     ${BLUE}===========${CYAN}==============${BLUE}==========="
echo -e "     ${WHITE}     Debian Workstation Updater"
echo -e "     ${BLUE}===========${CYAN}==============${BLUE}==========="

echo ""
echo "${GREEN}User:${RESET}    ${USER_NAME}"
echo "${GREEN}Host:${RESET}    ${HOST_NAME}"
echo "${GREEN}Distro:${RESET}  ${DISTRO}"
echo "${GREEN}Kernel:${RESET}  ${KERNEL}"
echo "${GREEN}Desktop:${RESET} ${DESKTOP}"
echo "${GREEN}CPU:${RESET}     ${CPU}"
echo ""

APT_UPDATES=0
FLATPAK_UPDATES=0
SNAP_UPDATES=0
UPDATES_AVAILABLE=false
APT_UPDATES=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l)
# any apt updates?
if (( APT_UPDATES > 0 )); then
    UPDATES_AVAILABLE=true
fi
# any flatpak updates?
if command -v flatpak >/dev/null 2>&1; then
    FLATPAK_UPDATES=$(flatpak remote-ls --updates 2>/dev/null | wc -l)

    if (( FLATPAK_UPDATES > 0 )); then
        UPDATES_AVAILABLE=true
    fi
fi
# any snap updates?
if command -v snap >/dev/null 2>&1; then
    SNAP_UPDATES=$(snap refresh --list 2>/dev/null | tail -n +2 | wc -l)

    if (( SNAP_UPDATES > 0 )); then
        UPDATES_AVAILABLE=true
    fi
fi
# display
echo "${GREEN}APT Updates:${RESET}      ${APT_UPDATES}"
echo "${GREEN}Flatpak Updates:${RESET}  ${FLATPAK_UPDATES}"
echo "${GREEN}Snap Updates:${RESET}     ${SNAP_UPDATES}"
if ! $UPDATES_AVAILABLE; then
    echo ""
    echo "${WHITE}System is already up to date.${RESET}"
    exit 0
fi
sudo echo ""

echo ""
echo "${WHITE}     .-=≣=-.-=≣=-.-=≣=-.-=≣=-.-=≣=-.-=≣=-.${RESET}"

#==============================
# ✨ APT Updates
#==============================

echo ""
echo "${GREEN}≣ Updating APT Packages...${RESET}"
echo ""

sudo apt update
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y

#=================================
# Flatpak Updates
#=================================

if command -v flatpak >/dev/null 2>&1; then
    echo ""
    echo "${GREEN}≣ Updating Flatpaks...${RESET}"
    echo ""

    flatpak update -y
fi

#=================================
# Snap Updates
#=================================

if command -v snap >/dev/null 2>&1; then
    echo ""
    echo "${GREEN}≣ Updating Snaps...${RESET}"
    echo ""

    sudo snap refresh
fi

#==============================
# ✨ DONE AND DONE
#==============================

echo ""
echo "${GRAY}     .-=≣=-.-=≣=-.-=≣=-.-=≣=-.-=≣=-.-=≣=-.${RESET}"
echo "${WHITE}            System update complete!${RESET}"
echo "${GRAY}     .-=≣=-.-=≣=-.-=≣=-.-=≣=-.-=≣=-.-=≣=-.${RESET}"
