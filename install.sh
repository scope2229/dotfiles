# Define the target directories VSCode
VSCODE_SETTINGS_DIR="/workspace/.vscode"
DOTFILES_ROOT_DIR="${HOME}/dotfiles"
DOTFILES_BASH_DIR="${DOTFILES_ROOT_DIR}/bash"
DOTFILES_VSCODE_DIR="${DOTFILES_ROOT_DIR}/vscode"

echo "Install ~/.bash_aliases... ${PWD} DIRECTORY ${HOME}"
if [ ! -f "${HOME}/.bash_aliases" ]; then
    touch "${HOME}/.bash_aliases"
    echo "Created ~/.bash_aliases"
else
    echo "Replacing contents of ~/.bash_aliases"
fi

cat $DOTFILES_BASH_DIR/aliases > "${HOME}/.bash_aliases"

echo "Install snippets for vscode..."

# Check if the directory exists, if not create it
if [ ! -d "$VSCODE_SETTINGS_DIR" ]; then
    mkdir -p "$VSCODE_SETTINGS_DIR"
fi

# Copy each file from the dotfiles snippets directory to the VSCode snippets directory
for file in ~/dotfiles/vscode/snippets/*; do
    cp "$file" "$VSCODE_SETTINGS_DIR/"
done

echo "VSCode snippets installed successfully!"

echo "Install settings for vscode..."
cp $DOTFILES_VSCODE_DIR/settings.json "$VSCODE_SETTINGS_DIR/"
cp $DOTFILES_VSCODE_DIR/keybindings.json "$VSCODE_SETTINGS_DIR/"

echo "Installing VSCode Extensions..."
cp $DOTFILES_VSCODE_DIR/extensions.json "$VSCODE_SETTINGS_DIR/"

export code="$(ls ~/.vscode-server/bin/*/bin/code-server* | head -n 1)"
while read -r EX; do
    echo "Installing extension: $EX"
    $code --install-extension "$EX"
done < "${DOTFILES_VSCODE_DIR}/extensions.list"

echo "VSCode Extensions installed successfully!"

echo "setup git user"
cat $DOTFILES_ROOT_DIR/gitconfig >> ~/.gitconfig
