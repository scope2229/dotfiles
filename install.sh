echo "Install ~/.bash_aliases..."
if [ ! -f "${HOME}/.bash_aliases" ]; then
    touch "${HOME}/.bash_aliases"
    echo "Created ~/.bash_aliases"
else
    echo "Replacing contents of ~/.bash_aliases"
fi

cat ~/dotfiles/bash/aliases > "${HOME}/.bash_aliases"

echo "Install snippets for vscode..."
# Define the target directory for VSCode snippets
VSCODE_SETTINGS_DIR="/workspace/.vscode"

# Check if the directory exists, if not create it
if [ ! -d "$VSCODE_SETTINGS_DIR" ]; then
    mkdir -p "$VSCODE_SETTINGS_DIR"
fi

# Copy each file from the dotfiles snippets directory to the VSCode snippets directory
for file in ~/dotfiles/vscode/snippets/*; then
    cp "$file" "$VSCODE_SETTINGS_DIR/"
done

echo "VSCode snippets installed successfully!"

echo "Install settings for vscode..."
cp ~/dotfiles/vscode/settings.json "$VSCODE_SETTINGS_DIR/"
cp ~/dotfiles/vscode/keybindings.json "$VSCODE_SETTINGS_DIR/"

echo "setup git user"

# Take specific section and append to ~/.gitconfig
# grep -A 2 '\[user\]' ~/dotfiles/gitconfig >> ~/.gitconfig

# Copy whole file and append to ~/.gitconfig
cat ~/dotfiles/gitconfig >> ~/.gitconfig


# VSCODE extensions
echo "Install vscode extensions..."
code --install-extension karunamurti.rspec-snippets
