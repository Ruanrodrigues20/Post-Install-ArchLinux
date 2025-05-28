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


setup_yay() {
    if [[ "$DISTRO" != "arch" ]]; then
        echo "Yay é específico para Arch. Pulando..."
        return
    fi
    
    if ! command -v yay &>/dev/null; then
        echo "Instalando yay..."
        sudo pacman -S --noconfirm --needed base-devel git
        mkdir -p resources
        cd resources
        git clone https://aur.archlinux.org/yay.git
        cd yay && makepkg -si --noconfirm
        yay -Sy --aur --devel --timeupdate
        rm -rf ~/.cache/yay/completion.cache
        yay -Syu
        cd .. && rm -rf yay
        cd ..
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

    echo "Do you want to generate a new SSH key for Git? (y/n)"
    read -p "Enter your choice: " ssh_choice
    if [[ "$ssh_choice" == "y" || "$ssh_choice" == "Y" ]]; then
        ssh_key_path="$HOME/.ssh/id_ed25519"

        if [[ -f "$ssh_key_path" ]]; then
            echo "SSH key already exists at $ssh_key_path"
        else
            ssh-keygen -t ed25519 -C "$email" -f "$ssh_key_path" -N ""
            echo "SSH key generated at $ssh_key_path"
        fi

        eval "$(ssh-agent -s)"
        ssh-add "$ssh_key_path"

        echo "Public key:"
        cat "${ssh_key_path}.pub"

        echo "Now add the above public key to your Git provider (e.g., GitHub, GitLab)."
    else
        echo "Skipping SSH key generation."
    fi
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


configs(){

    mkdir -p ~/Projects ~/Downloads ~/Documents ~/Pictures ~/Videos ~/Music ~/Desktop

	gsettings set org.gnome.desktop.interface show-battery-percentage  true
	gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
	gsettings set org.gnome.shell favorite-apps "[
				  'org.gnome.Nautilus.desktop',
				  'firefox.desktop',
				  'org.gnome.Console.desktop',
				  'code.desktop',
				  'jetbrains-idea.desktop',
				  'org.gnome.TextEditor.desktop',
				  'com.discordapp.Discord.desktop',
				  'com.obsproject.Studio.desktop',
				  'org.gnome.Software.desktop',
				  'org.gnome.Settings.desktop',
				  'org.gnome.tweaks.desktop'
				]"

	# Define as pastas visíveis no grid
	gsettings set org.gnome.desktop.app-folders folder-children "['System', 'Office']"

	### ----- Pasta: System -----
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ name 'System'

	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ apps "[
	  'htop.desktop',
	  'org.gnome.Loupe.desktop',
	  'org.gnome.Logs.desktop',
	  'org.freedesktop.MalcontentControl.desktop',
	  'qv4l2.desktop',
	  'qvidcap.desktop',
	  'org.gnome.Tour.desktop',
	  'vim.desktop',
	  'org.gnome.Epiphany.desktop',
	  'avahi-discover.desktop',
	  'bssh.desktop',
	  'bvnc.desktop',
	  'nm-connection-editor.desktop',
	  'org.gnome.Characters.desktop',
	  'org.gnome.Connections.desktop',
	  'org.gnome.baobab.desktop',
	  'org.gnome.font-viewer.desktop',
	  'yelp.desktop'
	]"

	### ----- Pasta: Office -----
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ name 'Office'
	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ translate true

	gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ apps "[
	  'libreoffice-writer.desktop',
	  'libreoffice-calc.desktop',
	  'libreoffice-impress.desktop',
	  'libreoffice-draw.desktop',
	  'libreoffice-math.desktop',
	  'libreoffice-base.desktop',
	  'libreoffice-startcenter.desktop',
	  'libreoffice-xsltfilter.desktop'
	]"
	
	set_profile_picture_current_user
}


set_profile_picture_current_user() {
  if [ "$DISTRO" = "debian" ]; then

    local user="$USER"
    local home_dir="$HOME"
    local svg_path="$home_dir/.face"
    local png_path="$home_dir/.face.png"
    local icon_path="/var/lib/AccountsService/icons/$user"
    local user_conf_path="/var/lib/AccountsService/users/$user"

    if [ ! -f "$svg_path" ]; then
      return 1
    fi

    # Converte SVG para PNG
    convert "$svg_path" "$png_path" || {
      return 1
    }

    # Copia PNG para accountsservice
    sudo cp "$png_path" "$icon_path" || {
      return 1
    }

    # Cria arquivo de configuração do usuário no accountsservice
    sudo bash -c "cat > '$user_conf_path'" <<EOF
[User]
Icon=$icon_path
EOF

    # Ajusta permissões
    sudo chmod 644 "$icon_path"
    sudo chown root:root "$icon_path"

  fi
}



set_configs_fastfetch(){
    unzip resources/fast.zip
    rm -rf ~/.config/fastfetch
    mv .config/fastfetch ~/.config/
    rm -rf .config
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
