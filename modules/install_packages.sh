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
    install_f "${apps[@]}"
}



downloads(){

    if [ "$DISTRO" = "debian" ]; then
        echo -e "\e[1;34m===== 📥 Downloading Extra Software =====\e[0m"
        echo ""
        # Download and install Fastfetch
        #
        wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.42.0/fastfetch-linux-amd64.deb
        wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb
        sudo apt install ./*.deb -y
        rm *.deb
    fi
}
