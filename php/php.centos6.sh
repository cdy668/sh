#!/usr/bin/env bash
# PHP script file example
#     ./php.centos6.sh $1 $2
#     ./php.centos6.sh init php73

init(){
    yum -y remove php*-* remi-release
    rm -fr /etc/php*
    rm -fr /opt/remi*
    rm -fr /usr/bin/php*
    rm -fr /etc/yum.repos.d/remi*
    yum -y install yum-utils
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-6.rpm
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