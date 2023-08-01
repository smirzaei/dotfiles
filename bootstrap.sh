#!/usr/bin/env bash
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

has_pacman=false
has_brew=false
has_go=false
has_cargo=false
pkgs=()
go_pkgs=()

echo_err() {
  echo -e "$@" 1>&2;
}

if command -v pacman %> /dev/null
then
  has_pacman=true
fi

if command -v brew %> /dev/null
then
  has_brew=true
fi


if command -v go %> /dev/null
then
  has_go=true
fi

if command -v cargo %> /dev/null
then
  has_cargo=true
fi
# sudo pacman -S --needed --noconfirm "${test_pkgs[@]}"

if [ "$has_go" = false ]
then
  echo_err "${Red}Install Go then come back!${Color_Off}"
  exit 1
fi


if [ "$has_cargo" = false ]
then
  echo_err "${Red}Install cargo then come back!${Color_Off}"
  exit 1
fi

# Bash
# Both pacman and homebrew have the same package names
pkgs+=('shellcheck' 'bash-language-server' 'bash-completion' 'shfmt')

# Go
# Both pacman and homebrew have the same package names
pkgs+=('gofumpt' 'gopls')
go_pkgs+=('golang.org/x/tools/cmd/goimports@latest')

# Lua
pkgs+=('stylua')

####
# Installing packages
####

if [ "$has_pacman" = true ]; then
  sudo pacman -Sy --needed --noconfirm "${pkgs[@]}"
fi

if [ "$has_brew" = true ]; then
  brew install "${pkgs[@]}"
fi

go install "${go_pkgs[@]}"
