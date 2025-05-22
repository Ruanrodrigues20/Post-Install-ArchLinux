#!bin/bash

# Welcome message
show_intro_message(){
    echo -e "\e[1;34m🎉 Welcome! Starting the Arch Linux/Debian post-installation setup... 🚀\e[0m"
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
    echo -e "\e[1;32m✔\e[0m yay installed (Arch Linux only)"
    echo -e "\e[1;32m✔\e[0m Snap applications installed (Based Debian distro)"
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


remove_trava(){
    sudo rm -f /var/lib/dpkg/lock-frontend
    sudo rm -f /var/lib/dpkg/lock
    sudo rm -f /var/cache/apt/archives/lock
    sudo rm -f /var/lib/apt/lists/lock
    sudo dpkg --configure -a
}

update(){
    echo -e "\e[1;34m===== 🔥 Updating System =====\e[0m"
    echo ""
    remove_trava
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt clean
}


detect_distro() {
    if command -v apt &> /dev/null; then
        DISTRO="debian"
    elif command -v pacman &> /dev/null; then
        DISTRO="arch"
    else
        echo "Distribution not supported."
        exit 1
    fi
}


detect_battery() {
    if [ -d "/sys/class/power_supply/BAT0" ] || [ -d "/sys/class/power_supply/BAT1" ]; then
        return 0  # Sucesso: bateria detectada
    else
        return 1  # Falha: nenhuma bateria detectada
    fi
}




git_config(){
    echo "Are you sure you want to set up git? (y/n)"
    read -p "Enter your choice: " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Skipping git setup."
        return
    fi

    echo "Setting up git..."

    read -p "Enter your user name: " name
    echo "Your user name is: $name"

    read -p "Enter your email: " email
    echo "Your email is: $email"

    git config --global user.name "$name"
    git config --global user.email "$email"

    echo "Git config set successfully."
}

setup_tlp() {
    if ! detect_battery; then
        echo -e "\e[33m⚠️  No battery detected. Skipping TLP installation.\e[0m"
        return 0
    fi

    echo -e "\n\e[34m🔧 Installing TLP and dependencies...\e[0m"

    if [[ "$DISTRO" == "arch" ]]; then
        yay -S --noconfirm tlp tlp-rdw &> /dev/null
        echo -e "\e[32m✔️  TLP installed successfully on Arch.\e[0m"
        echo -e "\n\e[34m🔌 Enabling TLP service...\e[0m"
        sudo systemctl enable tlp.service &> /dev/null
        sudo systemctl start tlp.service &> /dev/null

    elif [[ "$DISTRO" == "debian" ]]; then
        sudo apt install -y tlp &> /dev/null
        echo -e "\e[32m✔️  TLP installed successfully on Debian.\e[0m"
        remove_trava
        sudo apt install -y tlp tlp-rdw
        sudo systemctl enable tlp
        sudo systemctl start tlp
        sudo tlp-stat -s
    else
        echo -e "\e[31m❌  Unsupported distribution for installing TLP.\e[0m"
        return 1
    fi

}
