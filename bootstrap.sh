#!/usr/bin/env bash
# Reset
Color_Off='\033[0m' # Text Reset

# Regular Colors
Black='\033[0;30m'  # Black
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan
White='\033[0;37m'  # White

# Bold
BBlack='\033[1;30m'  # Black
BRed='\033[1;31m'    # Red
BGreen='\033[1;32m'  # Green
BYellow='\033[1;33m' # Yellow
BBlue='\033[1;34m'   # Blue
BPurple='\033[1;35m' # Purple
BCyan='\033[1;36m'   # Cyan
BWhite='\033[1;37m'  # White

has_pacman=false
has_brew=false
has_go=false
has_cargo=false
pkgs=()

echo_err() {
	echo -e "$@" 1>&2
}

if command -v pacman % >/dev/null; then
	has_pacman=true
fi

if command -v brew % >/dev/null; then
	has_brew=true
fi

if command -v go % >/dev/null; then
	has_go=true
fi

if command -v cargo % >/dev/null; then
	has_cargo=true
fi

if [ "$has_go" = false ]; then
	echo_err "${Red}Install Go then come back!${Color_Off}"
	exit 1
fi

if [ "$has_cargo" = false ]; then
	echo_err "${Red}Install cargo then come back!${Color_Off}"
	exit 1
fi

# CLI Tools
pkgs+=('bat' 'eza' 'git-delta' 'fd' 'dust' 'difftastic' 'hexyl' 'xh' 'atuin' 'fx' 'jless' 'xsv' 'ripgrep' 'fzf')
if [ "$has_brew" = true ]; then
	pkgs+=('gnu-sed')
fi

# Github CLI
if [ "$has_brew" = true ]; then
	pkgs+=('gh')
else
	pkgs+=('github-cli')
fi

# WASM
pkgs+=('wabt')

# Bash
# Both pacman and homebrew have the same package names
pkgs+=('shellcheck' 'bash-language-server' 'bash-completion' 'shfmt')

# Go
# Both pacman and homebrew have the same package names
pkgs+=('gofumpt' 'gopls')
go install 'golang.org/x/tools/cmd/goimports@latest'
go install 'github.com/go-delve/delve/cmd/dlv@latest'

# golangci-lint package is not available in pacman
if [ "$has_brew" = true ]; then
	pkgs+=('golangci-lint')
fi

if [ "$has_pacman" = true ]; then
	go install 'github.com/golangci/golangci-lint/cmd/golangci-lint@latest'
fi

# Lua
pkgs+=('stylua')

# Github Actions
if [ "$has_brew" = true ]; then
	pkgs+=('actionlint')
else
	go install github.com/rhysd/actionlint/cmd/actionlint@latest
fi

# Zig
pkgs+=('zig zls')

# Proto Buffers
pkgs+=('buf')

# Makefile
if [ "$has_brew" = true ]; then
	pkgs+=('checkmake')
else
	go install github.com/mrtazz/checkmake/cmd/checkmake@latest
fi

# .env
if [ "$has_brew" = true ]; then
	pkgs+=('dotenv-linter')
else
	cargo install dotenv-linter
fi

# Terraform
if [ "$has_brew" = true ]; then
	pkgs+=('tfsec')
else
	go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
fi

# Misspelling
pkgs+=('vale')
if [ "$has_brew" = true ]; then
	pkgs+=('typos-cli')
else
	pkgs+=('typos')
fi

# K8s stuff
if [ "$has_brew" = true ]; then
	pkgs+=('kubernetes-cli' 'krew')
else
	pkgs+=('kubectl')
fi

pkgs+=('helm' 'kubectx' 'k9s')

####
# Installing packages
####

if [ "$has_pacman" = true ]; then
	sudo pacman -Sy --needed "${pkgs[@]}"
fi

if [ "$has_brew" = true ]; then
	brew install "${pkgs[@]}"
fi

# Install krew on Arch (it's only available through AUR at the moment)
if [ "$has_pacman" = true ]; then
	set -x
	cd "$(mktemp -d)" &&
		OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
		ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
		KREW="krew-${OS}_${ARCH}" &&
		curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
		tar zxvf "${KREW}.tar.gz" &&
		./"${KREW}" install krew
fi
