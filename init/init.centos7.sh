#!/usr/bin/env bash
# centos script file example
#     ./init.centos7.sh $1
#     ./init.centos7.sh desktop
# Setting up Chrome Remote Desktop on CentOS
#     https://cloud.google.com/solutions/chrome-desktop-remote-on-compute-engine
#     https://remotedesktop.google.com/headless

init_desktop(){
    sudo yum -y update
    sudo yum -y install epel-release
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
                        python2-pip \
                        python3-pip \
                        python*virtualenv \
                        redhat-lsb \
                        yum-utils \
                        ansible \
                        cockpit \
                        cockpit-ws \
                        cockpit-dashboard \
                        cockpit-storaged \
                        chkconfig \
                        tcping \
                        ipset \
                        ethtool
    sudo wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
    sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    sudo yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
    sudo yum -y install extundelete google-authenticator httping ansible
    sudo yum -y groupinstall "GNOME Desktop"
    sudo ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
    sudo yum -y install gnome-tweak-tool \
                        firewalld-config \
                        filezilla \
                        gimp \
                        qbittorrent \
                        thunderbird \
                        dconf-editor \
                        libreoffice \
                        remmina \
                        firefox \
                        vino \
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
}

init_server(){
    sudo yum -y update
    sudo yum -y install epel-release
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
                        python2-pip \
                        python3-pip \
                        python*virtualenv \
                        redhat-lsb \
                        yum-utils \
                        ansible \
                        cockpit \
                        cockpit-ws \
                        cockpit-dashboard \
                        cockpit-storaged \
                        chkconfig \
                        tcping \
                        ipset \
                        ethtool
}

init_iptables(){
    sudo yum -y update iptables-services
}

init_firewalld(){
    sudo yum -y update firewalld
}

init_sshd(){
    sudo yum -y update openssh-server
}

init_ulimit(){
    echo "not ready"
}

init_sudoers(){
    echo "not ready"
}

init_ldconfig(){
    echo "not ready"
}

init_logrotate(){
    echo "not ready"
}

init_vim(){
    echo "not ready"
}

init_rsyslog(){
    echo "not ready"
}

case $1 in
    desktop)
        init_desktop
    ;;
    server)
        init_server
    ;;
    iptables)
        init_iptables
    ;;
    firewalld)
        init_firewalld
    ;;
    sshd)
        init_sshd
    ;;
    ulimit)
        init_ulimit
    ;;
    sudoers)
        init_sudoers
    ;;
    ldconfig)
        init_ldconfig
    ;;
    selinux)
        init_selinux
    ;;
    logrotate)
        init_logrotate
    ;;
    vim)
        init_vim
    ;;
    rsyslog)
        init_rsyslog
    ;;
esac
