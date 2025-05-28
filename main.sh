#!/bin/bash
set -e

# Load all modules
for module in modules/*.sh; do
    source "$module"
done

setup(){
    check_internet_connection
    detect_distro
    mkdir -p resources

}


main() { 
    show_logo
    show_intro_message
    
    #Inicial Setup
    setup
    setup_yay

    #Install Programs
    install_packages
    downloads
    install_flatpaks
    snaps_install
    configs_wallpapers
    gtk_theme

    #Configs
    setup_aliases_and_tools
    git_config
    setup_tlp
    configs
    set_profile_picture_current_user
    configs_keyboard
    set_configs_fastfetch

    show_summary
    ask_to_restart
}

main

