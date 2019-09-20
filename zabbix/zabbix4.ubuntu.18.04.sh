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
        setenforce 0
        apt -y install bc net-tools wget curl
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
        apt update
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
        # Although Zabbix server 4.2 is not working on centos 6.x, But you can compile the source code
        # If your zabbix version is 4.0.x, maybe you will see something in /var/log/httpd/error_log
        # Look at this in /var/log/httpd/error_log
        #     configuration error:  couldn't perform authentication. AuthType not set!: /zabbix/
        # Maybe you have to upgrade httpd version to 2.4 or change web server
        # If you choose nginx, you have to know how to configuration
        systemctl daemon-reload
        systemctl stop zabbix-agent
        systemctl stop zabbix-server
        systemctl stop httpd
        apt -y autoremove --purge zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-get zabbix-release apache2 mysql-client
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
        rm -fr /etc/apache2
        setenforce 0
        apt -y install bc net-tools wget curl mysql-client
        curl -sSL https://0vj6.github.io/sh/mysql/mysql57.ubuntu.18.04.en.sh | bash -s init 5.7.26 | tee /tmp/init_mysql.log 2>&1
        mysql_root_password="$(grep "^Please remember your MySQL database root password" /tmp/init_mysql.log | awk '{print $NF}')"
        rm -f /tmp/init_mysql.log
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
        apt update
        apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-get apache2
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
        sed -i "s/# DBSocket=/DBSocket=\/tmp\/mysql.sock/" /etc/zabbix/zabbix_server.conf
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
        if [[ ! -f /etc/zabbix/apache.conf ]]; then
            wget https://0vj6.github.io/sh/zabbix/apache.conf -O /etc/zabbix/apache.conf
            ln -s /etc/zabbix/apache.conf /etc/apache2/conf-available/apache.conf
            ln -s /etc/apache2/conf-available/apache.conf /etc/apache2/conf-enabled/zabbix.conf
        fi
        cp /etc/zabbix/apache.conf /etc/zabbix/apache.conf.bak
        cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
        mv /var/www/html/index.html /var/www/html/index.html.bak
        sed -i "s/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Shanghai/" /etc/zabbix/apache.conf
        sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/apache2/apache2.conf
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
        chown www-data:www-data /etc/zabbix/web/zabbix.conf.php
        chmod 644 /etc/zabbix/web/zabbix.conf.php
        systemctl restart zabbix-server
        systemctl enable zabbix-server
        systemctl status zabbix-server
        systemctl restart apache2
        systemctl enable apache2
        systemctl status apache2
        echo "http://127.0.0.1/zabbix Admin@$website_password"
    elif [[ "$1" = "proxy" ]] && [[ "$2" =~ ^4 ]]; then
        echo "I am not ready yet"
    elif [[ "$1" = "java" ]] && [[ "$2" =~ ^4 ]]; then
        echo "I am not ready yet"
    elif [[ "$1" = "agent" ]]; then
        apt -y update
        apt -y upgrade zabbix-agent
        systemctl restart zabbix-agent
        systemctl enable zabbix-agent
        systemctl status zabbix-agent
    elif [[ "$1" = "server" ]]; then
        apt -y update
        apt -y upgrade zabbix-server
        systemctl restart zabbix-server
        systemctl enable zabbix-server
        systemctl status zabbix-server
    elif [[ "$1" = "proxy" ]]; then
        echo "I am not ready yet"
    elif [[ "$1" = "java" ]]; then
        echo "I am not ready yet"
    else
        echo "I am not ready yet"
    fi
}

case $1 in
    init)
        init "$2" "$3"
    ;;
    update)
        update "$2" "$3"
    ;;
esac
