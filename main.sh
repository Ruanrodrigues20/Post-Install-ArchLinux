#!/bin/bash
set -e

# Load all modules
for module in scripts/*.sh; do
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
    if [ "$DISTRO" = "debian" ]; then
        read -p "Do you want to download firefox deb? [y/N] " answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            install_firefox_deb
        fi
    fi

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
    setup_bt_service
    configs
    set_profile_picture_current_user
    configs_keyboard
    install_fonts
    set_configs_fastfetch

    show_summary
    ask_to_restart
}

main

