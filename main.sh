#!/bin/bash
set -e

# Load all modules
for module in modules/*.sh; do
    source "$module"
done


main() {
    show_logo
    show_intro_message
    check_internet_connection

    setup_yay
    install_packages
    install_flatpaks
    gtk_theme
    setup_aliases_and_tools
    git_config
    setup_directories
    setup_tlp
    wallpapers

    show_summary
    ask_to_restart
}

install_packages
