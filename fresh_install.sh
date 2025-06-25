#!/bin/bash

cd ~
# What makes sense here is this:
# Install OS
# Paste ssh key into ~/.ssh folder from USB drive
# Run the following line for importing gpg key
# gpg --import private-key.asc
# Run the following two lines
        # sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:jbettencourt10/dotfiles.git
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
