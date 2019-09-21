#!/usr/bin/env bash
# vsftpd script file example
#     ./vsftpd.centos7.sh $1
#     ./vsftpd.centos7.sh init

init(){
    systemctl stop vsftpd
    systemctl status vsftpd
    yum -y autoremove vsftpd
    userdel -r administrator
    rm -fr /etc/vsftpd
    rm -f /var/log/vsftpd.log*
    rm -f /var/log/xferlog*
    setenforce 0
    yum -y install vsftpd
    sed -i "s/anonymous_enable=YES/anonymous_enable=NO/"                                 /etc/vsftpd/vsftpd.conf
    sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/"                            /etc/vsftpd/vsftpd.conf
    sed -i "s/#anon_mkdir_write_enable=NO/anon_mkdir_write_enable=NO/"                   /etc/vsftpd/vsftpd.conf
    sed -i "s/#xferlog_file=\/var\/log\/xferlog/xferlog_file=\/var\/log\/xferlog/"       /etc/vsftpd/vsftpd.conf
    sed -i "s/#idle_session_timeout=600/idle_session_timeout=600/"                       /etc/vsftpd/vsftpd.conf
    sed -i "s/#data_connection_timeout=120/data_connection_timeout=120/"                 /etc/vsftpd/vsftpd.conf
    sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/"                             /etc/vsftpd/vsftpd.conf
    echo "allow_writeable_chroot=YES"                                                 >> /etc/vsftpd/vsftpd.conf
    echo "guest_enable=YES"                                                           >> /etc/vsftpd/vsftpd.conf
    echo "guest_username=administrator"                                               >> /etc/vsftpd/vsftpd.conf
    echo "user_config_dir=/etc/vsftpd/virtual_user_conf"                              >> /etc/vsftpd/vsftpd.conf
    echo "virtual_use_local_privs=YES"                                                >> /etc/vsftpd/vsftpd.conf
    echo "dual_log_enable=YES"                                                        >> /etc/vsftpd/vsftpd.conf
    echo "vsftpd_log_file=/var/log/vsftpd.log"                                        >> /etc/vsftpd/vsftpd.conf
    echo -e "administrator\n$(openssl rand -base64 20)" > /etc/vsftpd/virtual_user
    chmod 600 /etc/vsftpd/virtual_user
    db_load -T -t hash -f /etc/vsftpd/virtual_user /etc/vsftpd/virtual_user.db
    chmod 600 /etc/vsftpd/virtual_user.db
    useradd -s /usr/sbin/nologin -m -d /home/administrator -c 'ftp virtual user' administrator
    mv /etc/pam.d/vsftpd /etc/pam.d/vsftpd.bak
    echo "auth    required /usr/lib64/security/pam_userdb.so db=/etc/vsftpd/virtual_user" > /etc/pam.d/vsftpd
    echo "account required /usr/lib64/security/pam_userdb.so db=/etc/vsftpd/virtual_user" >> /etc/pam.d/vsftpd
    mkdir -p /etc/vsftpd/virtual_user_conf
    echo "local_root=/home/administrator"                > /etc/vsftpd/virtual_user_conf/administrator
    echo "write_enable=YES"                              >> /etc/vsftpd/virtual_user_conf/administrator
    echo "anonymous_enable=NO"                           >> /etc/vsftpd/virtual_user_conf/administrator
    echo "local_umask=022"                               >> /etc/vsftpd/virtual_user_conf/administrator
    echo "anon_upload_enable=YES"                        >> /etc/vsftpd/virtual_user_conf/administrator
    echo "anon_mkdir_write_enable=YES"                   >> /etc/vsftpd/virtual_user_conf/administrator
    echo "anon_other_write_enable=YES"                   >> /etc/vsftpd/virtual_user_conf/administrator
    echo "anon_world_readable_only=YES"                  >> /etc/vsftpd/virtual_user_conf/administrator
    echo "download_enable=YES"                           >> /etc/vsftpd/virtual_user_conf/administrator
    systemctl enable vsftpd
    systemctl start vsftpd
    systemctl status vsftpd
    cat /etc/vsftpd/virtual_user
    echo "don't forget delete this file /etc/vsftpd/virtual_user"
}

case $1 in
    init)
        init
    ;;
esac
