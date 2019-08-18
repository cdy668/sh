#!/usr/bin/env bash
# nginx script file example
#     ./nginx.centos6.sh $1 $2 $3
#     ./nginx.centos6.sh init stable 1.16.0
#     ./nginx.centos6.sh init mainline 1.17.3

init(){
    service nginx stop
    service nginx status
    yum -y remove nginx
    rm -fr /etc/nginx
    rm -fr /var/cache/nginx
    rm -fr /var/cache/yum/x86_64/6/nginx
    rm -fr /var/lib/yum/repos/x86_64/6/nginx
    rm -fr /var/log/nginx
    rm -f /etc/yum.repos.d/nginx.repo
    # rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n'
    # rpm -e gpg-pubkey-7bd9bf62-5762b5f8
    yum -y install yum-utils
    echo "[nginx-stable]"                                              > /etc/yum.repos.d/nginx.repo
    echo "name=nginx stable repo"                                      >> /etc/yum.repos.d/nginx.repo
    echo "baseurl=http://nginx.org/packages/centos/6/x86_64/"          >> /etc/yum.repos.d/nginx.repo
    echo "gpgcheck=1"                                                  >> /etc/yum.repos.d/nginx.repo
    echo "enabled=0"                                                   >> /etc/yum.repos.d/nginx.repo
    echo "gpgkey=https://nginx.org/keys/nginx_signing.key"             >> /etc/yum.repos.d/nginx.repo
    echo "[nginx-mainline]"                                            >> /etc/yum.repos.d/nginx.repo
    echo "name=nginx mainline repo"                                    >> /etc/yum.repos.d/nginx.repo
    echo "baseurl=http://nginx.org/packages/mainline/centos/6/x86_64/" >> /etc/yum.repos.d/nginx.repo
    echo "gpgcheck=1"                                                  >> /etc/yum.repos.d/nginx.repo
    echo "enabled=0"                                                   >> /etc/yum.repos.d/nginx.repo
    echo "gpgkey=https://nginx.org/keys/nginx_signing.key"             >> /etc/yum.repos.d/nginx.repo
    chmod 644 /etc/yum.repos.d/nginx.repo
    if [[ "$1" = "stable" ]] ; then
        yum-config-manager --enable nginx-stable
        yum -y install https://nginx.org/packages/centos/6/x86_64/RPMS/nginx-$2-1.el6.ngx.x86_64.rpm
    elif [[ "$1" = "mainline" ]]; then
        yum-config-manager --enable nginx-mainline
        yum -y install https://nginx.org/packages/mainline/centos/6/x86_64/RPMS/nginx-$2-1.el6.ngx.x86_64.rpm
    fi
    service nginx restart
    service nginx status
    chkconfig nginx on
}

case $1 in
    init)
        init "$2" "$3"
    ;;
esac
