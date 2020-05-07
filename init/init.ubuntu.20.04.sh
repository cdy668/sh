#!/usr/bin/env bash
# Ubuntu script file example
#     ./init.ubuntu.20.04.sh $1
#     ./init.ubuntu.20.04.sh desktop
# Setting up Chrome Remote Desktop on Compute Engine
#     https://cloud.google.com/solutions/chrome-desktop-remote-on-compute-engine
#     https://remotedesktop.google.com/headless

init_desktop(){
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
                        dos2unix \
                        tree \
                        sudo wget \
                        curl \
                        lrzsz \
                        openssh-server \
                        zip \
                        unzip \
                        make \
                        traceroute \
                        mtr \
                        telnet \
                        python3-pip \
                        python3-virtualenv \
                        lsb-release \
                        ansible \
                        cockpit \
                        cockpit-ws \
                        cockpit-dashboard \
                        cockpit-storaged \
                        ethtool \
                        libpam-google-authenticator \
                        extundelete \
                        httping \
                        nmap \
                        whois \
                        exfat-utils \
                        rar \
                        unrar \
                        hydra \
                        sqlmap
    sudo apt -y install python-pip \
                        python-virtualenv
    # Compile and use for FileZilla on Ubuntu 20.04 LTS
    # sudo apt -y install nettle-dev \
    #                     libghc-gnutls-dev \
    #                     gettext \
    #                     libwxgtk3.0-gtk3-dev \
    #                     libpugixml-dev \
    #                     libdbus-1-dev \
    #                     libgtk-3-dev \
    #                     libsqlite3-dev
    sudo apt -y install ubuntu-gnome-desktop \
                        ubuntu-desktop \
                        gnome-tweak-tool \
                        gnome-tweaks \
                        firewall-config \
                        filezilla \
                        virtualbox \
                        kazam \
                        gimp \
                        qbittorrent \
                        thunderbird \
                        dconf-editor \
                        wireshark \
                        fcitx \
                        fcitx-frontend-gtk2 \
                        fcitx-frontend-gtk3 \
                        fcitx-libpinyin \
                        fcitx-libs \
                        fcitx-module-kimpanel \
                        vino
    # sudo apt -y install telegram-desktop
    sudo apt -y install shutter
    sudo apt -y install fcitx-frontend-qt4
    sudo apt -y autoremove --purge libreoffice* remmina* firefox* firefox-locale*
    sudo apt -y autoremove --purge libreoffice-base-core \
                                   libreoffice-calc \
                                   libreoffice-common \
                                   libreoffice-core \
                                   libreoffice-draw \
                                   libreoffice-gnome \
                                   libreoffice-gtk3 \
                                   libreoffice-impress \
                                   libreoffice-math \
                                   libreoffice-pdfimport \
                                   libreoffice-style-breeze \
                                   libreoffice-style-colibre \
                                   libreoffice-style-colibre \
                                   libreoffice-style-tango \
                                   libreoffice-writer
    sudo apt -y autoremove --purge remmina
    sudo apt -y autoremove --purge firefox
    # sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb
    # sudo dpkg --install mysql-apt-config_0.8.15-1_all.deb
    # sudo apt update
    # sudo apt install --assume-yes --fix-broken
    # sudo rm -f mysql-apt-config_0.8.15-1_all.deb
    # sudo wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
    # sudo dpkg --install percona-release_latest.$(lsb_release -sc)_all.deb
    # sudo apt update
    # sudo apt install --assume-yes --fix-broken
    # sudo rm -f percona-release_latest.$(lsb_release -sc)_all.deb
    # sudo wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
    # sudo dpkg --install chrome-remote-desktop_current_amd64.deb
    # sudo apt update
    # sudo apt install --assume-yes --fix-broken
    # sudo rm -f chrome-remote-desktop_current_amd64.deb
    sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg --install google-chrome-stable_current_amd64.deb
    sudo apt update
    sudo apt install --assume-yes --fix-broken
    sudo rm -f google-chrome-stable_current_amd64.deb
    sudo wget https://repo.steampowered.com/steam/archive/precise/steam_latest.deb
    sudo dpkg --install steam_latest.deb
    sudo apt update
    sudo apt install --assume-yes --fix-broken
    sudo rm -f steam_latest.deb
    sudo apt -y install libextutils-depends-perl libextutils-pkgconfig-perl
    sudo wget https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas-common_1.0.0-1_all.deb
    sudo wget https://launchpad.net/ubuntu/+archive/primary/+files/libgoocanvas3_1.0.0-1_amd64.deb
    sudo wget https://launchpad.net/ubuntu/+archive/primary/+files/libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb
    sudo dpkg --install libgoocanvas-common_1.0.0-1_all.deb libgoocanvas3_1.0.0-1_amd64.deb libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb
    sudo apt update
    sudo apt install --assume-yes --fix-broken
    sudo rm -f libgoocanvas-common_1.0.0-1_all.deb libgoocanvas3_1.0.0-1_amd64.deb libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb
    curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo apt update && sudo apt -y install signal-desktop
    sudo wget https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
    sudo dpkg --install nordvpn-release_1.0.0_all.deb
    sudo apt update
    sudo apt install --assume-yes --fix-broken
    sudo rm -f nordvpn-release_1.0.0_all.deb
    # sudo wget https://repo.skype.com/latest/skypeforlinux-64.deb
    # sudo dpkg --install skypeforlinux-64.deb
    # sudo apt update
    # sudo apt install --assume-yes --fix-broken
    # sudo rm -f skypeforlinux-64.deb
    sudo wget https://dl.discordapp.net/apps/linux/0.0.10/discord-0.0.10.deb
    sudo dpkg --install discord-0.0.10.deb
    sudo apt update
    sudo apt install --assume-yes --fix-broken
    sudo rm -f discord-0.0.10.deb
    sudo snap install telegram-desktop
    sudo snap install --classic skype
    sudo snap install --classic code
    sudo snap install libreoffice
    sudo snap install vlc
    sudo snap install remmina
    sudo snap install postman
    sudo snap install --classic pycharm-community
    sudo snap install canonical-livepatch
    sudo snap install firefox
    sudo snap install --classic powershell
    sudo mv /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com /usr/share/gnome-shell/extensions/ubuntu-dock@ubuntu.com.bakup."$(date +"%Y%m%d%H%M%S")"
    sudo apt -y install gnome-shell-extension-ubuntu-dock gnome-shell-extension-autohidetopbar
    sudo apt -y install gnome-shell-extension-dashtodock
    sudo rm -f /var/cache/apt/archives/*.deb
    sudo git config --global user.name "root"
    sudo git config --global user.email root@localhost
    sudo git config --list --show-origin
    git config --global user.name "$USER"
    git config --global user.email "$USER"@localhost
    git config --list --show-origin
}

init_server(){
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
                        dos2unix \
                        tree \
                        sudo wget \
                        curl \
                        lrzsz \
                        openssh-server \
                        zip \
                        unzip \
                        make \
                        traceroute \
                        mtr \
                        telnet \
                        python3-pip \
                        python3-virtualenv \
                        lsb-release \
                        ansible \
                        cockpit \
                        cockpit-ws \
                        cockpit-dashboard \
                        cockpit-storaged \
                        ethtool \
                        libpam-google-authenticator \
                        extundelete \
                        httping \
                        nmap \
                        whois \
                        exfat-utils \
                        rar \
                        unrar \
                        hydra \
                        sqlmap
    sudo apt -y install python-pip \
                        python-virtualenv
    sudo git config --global user.name "root"
    sudo git config --global user.email root@localhost
    sudo git config --list --show-origin
    git config --global user.name "$USER"
    git config --global user.email "$USER"@localhost
    git config --list --show-origin
}

case $1 in
    desktop)
        init_desktop
    ;;
    server)
        init_server
    ;;
esac
