```
stow --target="$HOME" --dir="$HOME/projects/smirzaei/dotfiles" .

# Nix
# Update all
nix flake update

# Update private flakes
nix flake update private

# Apply home manager config
home-manager switch --flake .#soroush
```
