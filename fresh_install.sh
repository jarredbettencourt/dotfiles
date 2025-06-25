#!/bin/bash

cd ~
# What makes sense here is this:
# Install OS
# Paste ssh key into ~/.ssh folder from USB drive
# Run the following line for importing gpg key
# gpg --import private-key.asc
# Install yadm
# Run 'yadm clone https://github.com/jbettencourt10/dotfiles.git'
# Then run this script

# Detect Linux distribution
if [ -x "$(command -v lsb_release)" ]; then
    linux_distro=$(lsb_release -i | awk -F: '{print $2}' | xargs)
else
    echo 'lsb_release command not found. Defaulting to Fedora.' >&2
    linux_distro="Fedora"
fi

# Function to clean package cache
cleanup() {
    if [ "$linux_distro" == "Fedora" ]; then
        sudo dnf autoremove -y
        sudo dnf clean all
    elif [ "$linux_distro" == "Ubuntu" ]; then
        sudo apt autoremove -y
        sudo apt clean
    fi
}

# Install packages based on distribution
case "$linux_distro" in
    Fedora)
        echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
        sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
        sudo dnf check-update -y
        sudo dnf upgrade -y
        sudo dnf install -y firefox fastfetch htop wireshark vim vlc gimp zsh neovim tmux git-delta wl-clipboard bleachbit flatpak discord ripgrep fd fzf kitty gnome-tweaks unzip
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -y flathub com.spotify.Client
        cleanup
        ;;

    Ubuntu)
        sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt update
        sudo apt full-upgrade -y
        sudo apt install -y firefox fastfetch htop wireshark vim vlc gimp zsh gnome-tweaks gnome-logs cheese notepadqq ubuntu-restricted-extras git unzip curl wget gpg tmux neovim git-delta synaptic ripgrep fd-find fzf gnome-tweaks bleachbit wl-clipboard flatpak
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
        # VSCode installation
        # wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        # install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/packages.microsoft.gpg
        # echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
        # sudo apt update
        # apt install -y code
        # rm -f packages.microsoft.gpg

        cleanup
        ;;
    
    *)
        echo "Unsupported Linux distribution: $linux_distro" >&2
        exit 1
        ;;
esac

wget -P ~/Downloads "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
mkdir -p ~/.local/share/fonts/
tar -xvf ~/Downloads/JetBrainsMono.tar.xz -C ~/.local/share/fonts/
fc-cache -fv


# Change default shell to zsh
chsh -s "$(which zsh)"


echo "You should now reboot the system!"

# Manual Tasks
echo "Manual tasks to complete:"
echo "- Install Bitwarden extension"
echo "- Install Nvidia drivers if on Fedora, but only after rebooting. When drivers are installed, wait for them to build and then reboot again"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# TODO
# echo "TODO:"
# echo "- Install Timeshift"
# add bat, eza, httpie
# make ssh key auto unlock eval agent
# tmux plugin manager
#
#
#
# #!/bin/bash

