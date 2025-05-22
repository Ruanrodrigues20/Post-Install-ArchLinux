#!/bin/bash
set -e

source modules/utils.sh


setup_yay() {
    if [[ "$DISTRO" != "arch" ]]; then
        echo "Yay é específico para Arch. Pulando..."
        return
    fi

    if ! command -v yay &>/dev/null; then
        echo "Instalando yay..."
        sudo pacman -S --noconfirm --needed base-devel git
        git clone https://aur.archlinux.org/yay.git
        cd yay && makepkg -si --noconfirm
        cd .. && rm -rf yay
    fi
}



install_packages() {
    echo -e "\e[1;34m===== 🔥 Installing Packages =====\e[0m"

    local base_dir="./modules/packages"
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
    local snaps=("postman" "intellij-idea-ultimate" "code")

    if [ "$DISTRO" = "debian" ]; then
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

    if [ "$DISTRO" = "debian" ]; then
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    fi
    
    # Lista de aplicativos para instalar
    apps=("com.discordapp.Discord" "org.gnome.DejaDup")
    if [ "$DISTRO" = "debian" ]; then
    	apps+=("com.getpostman.Postman")
    fi
    
    install_f "${apps[@]}"
}



downloads(){

    if [ "$DISTRO" = "debian" ]; then
        echo -e "\e[1;34m===== 📥 Downloading Extra Software =====\e[0m"
        echo ""
        # Download and install Fastfetch
        #

        install_firefox_deb
        wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.42.0/fastfetch-linux-amd64.deb
        wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb
        sudo apt install ./*.deb -y
        rm *.deb
        
        git clone https://github.com/Ruanrodrigues20/intelliJ-install && cd intellij-install && bash install.sh

    fi
}

install_firefox_deb(){

    echo -e "\e[1;34m===== 🔥 Installing Firefox (DEB) =====\e[0m"
    echo ""
     
    remove_trava
    
    sudo install -d -m 0755 /etc/apt/keyrings
    
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    
    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nO fingerprint da chave corresponde ("$0").\n"; else print "\nFalha na verificação: o fingerprint ("$0") não corresponde ao esperado.\n"}'
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
    echo '
    Package: *
    Pin: origin packages.mozilla.org
    Pin-Priority: 1000
    ' | sudo tee /etc/apt/preferences.d/mozilla
    
    sudo apt remove -y firefox-esr firefox >/dev/null 2>&1
    if command -v snap >/dev/null 2>&1 && snap list | grep -q "^firefox "; then
    snap remove firefox >/dev/null 2>&1
    fi

    sudo apt update && sudo apt install firefox 
}

install() {
    local packages=("$@")

    if [ "$DISTRO" = "debian" ]; then
        remove_trava
    fi

    for pkg in "${packages[@]}"; do
        echo ""
        echo -e "\e[33mInstalling $pkg...\e[0m"
        install_pkg "$pkg"
    done
}


install_pkg() {
    local pkg="$1"
    if [ "$DISTRO" = "arch" ]; then
        if ! pacman -Qi "$pkg" &> /dev/null; then
            yay -S --noconfirm "$pkg"
        else
            echo -e "\e[32m✔️  $pkg is already installed.\e[0m"
        fi
    elif [ "$DISTRO" = "debian" ]; then
        if ! dpkg -l | grep -E "^ii\s+$pkg" &> /dev/null; then
            sudo apt install -y "$pkg"
        else
            echo -e "\e[32m✔️  $pkg is already installed.\e[0m"
        fi
    else
        echo "Distribuição não suportada para instalação."
        return 1
    fi
}


install_f(){
    for app in "${apps[@]}"; do
        echo -e "\e[33mInstalling $app...\e[0m"
        flatpak install -y flathub "$app"
    done
}
