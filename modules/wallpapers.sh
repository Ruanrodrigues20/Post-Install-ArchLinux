#!/bin/bash

# Diretórios
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_DIR="$HOME/.local/share/backgrounds"
WALLPAPER_SRC="$SCRIPT_DIR/../wallpapers"

# Cores para mensagens
CGSC="\033[0;32m"  # Sucesso
CWRN="\033[0;33m"  # Alerta
CERR="\033[0;31m"  # Erro
RESET="\033[0m"

# Função para mostrar mensagens
log() {
  case $1 in
    success) echo -e "${CGSC}[✔]${RESET} $2" ;;
    warn)    echo -e "${CWRN}[!]${RESET} $2" ;;
    error)   echo -e "${CERR}[✘]${RESET} $2" ;;
    *)       echo "$2" ;;
  esac
}

# Função para instalar wallpapers
wallpapers() {
  mkdir -p "$WALLPAPER_DIR"

  # Habilita a correspondência de arquivos com glob
  shopt -s nullglob

  # Copia todos os arquivos de imagem para o diretório de wallpapers
  cp -a "$WALLPAPER_SRC"/*.{jpg,jpeg,png,JPG,JPEG,PNG} "$WALLPAPER_DIR/"

  # Desabilita a correspondência de arquivos com glob
  shopt -u nullglob

  # Verifica se algum arquivo foi copiado
  if [ "$(ls -A "$WALLPAPER_DIR")" ]; then
    log success "Imagens copiadas para '$WALLPAPER_DIR'."
  else
    log warn "Nenhuma imagem encontrada em '$WALLPAPER_SRC'."
  fi
}
