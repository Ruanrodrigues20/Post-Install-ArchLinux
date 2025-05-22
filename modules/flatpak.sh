#!/bin/bash
set -e

source modules/utils.sh

install_flatpaks(){
    echo -e "\e[1;34m===== 🔥 Installing Flatpak Applications =====\e[0m"
    echo ""

    if [ "$DISTRO" = "debian" ]; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Lista de aplicativos para instalar
    apps=("com.discordapp.Discord" "org.gnome.DejaDup")
    install_f "${apps[@]}"
}
