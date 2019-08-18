#!/usr/bin/env bash
# nginx script file example
#     ./nginx.centos7.sh $1 $2
#     ./nginx.centos7.sh init 1.16.0

init(){
    systemctl stop nginx
    systemctl status nginx
    yum -y autoremove nginx
    rm -fr /etc/nginx
    rm -fr /var/cache/nginx
    rm -fr /var/cache/yum/x86_64/7/nginx
    rm -fr /var/lib/yum/repos/x86_64/7/nginx
    rm -fr /var/log/nginx
    rm -f /etc/yum.repos.d/nginx.repo
    rpm -e gpg-pubkey-7bd9bf62-5762b5f8
    echo "[nginx]" > /etc/yum.repos.d/nginx.repo
    echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
    echo "baseurl=https://nginx.org/packages/centos/7/x86_64/" >> /etc/yum.repos.d/nginx.repo
    echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
    echo "enabled=1" >> /etc/yum.repos.d/nginx.repo
    chmod 644 /etc/yum.repos.d/nginx.repo
    # To list all imported signing archive keys run:
    #     rpm --import https://nginx.org/packages/keys/nginx_signing.key
    # You the above list to remove any unwanted archive signing keys. This can be done by using rpm command:
    #     rpm -e gpg-pubkey-7bd9bf62-5762b5f8
    rpm --import https://nginx.org/packages/keys/nginx_signing.key
    if [[ "$1" =~ ^1.10.0$|^1.10.1$|^1.10.2$|^1.10.3$|^1.12.0$|^1.12.1$|^1.16.0$|^1.16.1$|^1.8.0$|^1.8.1$ ]]; then
        yum -y install https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-$1-1.el7.ngx.x86_64.rpm
    elif [[ "$1" =~ ^1.12.2$|^1.14.0$|^1.14.1$|^1.14.2$ ]]; then
        yum -y install https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-$1-1.el7_4.ngx.x86_64.rpm
    else
        echo "Version list"
        echo "    1.16.1"
        echo "    1.16.0"
        echo "    1.14.2"
        echo "    1.14.1"
        echo "    1.14.0"
        echo "    1.12.2"
        echo "    1.12.1"
        echo "    1.12.0"
        echo "    1.10.3"
        echo "    1.10.2"
        echo "    1.10.1"
        echo "    1.10.0"
        echo "    1.8.1"
        echo "    1.8.0"
    fi
    systemctl restart nginx
    systemctl status nginx
    systemctl enable nginx
}

case $1 in
    init)
        init "$2"
    ;;
esac
