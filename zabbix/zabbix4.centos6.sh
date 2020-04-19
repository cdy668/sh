#!/usr/bin/env bash
# zabbix script file example
#     ./zabbix4.centos6.sh $1 $2 $3
#     ./zabbix4.centos6.sh init agent 4.0

init() {
    if [[ "$1" = "agent" ]] && [[ "$2" =~ ^4 ]]; then
        service zabbix-agent stop
        yum -y remove zabbix-agent zabbix-release
        userdel -r zabbix
        rm -fr /etc/zabbix
        rm -f /etc/selinux/targeted/modules/active/modules/zabbix*
        rm -f /usr/share/selinux/devel/include/services/zabbix*
        rm -f /usr/share/selinux/targeted/zabbix*
        rm -fr /var/cache/yum/x86_64/6/zabbix*
        rm -fr /var/lib/yum/repos/x86_64/6/zabbix*
        rm -fr /var/log/zabbix
        setenforce 0
        if [[ "$2" = "4.0" ]];then
            yum -y install https://repo.zabbix.com/zabbix/4.0/rhel/6/x86_64/zabbix-release-4.0-2.el6.noarch.rpm
            yum clean all
        elif [[ "$2" =~ ^4.2|^4.4 ]];then
            yum -y install https://repo.zabbix.com/zabbix/4.4/rhel/6/x86_64/zabbix-release-4.4-1.el6.noarch.rpm
            yum clean all
        fi
        yum -y install zabbix-agent
        yum -y install bc
        yum -y install net-tools
        yum -y install wget
        yum -y install curl
        yum -y install chkconfig
        yum -y install mtr
        yum -y install mlocate
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
        service zabbix-agent restart
        chkconfig zabbix-agent on
        service zabbix-agent status 
    fi
}

case $1 in
    init)
        init "$2" "$3"
    ;;
esac
