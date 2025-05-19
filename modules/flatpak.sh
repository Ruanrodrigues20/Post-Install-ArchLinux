#!/bin/bash
set -e

source modules/utils.sh

install_flatpaks(){
    echo -e "\e[1;34m===== 🔥 Installing Flatpak Applications =====\e[0m"
    echo ""

    # Lista de aplicativos para instalar
    apps=("com.discordapp.Discord" "org.gnome.DejaDup")
    install_f "${apps[@]}"

}