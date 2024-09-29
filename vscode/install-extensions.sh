echo "Install vscode extensions... ${USER} DIRECTORY ${HOME} VERSIONS $(code -v)"

if command -v code &> /dev/null; then
    while read -r EX; do
        echo "Installing extension: $EX"
        code --install-extension "$EX"
    done < "~/dotfiles/vscode/extensions.list"
else
    echo "VSCode command line tool not available. Please install extensions manually."
fi
