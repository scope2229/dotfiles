# To save some space, we can remove the dotfiles folder after the dotfiles have been copied to the home directory.

echo "Clearing dotfiles..."

# Function to wait for a folder to be available
wait_for_folder() {
    local folder_path="$1"
    while [ ! -d "$folder_path" ]; then
        echo "Waiting for folder $folder_path to be available..."
        sleep 2
    done
    echo "Folder $folder_path is now available."
}

# Wait for the /home/vscode/dotfiles folder to be available
wait_for_folder "$HOME/dotfiles"

# Remove the ~/dotfiles folder
rm -rf "${HOME}/dotfiles"

echo "Dotfiles cleared."
