#!/bin/bash

# Diretórios
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_DIR="$HOME/.local/share/backgrounds"

# Função para instalar wallpapers
wallpapers() {
    mkdir -p resources
    cd resources
    git clone https://github.com/Ruanrodrigues20/wallpapers.git
    cd wallpapers
    mkdir -p "$WALLPAPER_DIR"
    bash main.sh 
    cd ..
    rm -rf wallpapers
    cd "$SCRIPT_DIR" 
}
