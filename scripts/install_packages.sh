#!/bin/bash
set -e

source scripts/utils.sh
source scripts/configs.sh

install_ohmybash() {
    ( bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" )
}

check_dependencies(){
    echo -e "\e[1;34m===== 🔥 Installing Dependencies =====\e[0m"

    local base_dir="./packages"
    local dependencies=()

    if [ -f "$base_dir/dependencies.txt" ]; then
        mapfile -t dependencies < "$base_dir/dependencies.txt"
    fi

    if [ "$DISTRO" = "debian" ] || [ "$DISTRO" = "arch" ]; then
        install "${dependencies[@]}"
    else
        echo "$DISTRO"
        return 1
    fi
}


install_packages() {
    echo -e "\e[1;34m===== 🔥 Installing Packages =====\e[0m"

    local base_dir="./packages"
    local common_pkgs=()
    local distro_pkgs=()

    if [ -f "$base_dir/common.txt" ]; then
        mapfile -t common_pkgs < "$base_dir/common.txt"
    fi

    if [ "$DISTRO" = "debian" ] && [ -f "$base_dir/debian.txt" ]; then
        echo -e "\e[1;34m===== 🔥 Installing Debian Packages =====\e[0m"
        mapfile -t distro_pkgs < "$base_dir/debian.txt"
        install "${common_pkgs[@]}" "${distro_pkgs[@]}"
    elif [ "$DISTRO" = "arch" ] && [ -f "$base_dir/arch.txt" ]; then
        echo -e "\e[1;34m===== 🔥 Installing Arch Packages =====\e[0m"
        mapfile -t distro_pkgs < "$base_dir/arch.txt"
        install "${common_pkgs[@]}" "${distro_pkgs[@]}"
    else
        echo "$DISTRO"
        return 1
    fi
}



snaps_install() {
    if [ "$DISTRO" = "debian" ]; then
        local snaps=("postman")
        echo -e "\e[1;34m===== 🔥 Installing Snap Applications =====\e[0m"
        for snap in "${snaps[@]}"; do
            echo ""  # Linha em branco para separar visualmente

            if ! snap list "$snap" &> /dev/null; then
                echo -e "\e[33m$snap is not installed. Installing...\e[0m"
                if sudo snap install "$snap" --classic; then
                    echo -e "\e[32m✔️  $snap installed successfully.\e[0m"
                else
                    echo -e "\e[31m❌  Failed to install $snap.\e[0m"
                fi
            else
                echo -e "\e[32m✔️  $snap is already installed.\e[0m"
            fi
        done
    fi
}

install_flatpaks(){
    echo -e "\e[1;34m===== 🔥 Installing Flatpak Applications =====\e[0m"
    echo ""
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    # Lista de aplicativos para instalar
    apps=("com.discordapp.Discord" "org.gnome.DejaDup" "io.github.realmazharhussain.GdmSettings" 
        "com.getpostman.Postman" "io.missioncenter.MissionCenter")
    
    install_f "${apps[@]}"
}



downloads(){
    if [ "$DISTRO" = "debian" ]; then
        echo -e "\e[1;34m===== 📥 Downloading Extra Software =====\e[0m"
        echo ""
        # Download and install Fastfetch
        #
        
        mkdir -p resources
        cd resources

        wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.42.0/fastfetch-linux-amd64.deb
        wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb
        wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/848b80aeb52026648a8ff9f7c45a9b0a80641e2e/code_1.100.2-1747260578_amd64.deb
        sudo apt install ./*.deb -y
        
        git clone https://github.com/Ruanrodrigues20/intelliJ-install && cd intelliJ-install && bash install.sh
        cd ..

        rm *.deb
        rm -rf intelliJ-install

        cd ..
        corrigir_vscode_sources
    fi
}


install_firefox_deb() {
    if [ "$DISTRO" = "debian" ]; then
        read -p "Do you want to install Firefox (DEB)? [y/N] " answer
        if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
            echo -e "\e[1;34m===== 🔥 Installing Firefox (DEB) =====\e[0m"
            echo ""

            remove_trava  # <- suponho que essa função esteja definida

            sudo install -d -m 0755 /etc/apt/keyrings

            wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | \
                sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

            gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | \
                awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nO fingerprint da chave corresponde ("$0").\n"; else print "\nFalha na verificação: o fingerprint ("$0") não corresponde ao esperado.\n"}'

            echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | \
                sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null

            echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla > /dev/null

            sudo apt remove -y firefox-esr firefox >/dev/null 2>&1

            if command -v snap >/dev/null 2>&1 && snap list | grep -q "^firefox "; then
                sudo snap remove firefox >/dev/null 2>&1
            fi

            sudo apt update && sudo apt install -y firefox
        fi
    fi
}

