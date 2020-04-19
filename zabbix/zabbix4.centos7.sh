#!/usr/bin/env bash
# zabbix script file example
#     ./zabbix4.centos7.sh $1 $2 $3
#     ./zabbix4.centos7.sh init agent 4.0

init() {
    if [[ "$1" = "agent" ]] && [[ "$2" =~ ^4 ]]; then
        systemctl daemon-reload
        systemctl stop zabbix-agent
        yum -y autoremove zabbix-agent zabbix-release
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
        setenforce 0
        if [[ "$2" = "4.0" ]];then
            yum -y install https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
            yum clean all
        elif [[ "$2" =~ ^4.2|^4.4 ]];then
            yum -y install https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
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
        systemctl restart zabbix-agent
        systemctl enable zabbix-agent
        systemctl status zabbix-agent
    elif [[ "$1" = "server" ]] && [[ "$2" =~ ^4 ]]; then
        systemctl daemon-reload
        systemctl stop zabbix-agent
        systemctl stop zabbix-server
        systemctl stop httpd
        yum -y autoremove zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-get zabbix-web zabbix-release httpd
        userdel -r zabbix
        rm -fr /etc/zabbix
        rm -fr /var/log/zabbix
        rm -fr /etc/selinux/targeted/active/modules/100/zabbix
        rm -fr /etc/selinux/targeted/tmp/modules/100/zabbix
        rm -fr /var/cache/yum/x86_64/7/zabbix*
        rm -fr /var/lib/yum/repos/x86_64/7/zabbix*
        rm -fr /usr/lib/zabbix
        rm -f /usr/lib/firewalld/services/zabbix*
        rm -fr /etc/httpd
        rm -fr /var/log/httpd
        rm -f /etc/init.d/zabbix*
        rm -fr /usr/share/zabbix
        rm -fr /etc/rc.d/rc2.d/S90zabbix*
        rm -fr /etc/rc.d/rc3.d/S90zabbix*
        rm -fr /etc/rc.d/rc4.d/S90zabbix*
        rm -fr /etc/rc.d/rc5.d/S90zabbix*
        rm -f /var/lib/alternatives/zabbix-web-font
        setenforce 0
        yum -y install bc net-tools wget curl chkconfig
        curl -sSL https://0vj6.github.io/sh/mysql/mysql57.centos7.en.sh | bash -s init 5.7.26 | tee /tmp/init_mysql.log 2>&1
        mysql_root_password="$(grep "^Please remember your MySQL database root password" /tmp/init_mysql.log | awk '{print $NF}')"
        rm -f /tmp/init_mysql.log
        curl -sSL https://0vj6.github.io/sh/php/php.centos7.sh | bash -s init php54
        if [[ "$2" = "4.0" ]];then
            yum -y install https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
            yum clean all
        elif [[ "$2" =~ ^4.2|^4.4 ]];then
            yum -y install https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
            yum clean all
        fi
        yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-get zabbix-web httpd
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
        cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.bak
        mysql_zabbix_password="$(openssl rand -base64 20)"
        mysql -u"root" -p"$mysql_root_password" -h"localhost" -e "DROP DATABASE zabbix;"
        mysql -u"root" -p"$mysql_root_password" -h"localhost" -e "DELETE FROM mysql.user WHERE User='zabbix';"
        mysql -u"root" -p"$mysql_root_password" -h"localhost" -e "create database zabbix character set utf8 collate utf8_bin;"
        mysql -u"root" -p"$mysql_root_password" -h"localhost" -e "create user 'zabbix'@'127.0.0.1' IDENTIFIED BY '$mysql_zabbix_password';"
        mysql -u"root" -p"$mysql_root_password" -h"localhost" -e "grant all privileges on zabbix.* to zabbix@127.0.0.1;"
        mysql -u"root" -p"$mysql_root_password" -h"localhost" -e "FLUSH PRIVILEGES;"
        zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix"
        website_password="$(openssl rand -base64 20)"
        website_password_md5="$(echo -n "$website_password" | md5sum | awk '{print $1}')"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.users SET lang = 'en_GB' WHERE alias = 'Admin'"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.users SET theme = 'dark-theme' WHERE alias = 'Admin'"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.users SET passwd = '$website_password_md5' WHERE alias = 'Admin'"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.config SET default_theme = 'dark-theme' WHERE configid = 1"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.usrgrp SET gui_access = 3 WHERE name = 'Disabled'"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.usrgrp SET gui_access = 3, debug_mode = 0, users_status = 1 WHERE name = 'Enabled debug mode'"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.usrgrp SET gui_access = 3, users_status = 1 WHERE name = 'Guests'"
        mysql -u"zabbix" -p"$mysql_zabbix_password" -h"127.0.0.1" -D"zabbix" -e "UPDATE zabbix.usrgrp SET users_status = 1 WHERE name = 'No access to the frontend'"
        sed -i "s/# DBHost=localhost/DBHost=127.0.0.1/" /etc/zabbix/zabbix_server.conf
        echo "DBPassword=$mysql_zabbix_password" >> /etc/zabbix/zabbix_server.conf
        sed -i "s/# DBPort=/DBPort=3306/" /etc/zabbix/zabbix_server.conf
        sed -i "s/# ListenPort=10051/ListenPort=10051/" /etc/zabbix/zabbix_server.conf
        sed -i "s/# ListenIP=0.0.0.0/ListenIP=0.0.0.0/" /etc/zabbix/zabbix_server.conf
        sed -i "s/Timeout=4/Timeout=30/" /etc/zabbix/zabbix_server.conf
        sed -i "s/# AllowRoot=0/AllowRoot=1/" /etc/zabbix/zabbix_server.conf
        sed -i "s/# User=zabbix/User=root/" /etc/zabbix/zabbix_server.conf
        sed -i "s/AlertScriptsPath=\/usr\/lib\/zabbix\/alertscripts/AlertScriptsPath=\/etc\/zabbix\/scripts/" /etc/zabbix/zabbix_server.conf
        sed -i "s/ExternalScripts=\/usr\/lib\/zabbix\/externalscripts/ExternalScripts=\/etc\/zabbix\/scripts/" /etc/zabbix/zabbix_server.conf
        sed -i "s/# LogType=file/LogType=file/" /etc/zabbix/zabbix_server.conf
        sed -i "s/# DebugLevel=3/DebugLevel=3/" /etc/zabbix/zabbix_server.conf
        sed -i "s/LogFileSize=0/LogFileSize=1024/" /etc/zabbix/zabbix_server.conf
        if [[ ! -f /etc/httpd/conf.d/zabbix.conf ]]; then
            wget https://0vj6.github.io/sh/zabbix/zabbix.conf -O /etc/httpd/conf.d/zabbix.conf
        fi
        cp /etc/httpd/conf.d/zabbix.conf /etc/httpd/conf.d/zabbix.conf.bak
        cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
        mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak
        sed -i "s/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Shanghai/" /etc/httpd/conf.d/zabbix.conf
        sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
        echo -e "<?php" > /etc/zabbix/web/zabbix.conf.php
        echo -e "// Zabbix GUI configuration file." >> /etc/zabbix/web/zabbix.conf.php
        echo -e "global \$DB;" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$DB['TYPE']     = 'MYSQL';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$DB['SERVER']   = '127.0.0.1';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$DB['PORT']     = '3306';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$DB['DATABASE'] = 'zabbix';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$DB['USER']     = 'zabbix';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$DB['PASSWORD'] = '$mysql_zabbix_password';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "// Schema name. Used for IBM DB2 and PostgreSQL." >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$DB['SCHEMA'] = '';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$ZBX_SERVER      = '127.0.0.1';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$ZBX_SERVER_PORT = '10051';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$ZBX_SERVER_NAME = '$(hostname)';" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;" >> /etc/zabbix/web/zabbix.conf.php
        echo -e "?>" >> /etc/zabbix/web/zabbix.conf.php
        chown apache:apache /etc/zabbix/web/zabbix.conf.php
        chmod 644 /etc/zabbix/web/zabbix.conf.php
        systemctl restart zabbix-server
        systemctl enable zabbix-server
        systemctl status zabbix-server
        systemctl restart httpd
        systemctl enable httpd
        systemctl status httpd
        echo "http://0.0.0.0/zabbix Admin@$website_password"
    fi
}

case $1 in
    init)
        init "$2" "$3"
    ;;
esac
