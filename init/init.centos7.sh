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
                   ethtool \
                   google-authenticator \
                   extundelete \
                   httping \
                   nmap
    sudo wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
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
    sudo git config --global user.name "root"
    sudo git config --global user.email root@localhost
    sudo git config --list --show-origin
    git config --global user.name "$USER"
    git config --global user.email "$USER"@localhost
    git config --list --show-origin
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
                   ethtool \
                   google-authenticator \
                   extundelete \
                   httping \
                   nmap
    sudo git config --global user.name "root"
    sudo git config --global user.email root@localhost
    sudo git config --list --show-origin
    git config --global user.name "$USER"
    git config --global user.email "$USER"@localhost
    git config --list --show-origin
}

init_iptables(){
    yum -y install iptables-services wget ipset
    systemctl stop firewalld
    systemctl disable firewalld
    systemctl status firewalld
    mv /etc/sysconfig/iptables /etc/sysconfig/iptables.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/sysconfig/iptables https://0vj6.github.io/sh/init/centos7/iptables/iptables
    chmod 600 /etc/sysconfig/iptables
    wget -O /etc/sysconfig/cloudflare_ips-v4 https://www.cloudflare.com/ips-v4
    chmod 600 /etc/sysconfig/cloudflare_ips-v4
    ipset create cloudflare_ips-v4 hash:net maxelem 1000000
    ipset list
    systemctl restart iptables && systemctl status iptables && systemctl enable iptables
    # Example
    # 增加白名单IP
    # ipset add cloudflare_ips-v4 131.0.72.0/22
    #
    # 删除白名单IP
    # ipset del cloudflare_ips-v4 131.0.72.0/22
    # 
    # 通过vim编辑/etc/sysconfig/iptables增加白名单规则
    # -A INPUT -p tcp -m state --state NEW -m tcp -m set --match-set cloudflare_ips-v4 src --dport 80 -m comment --comment "say something" -j ACCEPT
    # service iptables restart
    #
    # 通过iptable命令增加白名单规则
    # iptables -I INPUT -p tcp -m state --state NEW -m tcp -m set --match-set cloudflare_ips-v4 src --dport 80 -m comment --comment "say something" -j ACCEPT
    # service iptables save
    # service iptables restart
    #
    # 将ipset规则保存到文件
    # ipset save cloudflare_ips-v4 -f ~/cloudflare_ips-v4
    # service iptables restart
    #
    # 删除ipset规则
    # ipset destroy cloudflare_ips-v4
    # service iptables restart
    #
    # 导入ipset规则
    # ipset restore -f ~/cloudflare_ips-v4
    # service iptables restart
}

init_firewalld(){
    yum -y install firewalld wget
    systemctl stop iptables
    systemctl disable iptables
    systemctl status iptables
    mv /etc/firewalld/zones/public.xml /etc/firewalld/zones/public.xml.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/firewalld/zones/public.xml https://0vj6.github.io/sh/init/centos7/firewalld/public.xml
    chmod 644 /etc/firewalld/zones/public.xml
    systemctl restart firewalld && systemctl status firewalld && systemctl enable firewalld
}

init_sshd(){
    yum -y install openssh-server wget
    mv /etc/ssh/sshd_config /etc/ssh/sshd_config.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/ssh/sshd_config https://0vj6.github.io/sh/init/centos7/sshd/sshd_config
    chmod 600 /etc/ssh/sshd_config
    systemctl restart sshd && systemctl status sshd && systemctl enable sshd
}

init_ulimit(){
    yum -y install wget
    mv /etc/security/limits.conf /etc/security/limits.conf.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/security/limits.conf https://0vj6.github.io/sh/init/centos7/ulimit/limits.conf
    chmod 644 /etc/security/limits.conf
    mv /etc/security/limits.d/20-nproc.conf /etc/security/limits.d/20-nproc.conf.$(date +"%Y%m%d%H%M%S")
    mv /etc/sysctl.conf /etc/sysctl.conf.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/sysctl.conf https://0vj6.github.io/sh/init/centos7/ulimit/sysctl.conf
    chmod 644 /etc/sysctl.conf
    echo 819200 > /proc/sys/fs/inotify/max_user_watches
    sysctl -p
}

