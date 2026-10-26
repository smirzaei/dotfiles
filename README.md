```
# Nix
# Update all
nix flake update

# Update private flakes
nix flake update private

# Update agents
nix flake update agents

# Arch: install native applications, Git/SSH clients, and editor tools
sudo pacman -S --needed \
  alacritty ghostty neovim opencode tmux zed \
  git git-lfs gnupg openssh \
  buf golangci-lint gopls tree-sitter-cli

# Apply home manager config
home-manager switch --flake .#soroush
```
