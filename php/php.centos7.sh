#!/usr/bin/env bash
# PHP script file example
#     ./php.centos7.sh $1 $2
#     ./php.centos7.sh init php73

init(){
    yum -y autoremove php*-* remi-release
    rm -fr /etc/yum.repos.d/remi*
    rm -fr /etc/php*
    rm -fr /etc/opt/remi*
    rm -fr /opt/remi*
    rm -fr /var/opt/remi*
    rm -fr /etc/scl/prefixes/php*
    rm -fr /usr/share/Modules/modulefiles/php*
    rm -fr /var/cache/yum/x86_64/7/remi*
    rm -fr /var/lib/yum/repos/x86_64/7/remi*
    rm -fr /usr/bin/php*
    yum -y install yum-utils
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum-config-manager --enable remi-$1
    yum -y install $1 \
                   $1-php-fpm \
                   $1-php-cli \
                   $1-php-common \
                   $1-runtime \
                   $1-php-mysqlnd \
                   $1-php-pecl-redis4 \
                   $1-php-pecl-memcache \
                   $1-php-pecl-ssh2 \
                   $1-php-bcmath \
                   $1-php-gd \
                   $1-php-ldap \
                   $1-php-mbstring \
                   $1-php-pdo \
                   $1-php-xml \
                   $1-php-json \
                   $1-php-pecl-igbinary                
    ln -s /usr/bin/$1 /usr/bin/php
    php --ini
    php -v
    php -m
}


case $1 in
    init)
        init "$2"
    ;;
esac
