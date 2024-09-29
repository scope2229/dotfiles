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
VSCODE_SNIPPETS_DIR="$HOME/.config/Code/User/snippets"

# Check if the directory exists, if not create it
if [ ! -d "$VSCODE_SNIPPETS_DIR" ]; then
    mkdir -p "$VSCODE_SNIPPETS_DIR"
fi

# Copy the html.json file from the dotfiles repo to the VSCode snippets directory
cp ~/dotfiles/vscode/snippets/html.json "$VSCODE_SNIPPETS_DIR/"

echo "HTML snippets installed successfully!"
