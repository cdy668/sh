#!/usr/bin/env bash
# Ubuntu script file example
#     ./init.ubuntu.18.04.sh $1
#     ./init.ubuntu.18.04.sh desktop
# Setting up Chrome Remote Desktop on Compute Engine
#     https://cloud.google.com/solutions/chrome-desktop-remote-on-compute-engine
#     https://remotedesktop.google.com/headless

desktop(){
    sudo apt update
    sudo apt -y upgrade
    sudo apt -y install gcc \
                        g++ \
                        vim \
                        git \
                        mlocate \
                        iftop \
                        sysstat \
                        net-tools \
                        extundelete \
                        dos2unix \
                        tree \
                        wget \
                        curl \
                        exfat-utils \
                        lrzsz \
                        openssh-server \
                        rar \
                        unrar \
                        zip \
                        unzip \
                        make \
                        traceroute \
                        mtr \
                        httping \
                        telnet \
                        vino \
                        libpam-google-authenticator \
                        python-pip \
                        python-virtualenv \
                        python3-pip \
                        python3-virtualenv
    sudo apt -y install ubuntu-gnome-desktop \
                        gnome-tweak-tool \
                        firewall-config \
                        filezilla \
                        virtualbox \
                        shutter \
                        kazam \
                        gimp \
                        qbittorrent \
                        thunderbird \
                        dconf-editor
    sudo apt -y autoremove --purge libreoffice* remmina*
    # wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    # sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    # sudo apt update
    # sudo apt install --assume-yes --fix-broken
    # rm -f chrome-remote-desktop_current_amd64.deb
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg --install google-chrome-stable_current_amd64.deb
    sudo apt update
    sudo apt install --assume-yes --fix-broken
    rm -f google-chrome-stable_current_amd64.deb
    wget https://repo.steampowered.com/steam/archive/precise/steam_latest.deb
    sudo dpkg --install steam_latest.deb
    sudo apt update
    sudo apt install --assume-yes --fix-broken
    rm -f steam_latest.deb
    curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo apt update && sudo apt -y install signal-desktop
    sudo snap install telegram-desktop
    sudo snap install --classic skype
    sudo snap install --classic code
    sudo snap install libreoffice
    sudo snap install vlc
    sudo snap install remmina
    sudo snap install postman
    sudo snap install --classic pycharm-community
    sudo snap install canonical-livepatch
    sudo mv /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com.bakup."$(date +"%Y%m%d%H%M%S")"
    sudo apt -y install gnome-shell-extension-dashtodock gnome-shell-extension-autohidetopbar
    sudo rm -f /var/cache/apt/archives/*.deb
    sudo reboot
}

case $1 in
    desktop)
        desktop
    ;;
esac
