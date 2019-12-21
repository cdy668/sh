#!/usr/bin/env bash
# centos script file example
#     ./init.centos7.sh $1
#     ./init.centos7.sh desktop

desktop(){
    sudo yum -y update
    sudo yum -y install gcc \
                        gcc-c++ \
                        vim \
                        git \
                        mlocate \
                        iftop \
                        sysstat \
                        net-tools \
                        dos2unix \
                        tree \
                        wget \
                        curl \
                        lrzsz \
                        openssh-server \
                        zip \
                        unzip \
                        make \
                        traceroute \
                        mtr \
                        telnet \
                        vino \
                        python2-pip \
                        python3-pip \
                        python*virtualenv \
                        redhat-lsb \
                        yum-utils \
                        ansible \
                        epel-release
    sudo wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
    sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    sudo yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
    sudo yum -y install extundelete google-authenticator httping ansible
    sudo yum -y groupinstall "GNOME Desktop"
    sudo ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
    sudo yum -y install gnome-tweak-tool \
                        firewall-config \
                        filezilla \
                        gimp \
                        qbittorrent \
                        thunderbird \
                        dconf-editor \
                        libreoffice \
                        remmina \
                        firefox \
                        fcitx \
                        fcitx-pinyin \
                        fcitx-data \
                        fcitx-gtk2 \
                        fcitx-gtk3 \
                        fcitx-libs \
                        fcitx-configtool
    # sudo yum -y install chrome-remote-desktop
    sudo yum -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    sudo yum -y install https://repo.skype.com/latest/skypeforlinux-64.rpm
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    sudo yum check-update
    sudo yum -y install code
    sudo yum -y install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
    sudo yum -y install vlc vlc-core python-vlc npapi-vlc exfat-utils fuse-exfat
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    sudo yum -y install powershell
    sudo reboot
}

case $1 in
    desktop)
        desktop
    ;;
esac
