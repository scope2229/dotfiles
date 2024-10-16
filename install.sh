# Define the target directories VSCode
echo "Setting up environment variables..."

VSCODE_SETTINGS_DIR="/workspace/.vscode"
DF_ROOT_DIR="${HOME}/dotfiles"
BASH_DIR="${DF_ROOT_DIR}/bash"
VSCODE_DIR="${DF_ROOT_DIR}/vscode"
GIT_DIR="${DF_ROOT_DIR}/git"
CLEAN_UP_DOTFILES=1
WORKSPACE_DIR="/workspace"
RUBY_VERSION=$(cat $WORKSPACE_DIR/.ruby-version)
RUBY_GEMSET=$(cat $WORKSPACE_DIR/.ruby-gemset)

#############################################################################
#############################################################################
#############################################################################

echo "Install ~/.bash_aliases..."
if [ ! -f "${HOME}/.bash_aliases" ]; then
    touch "${HOME}/.bash_aliases"
    echo "Created ~/.bash_aliases"
else
    echo "Replacing contents of ~/.bash_aliases"
fi

cat $BASH_DIR/aliases > "${HOME}/.bash_aliases"

echo "Installed ~/.bash_aliases successfully!"

#############################################################################
#############################################################################
#############################################################################

echo "Install snippets for vscode..."

# Check if the directory exists, if not create it
if [ ! -d "$VSCODE_SETTINGS_DIR" ]; then
    mkdir -p "$VSCODE_SETTINGS_DIR"
fi

# Copy each file from the dotfiles snippets directory to the VSCode snippets directory
for file in $VSCODE_DIR/snippets/*; do
    cp "$file" "$VSCODE_SETTINGS_DIR/"
done

echo "VSCode snippets installed successfully!"

#############################################################################
#############################################################################
#############################################################################

echo "Install settings for vscode..."

cp $VSCODE_DIR/settings.json "$VSCODE_SETTINGS_DIR/"
cp $VSCODE_DIR/keybindings.json "$VSCODE_SETTINGS_DIR/"
cp $VSCODE_DIR/launch.json "$VSCODE_SETTINGS_DIR/"

#############################################################################
#############################################################################
#############################################################################

echo "Installing VSCode Extensions..."

cp $VSCODE_DIR/extensions.json "$VSCODE_SETTINGS_DIR/"
export code="$(ls ~/.vscode-server/bin/*/bin/code-server* | head -n 1)"
while read -r EX; do
    echo "Installing extension: $EX"
    $code --install-extension "$EX"
done < "${VSCODE_DIR}/extensions.list"

echo "VSCode Extensions installed successfully!"

#############################################################################
#############################################################################
#############################################################################

echo "Copy over setup scripts..."

cp $VSCODE_DIR/debugging.sh "$VSCODE_SETTINGS_DIR/"
cp $VSCODE_DIR/setup.sh "$VSCODE_SETTINGS_DIR/"

echo "Setup script copied!"

#############################################################################
#############################################################################
#############################################################################

if [ "$CLEAN_UP_DOTFILES" -eq 1 ]; then
    echo "Clearing dotfiles..."

    cd /workspace
    rm -rf $DF_ROOT_DIR

    echo "Dotfiles cleared."
fi

#############################################################################
#############################################################################
#############################################################################

echo "Installation complete!"
