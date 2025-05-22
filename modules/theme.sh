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
    cp ../WhiteSur-wallpapers/4k/sequoia-dark.jpg ./
    sudo ./tweaks.sh -g -nb -b "sequoia-dark.jpg"
       
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
	
	gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark-blue' && echo "✅ GTK theme applied." || echo "❌ Failed to apply GTK theme."
	gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark' && echo "✅ Icon theme applied." || echo "❌ Failed to apply icon theme."
	gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
	gsettings set org.gnome.desktop.interface accent-color 'blue'
	gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
	gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.local/share/backgrounds/sequoia-dark.jpg"
	gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.local/share/backgrounds/sequoia-dark.jpg"
	
    echo "Installation of WhiteSur GTK theme completed."

}


configs(){
	gsettings set org.gnome.desktop.interface show-battery-percentage  true
	gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
	gsettings set org.gnome.shell favorite-apps "[
				  'org.gnome.Nautilus.desktop',
				  'firefox.desktop',
				  'org.gnome.Console.desktop',
				  'code.desktop',
				  'jetbrains-idea.desktop',
				  'org.gnome.TextEditor.desktop',
				  'com.discordapp.Discord.desktop',
				  'com.obsproject.Studio.desktop',
				  'org.gnome.Software.desktop',
				  'org.gnome.Settings.desktop',
				  'org.gnome.tweaks.desktop'
				]"

	# Define as pastas visíveis no grid
	gsettings set org.gnome.desktop.app-folders folder-children "['System', 'Office']"

	### ----- Pasta: System -----
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ name 'System'

	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ apps "[
	  'htop.desktop',
	  'org.gnome.Loupe.desktop',
	  'org.gnome.Logs.desktop',
	  'org.freedesktop.MalcontentControl.desktop',
	  'qv4l2.desktop',
	  'qvidcap.desktop',
	  'org.gnome.Tour.desktop',
	  'vim.desktop',
	  'org.gnome.Epiphany.desktop',
	  'avahi-discover.desktop',
	  'bssh.desktop',
	  'bvnc.desktop',
	  'nm-connection-editor.desktop',
	  'org.gnome.Characters.desktop',
	  'org.gnome.Connections.desktop',
	  'org.gnome.baobab.desktop',
	  'org.gnome.font-viewer.desktop',
	  'yelp.desktop'
	]"

	### ----- Pasta: Office -----
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ name 'Office'
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ translate true

	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ apps "[
	  'libreoffice-writer.desktop',
	  'libreoffice-calc.desktop',
	  'libreoffice-impress.desktop',
	  'libreoffice-draw.desktop',
	  'libreoffice-math.desktop',
	  'libreoffice-base.desktop',
	  'libreoffice-startcenter.desktop',
	  'libreoffice-xsltfilter.desktop'
	]"

	
	




	
}
