#!/bin/bash
set -e

gtk_theme(){
    echo "Do you want to install the WhiteSur GTK theme? (y/n)"
    read -p "Enter your choice: " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Skipping GTK theme installation."
        return
    fi

    echo "Installing WhiteSur GTK theme..."

    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
    
    cd WhiteSur-icon-theme
    sudo ./install.sh -t all -b
    cd ..
    
    cd WhiteSur-gtk-theme
    sudo ./install.sh -N monjave -t all
    sudo ./tweaks.sh -g -nb
    sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0
    cd ..


    echo "Do you want to install the WhiteSur cursor theme? (y/n)"
    read -p "Enter your choice: " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Skipping GTK cursor theme installation."
        return
    fi

    # Install the WhiteSur cursor theme
    echo "Installing WhiteSur cursor theme..."
    git clone https://github.com/vinceliuice/WhiteSur-cursors.git
    cd WhiteSur-cursors
    sudo ./install.sh
    cd ..
    rm -rf WhiteSur-cursors

    echo "Installation of WhiteSur GTK theme completed."

}