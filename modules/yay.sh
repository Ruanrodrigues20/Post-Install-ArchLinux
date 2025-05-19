#!/bin/bash
set -e

source modules/utils.sh


setup_yay(){
    echo "Updating system..."
    sudo pacman -Syu --noconfirm

    echo "Installing yay..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin && makepkg -si --noconfirm && cd ..
    rm -rf yay-bin
}



install_packages(){
    echo "Installing essential packages..."

    local packages=(
        "bash-completion"
        "firefox"
        "git"
        "wget"
        "curl"
        "vim"
        "tree"
        "tmux"
        "python-pip"
        "networkmanager"
        "fastfetch"
        "visual-studio-code-bin"
        "intellij-idea-ultimate-edition"
        "gnome-shell-extension-alphabetical-grid-extension"
        "ttf-ms-fonts"
        "gnome-shell-extension-blur-my-shell"
        "gnome-shell-extension-appindicator"
        "gnome-shell-extension-compiz-alike-magic-lamp-effect-git"
        "flatpak"
        "tlp"
        "tlp-rdw"
        "archlinux-wallpaper"
        "gnome-tweaks"
        "libreoffice-fresh" 
        "libreoffice-fresh-pt-br"
        "postman-bin"
    )

    # Instala os pacotes essenciais
    install "${packages[@]}"
}
