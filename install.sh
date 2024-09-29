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
VSCODE_SNIPPETS_DIR="/workspace/.vscode"

# Check if the directory exists, if not create it
if [ ! -d "$VSCODE_SNIPPETS_DIR" ]; then
    mkdir -p "$VSCODE_SNIPPETS_DIR"
fi

# Copy each file from the dotfiles snippets directory to the VSCode snippets directory
for file in ~/dotfiles/vscode/snippets/*; then
    cp "$file" "$VSCODE_SNIPPETS_DIR/"
done

echo "VSCode snippets installed successfully!"
