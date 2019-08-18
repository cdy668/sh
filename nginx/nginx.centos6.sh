#!/usr/bin/env bash
# nginx script file example
#     ./nginx.centos6.sh $1 $2
#     ./nginx.centos6.sh init 1.16.0

init(){
    service nginx stop
    service nginx status
    yum -y remove nginx
    rm -fr /etc/nginx
    rm -fr /var/cache/nginx
    rm -fr /var/cache/yum/x86_64/7/nginx
    rm -fr /var/lib/yum/repos/x86_64/7/nginx
    rm -fr /var/log/nginx
    rm -f /etc/yum.repos.d/nginx.repo
    rpm -e gpg-pubkey-7bd9bf62-5762b5f8
    echo "[nginx]" > /etc/yum.repos.d/nginx.repo
    echo "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
    echo "baseurl=https://nginx.org/packages/centos/6/x86_64/" >> /etc/yum.repos.d/nginx.repo
    echo "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
    echo "enabled=1" >> /etc/yum.repos.d/nginx.repo
    chmod 644 /etc/yum.repos.d/nginx.repo
    # To list all imported signing archive keys run:
    #     rpm --import https://nginx.org/packages/keys/nginx_signing.key
    # You the above list to remove any unwanted archive signing keys. This can be done by using rpm command:
    #     rpm -e gpg-pubkey-7bd9bf62-5762b5f8
    rpm --import https://nginx.org/packages/keys/nginx_signing.key
    yum -y install https://nginx.org/packages/centos/6/x86_64/RPMS/nginx-$1-1.el6.ngx.x86_64.rpm
    service nginx restart
    service nginx status
    chkconfig nginx on
}

case $1 in
    init)
        init "$2"
    ;;
esac
