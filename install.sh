# Define the target directories VSCode

VSCODE_SETTINGS_DIR="/workspace/.vscode"
DF_ROOT_DIR="${HOME}/dotfiles"
BASH_DIR="${DF_ROOT_DIR}/bash"
VSCODE_DIR="${DF_ROOT_DIR}/vscode"
GIT_DIR="${DF_ROOT_DIR}/git"
CLEAN_UP_DOTFILES=1
WORKSPACE_DIR="/workspace"
RUBY_VERSION=$(grep -E '^ruby "([0-9]+\.[0-9]+\.[0-9]+)"' $WORKSPACE_DIR/Gemfile | sed -E 's/ruby "([0-9]+\.[0-9]+\.[0-9]+)"/\1/')

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

# This section will take a long time to complete and the container will be built
# with the Ruby version specified in the Gemfile. Wait patently for the installation
# to complete. To check the progress of the installation, you can run the following
# ctrl+shift+p command in VSCode: "Remote-Containers: Show Log"
# The first log should be the latest log containing the progress of the installation.

if [ -z "$RUBY_VERSION" ]; then
    echo "Ruby version not found in Gemfile. Exiting."
    exit 1
fi

echo "Ruby version found: $RUBY_VERSION"

# Install Ruby using RVM
if command -v rvm &> /dev/null; then
    /bin/bash --login
    echo "RVM is installed. Installing Ruby $RUBY_VERSION..."
    rvm install "$RUBY_VERSION"
    rvm use "$RUBY_VERSION" --default
else
    echo "RVM is not installed. Please install RVM first. Exiting."
    exit 1
fi

echo "Ruby $RUBY_VERSION installed successfully!"

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

RUBOCOP_PATH="/usr/local/rvm/gems/ruby-$RUBY_VERSION/bin/rubocop"

# Update settings.json with the rubocop execute path
if [ -f "$VSCODE_SETTINGS_DIR/settings.json" ]; then
    jq --arg path "$RUBOCOP_PATH" '.["rubocop.executePath"] = $path' "$VSCODE_SETTINGS_DIR/settings.json" > "$VSCODE_SETTINGS_DIR/settings.tmp.json" && mv "$VSCODE_SETTINGS_DIR/settings.tmp.json" "$VSCODE_SETTINGS_DIR/settings.json"
else
    echo "{\"rubocop.executePath\": \"$RUBOCOP_PATH\"}" > "$VSCODE_SETTINGS_DIR/settings.json"
fi

echo "VSCode settings installed successfully!"

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

echo "Configure git for user"

cat $DF_ROOT_DIR/git/gitconfig >> ~/.gitconfig

echo "Git configured successfully!"

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
