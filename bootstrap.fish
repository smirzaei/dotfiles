# Install Fisher
# Don't just blindly run it, check the content first!
echo "Installing fisher..."
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# fzf
# https://github.com/PatrickF1/fzf.fish
echo "Installing fzf.fish"
fisher install PatrickF1/fzf.fish