init_sudoers(){
    yum -y install wget
    mv /etc/sudoers /etc/sudoers.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/sudoers https://0vj6.github.io/sh/init/centos7/sudoers/sudoers
    chmod 440 /etc/sudoers
}

init_ldconfig(){
    yum -y install wget
    # echo "/usr/local/mysql/lib" > /etc/ld.so.conf.d/mysql.conf
    # ldconfig
}

init_selinux(){
    yum -y install wget
    mv /etc/selinux/config /etc/selinux/config.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/selinux/config https://0vj6.github.io/sh/init/centos7/selinux/config
    chmod 644 /etc/selinux/config
    setenforce 0
    getenforce
}

init_logrotate(){
    yum -y install wget
    mv /etc/logrotate.d/syslog /etc/logrotate.d/syslog.$(date +"%Y%m%d%H%M%S")
    mv /etc/logrotate.d/yum /etc/logrotate.d/yum.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/logrotate.d/syslog https://0vj6.github.io/sh/init/centos7/logrotate/syslog
    wget -O /etc/logrotate.d/yum https://0vj6.github.io/sh/init/centos7/logrotate/yum
    chmod 644 /etc/logrotate.d/syslog
    chmod 644 /etc/logrotate.d/yum
}

init_vim(){
    yum -y install vim wget
    mv ~/.vimrc ~/.vimrc.$(date +"%Y%m%d%H%M%S")
    wget -O ~/.vimrc https://0vj6.github.io/sh/init/centos7/vim/vimrc
    chmod 600 ~/.vimrc
}

init_rsyslog(){
    yum -y install rsyslog wget
    mv /etc/rsyslog.conf /etc/rsyslog.conf.$(date +"%Y%m%d%H%M%S")
    wget -O /etc/rsyslog.conf https://0vj6.github.io/sh/init/centos7/rsyslog/rsyslog.conf
    chmod 644 /etc/rsyslog.conf
    echo "* * * * * chattr +u /var/log/sshd*"              >> /var/spool/cron/root
    echo "* * * * * chattr +u /var/log/boot*"              >> /var/spool/cron/root
    echo "* * * * * chattr +u /var/log/spooler*"           >> /var/spool/cron/root
    echo "* * * * * chattr +u /var/log/cron*"              >> /var/spool/cron/root
    echo "* * * * * chattr +u /var/log/maillog*"           >> /var/spool/cron/root
    echo "* * * * * chattr +u /var/log/secure*"            >> /var/spool/cron/root
    echo "* * * * * chattr +u /var/log/messages*"          >> /var/spool/cron/root
    echo "* * * * * chattr +u /var/log/yum*"               >> /var/spool/cron/root
    systemctl restart rsyslog && systemctl status rsyslog && systemctl enable rsyslog
}

init_profile(){
    yum -y install wget
    wget -O /etc/profile https://0vj6.github.io/sh/init/centos7/profile/profile
    chmod 644 /etc/profile
    echo "* * * * * chattr +a /tmp/.*timing" >> /var/spool/cron/root
    echo "* * * * * chattr +a /tmp/.*record" >> /var/spool/cron/root
    echo "* * * * * chattr +u /tmp/.*timing" >> /var/spool/cron/root
    echo "* * * * * chattr +u /tmp/.*record" >> /var/spool/cron/root
    chmod 600 /var/spool/cron/root
}

init_other(){
    mv /etc/issue              /etc/issue.$(date +"%Y%m%d%H%M%S")
    mv /etc/issue.net          /etc/issue.net.$(date +"%Y%m%d%H%M%S")
    mv /etc/redhat-release     /etc/redhat-release.$(date +"%Y%m%d%H%M%S")
    mv /etc/centos-release     /etc/centos-release.$(date +"%Y%m%d%H%M%S")
    chmod +x /etc/rc.d/rc.local
    chmod +x /etc/rc.local
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
    profile)
        init_profile
    ;;
    other)
        init_other
    ;;
esac
