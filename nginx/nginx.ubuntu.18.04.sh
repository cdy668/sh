#!/usr/bin/env bash
# nginx script file example
#     ./nginx.ubuntu.18.04.sh $1 $2 $3
#     ./nginx.ubuntu.18.04.sh init stable 1.16.0
#     ./nginx.ubuntu.18.04.sh init mainline 1.17.3

init(){
    systemctl stop nginx
    systemctl status nginx
    apt -y autoremove --purge nginx
    apt-key del ABF5BD827BD9BF62
    rm -fr /var/lib/apt/lists/nginx*
    apt -y install curl gnupg2 ca-certificates lsb-release curl wget
    if [[ "$1" = "stable" ]]; then
        # To set up the apt repository for stable nginx packages, run the following command:
        echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
    elif [[ "$1" = "mainline" ]]; then
        # If you would like to use mainline nginx packages, run the following command instead:
        echo "deb http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list
    fi
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -
    apt-key fingerprint ABF5BD827BD9BF62
    apt update
    if [[ "$1" = "stable" ]]; then
        wget https://nginx.org/packages/ubuntu/pool/nginx/n/nginx/nginx_"$2"-1~`lsb_release -cs`_amd64.deb
        dpkg -i nginx_"$2"-1~`lsb_release -cs`_amd64.deb
        rm -f nginx_"$2"-1~`lsb_release -cs`_amd64.deb
    elif [[ "$1" = "mainline" ]]; then
        wget https://nginx.org/packages/mainline/ubuntu/pool/nginx/n/nginx/nginx_"$2"-1~`lsb_release -cs`_amd64.deb
        dpkg -i nginx_"$2"-1~`lsb_release -cs`_amd64.deb
        rm -f nginx_"$2"-1~`lsb_release -cs`_amd64.deb
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
