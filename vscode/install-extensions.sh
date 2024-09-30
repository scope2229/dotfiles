# Use this script to manually install extensions for VSCode after the container is running
# This script is not called by the main install.sh script

echo "Installing VSCode Extensions..."
cp $HOME/dotfiles/vscode/extensions.json "/workspace/.vscode/"

export code="$(ls $HOME/.vscode-server/bin/*/bin/code-server* | head -n 1)"
while read -r EX; do
    echo "Installing extension: $EX"
    $code --install-extension "$EX"
done < "$HOME/dotfiles/vscode/extensions.list"

echo "VSCode Extensions installed successfully!"
