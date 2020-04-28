#!/usr/bin/env bash
# centos script file example
#     ./init.centos7.sh $1
#     ./init.centos7.sh desktop
# Setting up Chrome Remote Desktop on CentOS
#     https://cloud.google.com/solutions/chrome-desktop-remote-on-compute-engine
#     https://remotedesktop.google.com/headless

init_desktop(){
    yum -y update
    yum -y install epel-release
    yum -y install gcc \
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
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
    yum -y install extundelete google-authenticator httping ansible
    yum -y groupinstall "GNOME Desktop"
    sudo ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target
    yum -y install gnome-tweak-tool \
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
    # yum -y install chrome-remote-desktop
    yum -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
    yum -y install https://repo.skype.com/latest/skypeforlinux-64.rpm
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    yum check-update
    yum -y install code
    yum -y install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
    yum -y install vlc vlc-core python-vlc npapi-vlc exfat-utils fuse-exfat
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    yum -y install powershell
}

init_server(){
    yum -y update
    yum -y install epel-release
    yum -y install gcc \
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
                   ethtool \
                   google-authenticator
}

init_iptables(){
    yum -y install iptables-services wget
}

init_firewalld(){
    yum -y install firewalld wget
}

init_sshd(){
    yum -y install openssh-server wget
    mv /etc/ssh/sshd_config /etc/ssh/sshd_config.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/ssh/sshd_config https://0vj6.github.io/sh/init/sshd/sshd_config
    chmod 600 /etc/ssh/sshd_config
    systemctl restart sshd && systemctl status sshd
}

init_ulimit(){
    yum -y install wget
}

init_sudoers(){
    yum -y install wget
}

init_ldconfig(){
    yum -y install wget
}

init_logrotate(){
    yum -y install wget
    mv /etc/logrotate.d/syslog /etc/logrotate.d/syslog.$(date +"%Y%m%d%H%M%S")
    mv /etc/logrotate.d/yum /etc/logrotate.d/yum.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/logrotate.d/syslog https://0vj6.github.io/sh/init/logrotate/syslog
    wget -O /etc/logrotate.d/yum https://0vj6.github.io/sh/init/logrotate/yum
    chmod 644 /etc/logrotate.d/syslog
    chmod 644 /etc/logrotate.d/yum
}

init_vim(){
    yum -y install vim wget
    mv ~/.vimrc ~/.vimrc.$(date +"%Y%m%d%H%M%S")
    wget -O ~/.vimrc https://0vj6.github.io/sh/init/vim/.vimrc
    chmod 600 ~/.vimrc
}

init_rsyslog(){
    yum -y install rsyslog wget
    mv /etc/rsyslog.conf /etc/rsyslog.conf.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/rsyslog.conf https://0vj6.github.io/sh/init/rsyslog/rsyslog.conf
    chmod 644 /etc/rsyslog.conf
    systemctl restart rsyslog && systemctl status rsyslog
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
