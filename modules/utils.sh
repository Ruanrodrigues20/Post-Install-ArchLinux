install() {
    local packages=("$@")  # Recebe a lista de pacotes como argumento
    for dep in "${packages[@]}"; do
        echo ""  # Salta uma linha antes de cada pacote

        # Verificar se o pacote está instalado usando pacman
        if ! pacman -Qi "$dep" &> /dev/null; then
            echo -e "\e[33m$dep is not installed. Installing with yay...\e[0m"
            # Redirecionando a saída para /dev/null e mostrando erro apenas em caso de falha
            if yay -S --noconfirm "$dep"; then
                echo -e "\e[32m✔️  $dep installed successfully.\e[0m"
            else
                echo -e "\e[31m❌  Failed to install $dep.\e[0m"
            fi
        else
            echo -e "\e[32m✔️  $dep is already installed.\e[0m"
        fi
    done
}


install_f(){
     # Loop para instalar as aplicações
    for app in "${apps[@]}"; do
        echo -e "\e[33mInstalling $app...\e[0m"
        flatpak install -y flathub "$app"
    done
}


# Welcome message
show_intro_message(){
    echo -e "\e[1;34m🎉 Welcome! Starting the Arch Linux post-installation setup... 🚀\e[0m"
    echo "This script will install essential software, themes, aliases,"
    echo "developer tools, and configure your system for productivity."
    echo ""
    echo "Developed by: Ruan Rodrigues 👨‍💻"
    echo "GitHub: https://github.com/Ruanrodrigues20"
    echo ""

    echo -e "\e[1;33mThe setup will start automatically in 10 seconds... ⏳"
    echo -e "Or press any key to start immediately.\e[0m"

    for i in {10..1}; do
        echo -ne "\rStarting in $i... Press any key to begin ⏰"
        read -t 1 -n 1 -s key && break
    done
    echo -e "\rStarting now... 🚀                           \n"
}

# Show a summary of completed actions
show_summary() {
    echo -e "\e[1;34m===== 📋 Post-Installation Summary =====\e[0m"
    echo -e "\e[1;32m✔\e[0m System updated"
    echo -e "\e[1;32m✔\e[0m yay installed"
    echo -e "\e[1;32m✔\e[0m Essential packages installed"
    echo -e "\e[1;32m✔\e[0m Flatpak applications installed"
    echo -e "\e[1;32m✔\e[0m WhiteSur GTK theme installed"
    echo -e "\e[1;32m✔\e[0m Aliases configured"
    echo -e "\e[1;32m✔\e[0m Git configuration completed"
    echo -e "\e[1;32m✔\e[0m User directories created"
    echo -e "\e[1;32m✔\e[0m TLP configured for power saving"
    echo -e "\e[1;34m🎉 All tasks completed successfully!\e[0m\n"
}


show_logo(){
    clear
    echo ""

    echo "██████╗  ██████╗ ███████╗████████╗
██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝
██████╔╝██║   ██║███████╗   ██║   
██╔═══╝ ██║   ██║╚════██║   ██║   
██║     ╚██████╔╝███████║   ██║   
╚═╝      ╚═════╝ ╚══════╝   ╚═╝   
"

    echo "██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
"

    echo ""
}


ask_to_restart(){
    read -p "Do you want to restart your system now? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        sudo reboot
    fi
}


check_internet_connection() {
    echo -e "\e[1;34m===== 🌐 Checking internet connection =====\e[0m"
    if ping -c 1 archlinux.org &> /dev/null; then
        echo -e "\e[1;32m✔️ Internet is connected.\e[0m"
    else
        echo -e "\e[1;31m❌ No internet connection detected. Please check your network.\e[0m"
        exit 1
    fi
}