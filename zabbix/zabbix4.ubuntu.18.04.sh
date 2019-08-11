#!/usr/bin/env bash
# zabbix script file example
#     ./zabbix4.ubuntu.18.04.sh $1 $2 $3
#     ./zabbix4.ubuntu.18.04.sh init agent 4.0

init() {
    if [[ "$1" = "agent" ]] && [[ "$2" =~ ^4 ]]; then
        systemctl daemon-reload
        systemctl stop zabbix-agent
        apt -y autoremove --purge zabbix-agent zabbix-release
        userdel -r zabbix
        rm -fr /etc/zabbix
        rm -fr /var/log/zabbix
        rm -fr /etc/selinux/targeted/active/modules/100/zabbix
        rm -fr /etc/selinux/targeted/tmp/modules/100/zabbix
        rm -fr /var/cache/yum/x86_64/7/zabbix*
        rm -fr /var/lib/yum/repos/x86_64/7/zabbix*
        rm -fr /usr/lib/zabbix*
        rm -f /usr/lib/firewalld/services/zabbix*
        rm -f /etc/init.d/zabbix*
        rm -fr /etc/rc.d/rc2.d/S90zabbix*
        rm -fr /etc/rc.d/rc3.d/S90zabbix*
        rm -fr /etc/rc.d/rc4.d/S90zabbix*
        rm -fr /etc/rc.d/rc5.d/S90zabbix*
        rm -f /var/lib/alternatives/zabbix-web-font
        apt install bc net-tools wget curl
        if [[ "$2" =~ ^4.2 ]]; then
            wget https://repo.zabbix.com/zabbix/$2/ubuntu/pool/main/z/zabbix-release/zabbix-release_$2-2+bionic_all.deb
            dpkg -i zabbix-release_$2-2+bionic_all.deb
            apt update
            rm -f zabbix-release_$2-2+bionic_all.deb
        elif [[ "$2" =~ ^4.0 ]]; then
            wget https://repo.zabbix.com/zabbix/$2/ubuntu/pool/main/z/zabbix-release/zabbix-release_$2-3+bionic_all.deb
            dpkg -i zabbix-release_$2-3+bionic_all.deb
            rm -f zabbix-release_$2-3+bionic_all.deb
        fi
        apt -y install zabbix-agent
        cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak
        sed -i "s/# ListenPort=10050/ListenPort=10050/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/Hostname=Zabbix server/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# RefreshActiveChecks=120/RefreshActiveChecks=60/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# BufferSend=5/BufferSend=5/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# BufferSize=100/BufferSize=100/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# StartAgents=3/StartAgents=10/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# Timeout=3/Timeout=30/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# AllowRoot=0/AllowRoot=1/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# User=zabbix/User=root/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# ListenIP=0.0.0.0/ListenIP=0.0.0.0/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# DebugLevel=3/DebugLevel=3/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/Server=127.0.0.1/Server=zabbix_server/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/ServerActive=127.0.0.1/ServerActive=zabbix_server/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/LogFileSize=0/LogFileSize=1024/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# LogType=file/LogType=file/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# TLSConnect=unencrypted/TLSConnect=unencrypted/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# TLSAccept=unencrypted/TLSAccept=unencrypted/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# TLSPSKIdentity=/TLSPSKIdentity=unencrypted/" /etc/zabbix/zabbix_agentd.conf
        sed -i "s/# TLSPSKFile=/TLSPSKFile=\/etc\/zabbix\/psk\/zabbix-agent.psk/" /etc/zabbix/zabbix_agentd.conf
        mkdir -p /etc/zabbix/scripts /etc/zabbix/psk
        openssl rand -hex 32 > /etc/zabbix/psk/zabbix-agent.psk
        systemctl restart zabbix-agent
        systemctl enable zabbix-agent
        systemctl status zabbix-agent
    elif [[ "$1" = "server" ]] && [[ "$2" =~ ^4 ]]; then
        echo "I am not ready yet"
    elif [[ "$1" = "proxy" ]] && [[ "$2" =~ ^4 ]]; then
        echo "I am not ready yet"
    elif [[ "$1" = "java" ]] && [[ "$2" =~ ^4 ]]; then
        echo "I am not ready yet"
    else
        echo "I am not ready yet"
    fi
}

case $1 in
    init)
        init "$2" "$3"
    ;;
esac
