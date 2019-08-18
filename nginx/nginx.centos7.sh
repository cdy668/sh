#!/usr/bin/env bash
# nginx script file example
#     ./nginx.centos7.sh $1 $2 $3
#     ./nginx.centos7.sh init stable 1.16.0
#     ./nginx.centos7.sh init mainline 1.17.3

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
    # rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n'
    # rpm -e gpg-pubkey-7bd9bf62-5762b5f8
    yum -y install yum-utils
    echo "[nginx-stable]"                                              > /etc/yum.repos.d/nginx.repo
    echo "name=nginx stable repo"                                      >> /etc/yum.repos.d/nginx.repo
    echo "baseurl=http://nginx.org/packages/centos/7/x86_64/"          >> /etc/yum.repos.d/nginx.repo
    echo "gpgcheck=1"                                                  >> /etc/yum.repos.d/nginx.repo
    echo "enabled=0"                                                   >> /etc/yum.repos.d/nginx.repo
    echo "gpgkey=https://nginx.org/keys/nginx_signing.key"             >> /etc/yum.repos.d/nginx.repo
    echo "[nginx-mainline]"                                            >> /etc/yum.repos.d/nginx.repo
    echo "name=nginx mainline repo"                                    >> /etc/yum.repos.d/nginx.repo
    echo "baseurl=http://nginx.org/packages/mainline/centos/7/x86_64/" >> /etc/yum.repos.d/nginx.repo
    echo "gpgcheck=1"                                                  >> /etc/yum.repos.d/nginx.repo
    echo "enabled=0"                                                   >> /etc/yum.repos.d/nginx.repo
    echo "gpgkey=https://nginx.org/keys/nginx_signing.key"             >> /etc/yum.repos.d/nginx.repo
    chmod 644 /etc/yum.repos.d/nginx.repo
    if [[ "$1" = "stable" ]] ; then
        yum-config-manager --enable nginx-stable
        special_name="$(curl -sSL http://nginx.org/packages/centos/7/x86_64/RPMS/ | awk -F "\"" '{print $2}' | grep "^nginx-$2-1.*_4.ngx.x86_64.rpm" | awk -F "-" '{print $2}')"
        if [[ -n "$(echo "$special_name" | grep -o "$2")" ]];then
            yum -y install https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-$2-1.el7_4.ngx.x86_64.rpm
        else
            yum -y install https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-$2-1.el7.ngx.x86_64.rpm
        fi
    elif [[ "$1" = "mainline" ]]; then
        yum-config-manager --enable nginx-mainline
        special_name="$(curl -sSL https://nginx.org/packages/mainline/centos/7/x86_64/RPMS/ | awk -F "\"" '{print $2}' | grep "^nginx-$2-1.*_4.ngx.x86_64.rpm" | awk -F "-" '{print $2}')"
        if [[ -n "$(echo "$special_name" | grep -o "$2")" ]];then
            yum -y install https://nginx.org/packages/mainline/centos/7/x86_64/RPMS/nginx-$2-1.el7_4.ngx.x86_64.rpm
        else
            yum -y install https://nginx.org/packages/mainline/centos/7/x86_64/RPMS/nginx-$2-1.el7.ngx.x86_64.rpm
        fi
    fi
    systemctl restart nginx
    systemctl status nginx
    systemctl enable nginx
}

case $1 in
    init)
        init "$2" "$3"
    ;;
esac
