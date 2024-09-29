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

echo "setup git user"

# Take specific section and append to ~/.gitconfig
# grep -A 2 '\[user\]' ~/dotfiles/gitconfig >> ~/.gitconfig

# Copy whole file and append to ~/.gitconfig
cat $DOTFILES_ROOT_DIR/gitconfig >> ~/.gitconfig


# VSCODE extensions
echo "Installing VSCode Extensions..."
WHICH_CODE=$(which code)

if [ -z "$WHICH_CODE" ]; then
    echo "VSCode is not installed. Please install it and run this script again."
    exit 1
fi


cat "${DOTFILES_VSCODE_DIR}/extensions.list" | xargs -n 1 ${WHICH_CODE} --install-extension --force

