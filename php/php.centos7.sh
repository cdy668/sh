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
    yum -y install $1-php \
                   $1-php-pecl-mcrypt \
                   $1-php-cli \
                   $1-php-gd \
                   $1-php-curl \
                   $1-php-mysqlnd \
                   $1-php-ldap \
                   $1-php-zip \
                   $1-php-redis \
                   $1-php-pecl-mongodb \
                   $1-php-pecl-swoole4 \
                   $1-php-pecl-ssh2 \
                   $1-php-fileinfo \
                   $1-php-xml \
                   $1-php-intl \
                   $1-php-mbstring \
                   $1-php-opcache \
                   $1-php-process \
                   $1-php-pear \
                   $1-php-json \
                   $1-php-devel \
                   $1-php-common \
                   $1-php-bcmath \
                   $1-php-pdo \
                   $1-php-openssl \
                   $1-php-embedded \
                   $1-php-fpm \
                   $1-php-imap \
                   $1-php-odbc \
                   $1-php-xmlrpc \
                   $1-php-snmp \
                   $1-php-soap          
    rm -f /usr/bin/php /usr/bin/php-cgi /usr/bin/phpize
    ln -s /usr/bin/$1 /usr/bin/php
    ln -s /usr/bin/$1-cgi /usr/bin/php-cgi
    ln -s /usr/bin/$1-pear /usr/bin/php-pear
    ln -s /usr/bin/$1-phar /usr/bin/php-phar
    ln -s /opt/remi/$1/root/usr/bin/phpize /usr/bin/phpize
    php --ini
    php -v
    php -m
}


case $1 in
    init)
        init "$2"
    ;;
esac