# set -euo pipefail
#
# cd ~
#
# echo "🔧 Running YADM bootstrap..."
#
# # Detect Linux distribution
# if command -v lsb_release &>/dev/null; then
#     linux_distro=$(lsb_release -is)
# else
#     echo 'lsb_release not found. Defaulting to Fedora.' >&2
#     linux_distro="Fedora"
# fi
#
# # Function to clean package cache
# cleanup() {
#     case "$linux_distro" in
#         Fedora)
#             sudo dnf autoremove -y
#             sudo dnf clean all
#             ;;
#         Ubuntu)
#             sudo apt autoremove -y
#             sudo apt clean
#             ;;
#     esac
# }
#
# # Install packages based on distro
# case "$linux_distro" in
#     Fedora)
#         echo "Installing packages for Fedora..."
#         echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
#         sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
#         sudo dnf upgrade -y
#         sudo dnf install -y firefox fastfetch htop wireshark vim vlc gimp zsh neovim tmux git-delta wl-clipboard bleachbit flatpak discord ripgrep fd fzf kitty gnome-tweaks unzip
#         flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#         flatpak install -y flathub com.spotify.Client
#         ;;
#     Ubuntu)
#         echo "Installing packages for Ubuntu..."
#         sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
#         sudo add-apt-repository -y ppa:neovim-ppa/unstable
#         sudo apt update
#         sudo apt full-upgrade -y
#         sudo apt install -y firefox fastfetch htop wireshark vim vlc gimp zsh gnome-tweaks gnome-logs cheese notepadqq ubuntu-restricted-extras git unzip curl wget gpg tmux neovim git-delta synaptic ripgrep fd-find fzf bleachbit wl-clipboard flatpak
#         curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
#         ;;
#     *)
#         echo "Unsupported Linux distribution: $linux_distro" >&2
#         exit 1
#         ;;
# esac
#
# cleanup
#
# # Fonts
# echo "🔠 Installing JetBrains Mono Nerd Font..."
# mkdir -p ~/.local/share/fonts/
# wget -P ~/Downloads "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
# tar -xvf ~/Downloads/JetBrainsMono.tar.xz -C ~/.local/share/fonts/
# fc-cache -fv
#
# # Zsh & Oh-My-Zsh setup
# echo "🌀 Installing Oh-My-Zsh and plugins..."
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# ZSH_CUSTOM="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"
# git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
#
# # Change default shell to zsh
# chsh -s "$(which zsh)"
#
# # Final message
# echo ""
# echo "✅ YADM bootstrap completed!"
# echo ""
# echo "🔄 You should reboot the system."
# echo "🧠 Manual tasks:"
# echo "- Install Bitwarden browser extension"
# echo "- Install Nvidia drivers (Fedora) after reboot"
#
#---
# - name: Bootstrap a new Linux machine
#   hosts: localhost
#   become: yes
#   gather_facts: yes
#
#   vars:
#     fedora_packages:
#       - firefox
#       - fastfetch
#       - htop
#       - wireshark
#       - vim
#       - vlc
#       - gimp
#       - zsh
#       - neovim
#       - tmux
#       - git-delta
#       - wl-clipboard
#       - bleachbit
#       - flatpak
#       - discord
#       - ripgrep
#       - fd
#       - fzf
#       - kitty
#       - gnome-tweaks
#       - unzip
#
#     ubuntu_packages:
#       - firefox
#       - fastfetch
#       - htop
#       - wireshark
#       - vim
#       - vlc
#       - gimp
#       - zsh
#       - gnome-tweaks
#       - gnome-logs
#       - cheese
#       - notepadqq
#       - ubuntu-restricted-extras
#       - git
#       - unzip
#       - curl
#       - wget
#       - gpg
#       - tmux
#       - neovim
#       - git-delta
#       - synaptic
#       - ripgrep
#       - fd-find
#       - fzf
#       - bleachbit
#       - wl-clipboard
#       - flatpak
#
#   tasks:
#
#     - name: Print detected OS
#       debug:
#         msg: "Detected OS is {{ ansible_distribution }}"
#
#     - name: Fedora - add RPM Fusion nonfree repo
#       dnf:
#         name: "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-{{ ansible_facts.distribution_major_version }}.noarch.rpm"
#         state: present
#       when: ansible_distribution == "Fedora"
#
#     - name: Fedora - update packages
#       dnf:
#         name: "*"
#         state: latest
#       when: ansible_distribution == "Fedora"
#
#     - name: Fedora - install packages
#       dnf:
#         name: "{{ fedora_packages }}"
#         state: present
#       when: ansible_distribution == "Fedora"
#
#     - name: Ubuntu - add PPAs
#       apt_repository:
#         repo: "{{ item }}"
#         state: present
#       loop:
#         - ppa:zhangsongcui3371/fastfetch
#         - ppa:neovim-ppa/unstable
#       when: ansible_distribution == "Ubuntu"
#
#     - name: Ubuntu - update apt cache
#       apt:
#         update_cache: yes
#       when: ansible_distribution == "Ubuntu"
#
#     - name: Ubuntu - upgrade packages
#       apt:
#         upgrade: dist
#       when: ansible_distribution == "Ubuntu"
#
#     - name: Ubuntu - install packages
#       apt:
#         name: "{{ ubuntu_packages }}"
#         state: present
#       when: ansible_distribution == "Ubuntu"
#
#     - name: Add flathub remote if missing
#       command: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#       changed_when: false
#
#     - name: Install Spotify via Flatpak
#       flatpak:
#         name: com.spotify.Client
#         state: present
#         remote: flathub
#
#     - name: Download JetBrains Mono Nerd Font
#       get_url:
#         url: https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
#         dest: /tmp/JetBrainsMono.tar.xz
#
#     - name: Create fonts directory
#       file:
#         path: "{{ ansible_env.HOME }}/.local/share/fonts"
#         state: directory
#         mode: '0755'
#
#     - name: Extract JetBrains Mono fonts
#       unarchive:
#         src: /tmp/JetBrainsMono.tar.xz
#         dest: "{{ ansible_env.HOME }}/.local/share/fonts"
#         remote_src: yes
#
#     - name: Refresh font cache
#       command: fc-cache -fv
#
#     - name: Change default shell to zsh
#       user:
#         name: "{{ ansible_env.USER }}"
#         shell: /usr/bin/zsh
#
#     - name: Install Oh-My-Zsh (unattended)
#       become: false
#       shell: |
#         sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
#       args:
#         creates: "{{ ansible_env.HOME }}/.oh-my-zsh"
#
#     - name: Clone zsh-autosuggestions plugin
#       git:
#         repo: https://github.com/zsh-users/zsh-autosuggestions
#         dest: "{{ ansible_env.HOME }}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
#         depth: 1
#
#     - name: Clone zsh-syntax-highlighting plugin
#       git:
#         repo: https://github.com/zsh-users/zsh-syntax-highlighting.git
#         dest: "{{ ansible_env.HOME }}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
#         depth: 1
#
#     - name: Clone powerlevel10k theme
#       git:
#         repo: https://github.com/romkatv/powerlevel10k.git
#         dest: "{{ ansible_env.HOME }}/.oh-my-zsh/custom/themes/powerlevel10k"
#         depth: 1
#
#     - name: Show reboot and manual tasks message
#       debug:
#         msg: |
#           ✅ Bootstrap completed!
#
#           🔄 You should now reboot the system.
#
#           🧠 Manual tasks to complete:
#           - Install Bitwarden browser extension
#           - Install Nvidia drivers (Fedora) after reboot

