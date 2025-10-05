```
stow --target="$HOME" --dir="$HOME/projects/smirzaei/dotfiles" .

# Nix
# Update private flakes
nix flake lock --update-input private

# Apply home manager config
home-manager switch --flake .#soroush
```
