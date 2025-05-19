#!/bin/bash
set -e


setup_tlp() {
    echo -e "\n\e[34m🔧 Instalando TLP e dependências...\e[0m"
    
    # Instala o TLP e ferramentas recomendadas
    if yay -S --noconfirm tlp tlp-rdw &> /dev/null; then
        echo -e "\e[32m✔️  TLP instalado com sucesso.\e[0m"
    else
        echo -e "\e[31m❌  Falha ao instalar o TLP.\e[0m"
        return 1
    fi

    # Detecta se o sistema usa systemd (padrão no Arch)
    echo -e "\n\e[34m🔌 Ativando o serviço do TLP...\e[0m"
    sudo systemctl enable tlp.service &> /dev/null
    sudo systemctl start tlp.service &> /dev/null
}