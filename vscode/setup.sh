#!/bin/bash

# Script Name: setup.sh
# Description: This script will install the required Ruby version and gemset for the project. It will also install the required VSCode settings for the project.
# Author: scope2229
# Date: 16/10/2024
RUBY_VERSION=$(cat $WORKSPACE_DIR/.ruby-version)
RUBY_GEMSET=$(cat $WORKSPACE_DIR/.ruby-gemset)

WORKSPACE_DIR="/workspace"
RUBY_PATH="/usr/local/rvm/gems/ruby-$RUBY_VERSION@$RUBY_GEMSET/bin/"
RUBOCOP_PATH="$(dirname $(which rubocop))/"
VSCODE_SETTINGS_DIR="$WORKSPACE_DIR/.vscode"

###############################################################################
###############################################################################
###############################################################################

install_ruby_with_rvm() {
    echo "Installing Ruby version: $RUBY_VERSION; WITH GEMSET: $RUBY_GEMSET"

    cd $WORKSPACE_DIR

    rvm install $RUBY_VERSION

    rvm gemset create $RUBY_GEMSET

    cd $WORKSPACE_DIR

    bundle install
    yarn install

    echo "Ruby $RUBY_VERSION installed successfully!"
}

###############################################################################
###############################################################################
###############################################################################

install_rubocop() {
    echo "Installing rubocop..."

    # Update settings.json with the rubocop execute path
    if [ -f "$VSCODE_SETTINGS_DIR/settings.json" ]; then
        jq --arg path "$RUBOCOP_PATH" '.["[ruby]"].rubocop.executePath = $path' "$VSCODE_SETTINGS_DIR/settings.json" > "$VSCODE_SETTINGS_DIR/settings.tmp.json" && mv "$VSCODE_SETTINGS_DIR/settings.tmp.json" "$VSCODE_SETTINGS_DIR/settings.json"
    fi

    echo "Rubocop installed successfully!"
}

###############################################################################
###############################################################################
###############################################################################

install_debugging_tools() {
    echo "Installing Ruby debugging tools for vscode..."

    gem install ruby-debug-ide debase:0.2.5.beta2 irb:1.14.1

    echo "Ruby debugging tools installed successfully!"
}

###############################################################################
###############################################################################
###############################################################################

install_all() {
    install_ruby_with_rvm
    install_rubocop
    install_debugging_tools
}

###############################################################################
###############################################################################
###############################################################################

usage() {
    echo "Usage: $0 [-a] [-r] [-c] [-d] [-h]"
    echo "  -a    Install everything"
    echo "  -r    Install Ruby with RVM"
    echo "  -c    Install Rubocop"
    echo "  -d    Install debugging tools"
    echo "  -h    Display this help message"
    exit 0
}

###############################################################################
###############################################################################
###############################################################################

# Parse command-line arguments
while getopts "arcdh" opt; do
    case $opt in
        a)
            echo "Option -a passed"
            install_all
            ;;
        r)
            echo "Option -r passed"
            install_ruby_with_rvm
            ;;
        c)
            echo "Option -c passed"
            install_rubocop
            ;;
        d)
            echo "Option -d passed"
            install_debugging_tools
            ;;
        h)
            usage
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    usage
fi
