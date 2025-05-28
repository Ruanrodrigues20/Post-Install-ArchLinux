#!/bin/bash
set -e

# Load all modules
for module in modules/*.sh; do
    source "$module"
done


main() {
    detect_distro
    show_logo
    show_intro_message
    check_internet_connection
    mkdir -p resources
    install_ohmybash
    setup_yay
    install_packages
    downloads
    install_flatpaks
    snaps_install
    wallpapers
    gtk_theme
    setup_aliases_and_tools
    git_config
    setup_tlp
    configs
    set_configs_fastfetch
    show_summary
    ask_to_restart
}

main
