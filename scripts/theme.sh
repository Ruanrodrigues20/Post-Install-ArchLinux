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
    mkdir -p resources

    cd resources/
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
    git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git
    
    cd WhiteSur-icon-theme
    sudo ./install.sh -t all
    cd ..
    
    cd WhiteSur-gtk-theme
    ./install.sh -l
    sudo ./install.sh -a normal -m -N stable -t all
    sudo ./tweaks.sh -g -nb
    sudo ./tweaks.sh -F 
    sudo ./tweaks.sh -f
    sudo ./tweaks.sh -g 
    cp ~/.local/share/backgrounds/sequoia.jpeg ./
    sudo ./tweaks.sh -g -nb -b "sequoia.jpeg"
       
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
    

    cd WhiteSur-wallpapers
    sudo ./install-gnome-backgrounds.sh
    sudo ./install-wallpapers.sh
    cd ..
    
	cd ..
	gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark-blue' && echo "✅ GTK theme applied." || echo "❌ Failed to apply GTK theme."
	gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark' && echo "✅ Icon theme applied." || echo "❌ Failed to apply icon theme."
	gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
	gsettings set org.gnome.desktop.interface accent-color 'blue'
	gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
	gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/backgrounds/sequoia-dark.jpg"
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.local/share/backgrounds/sequoia-dark.jpg"
	
    echo "Installation of WhiteSur GTK theme completed."


}


