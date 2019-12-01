#!/usr/bin/env bash
# MySQL script file example
#     ./mysql80.multi.centos6.en.sh $1 $2 $3
#     ./mysql80.multi.centos6.en.sh init 8.0.16 3306
#     ./mysql80.multi.centos6.en.sh init 8.0.16 3308
#     ./mysql80.multi.centos6.en.sh init 8.0.16 3310
#     ./mysql80.multi.centos6.en.sh init 8.0.16 3312
# MySQL 8.0 Reference Manual
#     https://dev.mysql.com/doc/refman/8.0/en/

init(){
    MYSQL_BIND_PORT="$2"
    MYSQLX_BIND_PORT="$(($MYSQL_BIND_PORT+1))"
    MYSQL_HOME_DIR="/home/mysql"
    MYSQL_BASE_DIR="$MYSQL_HOME_DIR/mysql$MYSQL_BIND_PORT"
    MYSQL_CONFIG_FILE="$MYSQL_BASE_DIR/usr/local/mysql/my.cnf"
    MYSQL_ROOT_PASSWORD="$(openssl rand -base64 20)"
    service mysqld$MYSQL_BIND_PORT stop
    service mysqld$MYSQL_BIND_PORT status
    rm -f /etc/init.d/mysqld$MYSQL_BIND_PORT*
    rm -fr /home/mysql/mysql$MYSQL_BIND_PORT*
    rm -fr /etc/my.cnf*
    yum -y install libaio wget bzip2 numactl numactl-libs
    useradd -r -s /bin/false -m -d $MYSQL_HOME_DIR -c 'MySQL Server' mysql
    mkdir -p $MYSQL_BASE_DIR/usr/local
    mkdir -p $MYSQL_BASE_DIR/var/log/mysql
    chown -R  mysql:mysql $MYSQL_BASE_DIR/var/log/mysql
    chmod -R 700 $MYSQL_BASE_DIR/var/log/mysql
    cd $MYSQL_BASE_DIR
    wget "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-$1-linux-glibc2.12-x86_64.tar.xz"
    tar -xf mysql-$1-linux-glibc2.12-x86_64.tar.xz -C $MYSQL_BASE_DIR/usr/local
    rm -f mysql-$1-linux-glibc2.12-x86_64.tar.xz
    cd $MYSQL_BASE_DIR/usr/local
    mv mysql-$1-linux-glibc2.12-x86_64 mysql
    chown -R mysql:mysql mysql
    chmod -R 700 mysql
    cd mysql/
    mkdir -p data
    chown mysql:mysql data
    chmod 750 data
    echo "[client]"                                                                                                              > $MYSQL_CONFIG_FILE
    echo "default-character-set                                  = utf8mb4"                                                     >> $MYSQL_CONFIG_FILE
    echo "socket                                                 = $MYSQL_HOME_DIR/mysql$MYSQL_BIND_PORT.sock"                  >> $MYSQL_CONFIG_FILE
    echo "port                                                   = $MYSQL_BIND_PORT"                                            >> $MYSQL_CONFIG_FILE
    echo "mysqlx_socket                                          = $MYSQL_HOME_DIR/mysqlx$MYSQLX_BIND_PORT.sock"                >> $MYSQL_CONFIG_FILE
    echo "mysqlx_port                                            = $MYSQLX_BIND_PORT"                                           >> $MYSQL_CONFIG_FILE
    echo "[mysql]"                                                                                                              >> $MYSQL_CONFIG_FILE
    echo "default-character-set                                  = utf8mb4"                                                     >> $MYSQL_CONFIG_FILE
    echo "socket                                                 = $MYSQL_HOME_DIR/mysql$MYSQL_BIND_PORT.sock"                  >> $MYSQL_CONFIG_FILE
    echo "port                                                   = $MYSQL_BIND_PORT"                                            >> $MYSQL_CONFIG_FILE
    echo "mysqlx_socket                                          = $MYSQL_HOME_DIR/mysqlx$MYSQLX_BIND_PORT.sock"                >> $MYSQL_CONFIG_FILE
    echo "mysqlx_port                                            = $MYSQLX_BIND_PORT"                                           >> $MYSQL_CONFIG_FILE
    echo "[mysqld]"                                                                                                             >> $MYSQL_CONFIG_FILE
    echo "back_log                                               = 5120"                                                        >> $MYSQL_CONFIG_FILE
    echo "basedir                                                = $MYSQL_BASE_DIR/usr/local/mysql"                             >> $MYSQL_CONFIG_FILE
    echo "binlog_cache_size                                      = 32M"                                                         >> $MYSQL_CONFIG_FILE
    echo "binlog_checksum                                        = CRC32"                                                       >> $MYSQL_CONFIG_FILE
    echo "# binlog-do-db                                         = "                                                            >> $MYSQL_CONFIG_FILE
    echo "binlog_format                                          = ROW"                                                         >> $MYSQL_CONFIG_FILE
    echo "# binlog-ignore-db                                     = mysql,sys,information_schema,performance_schema"             >> $MYSQL_CONFIG_FILE
    echo "character-set-server                                   = utf8mb4"                                                     >> $MYSQL_CONFIG_FILE
    echo "collation-server                                       = utf8mb4_unicode_ci"                                          >> $MYSQL_CONFIG_FILE
    echo "datadir                                                = $MYSQL_BASE_DIR/usr/local/mysql/data"                        >> $MYSQL_CONFIG_FILE
    echo "default_storage_engine                                 = InnoDB"                                                      >> $MYSQL_CONFIG_FILE
    echo "binlog_expire_logs_seconds                             = 2592000"                                                     >> $MYSQL_CONFIG_FILE
    echo "ft_min_word_len                                        = 4"                                                           >> $MYSQL_CONFIG_FILE
    echo "init-connect                                           = 'SET NAMES utf8mb4'"                                         >> $MYSQL_CONFIG_FILE
    echo "innodb_buffer_pool_chunk_size                          = 500M"                                                        >> $MYSQL_CONFIG_FILE
    echo "innodb_buffer_pool_instances                           = 8"                                                           >> $MYSQL_CONFIG_FILE
    echo "innodb_buffer_pool_size                                = 4G"                                                          >> $MYSQL_CONFIG_FILE
    echo "# innodb_data_file_path                                = ibdata1:256M;ibdata2:256M:autoextend"                        >> $MYSQL_CONFIG_FILE
    echo "innodb_data_home_dir                                   = $MYSQL_BASE_DIR/usr/local/mysql/data"                        >> $MYSQL_CONFIG_FILE
    echo "# innodb_fast_shutdown                                 "                                                              >> $MYSQL_CONFIG_FILE
    echo "innodb_file_per_table                                  = ON"                                                          >> $MYSQL_CONFIG_FILE
    echo "innodb_flush_log_at_trx_commit                         = 2"                                                           >> $MYSQL_CONFIG_FILE
    echo "innodb_flush_method                                    = O_DIRECT"                                                    >> $MYSQL_CONFIG_FILE
    echo "# innodb_flush_neighbors                               = 0"                                                           >> $MYSQL_CONFIG_FILE
    echo "# innodb_force_recovery                                = 1"                                                           >> $MYSQL_CONFIG_FILE
    echo "innodb_io_capacity                                     = 6000"                                                        >> $MYSQL_CONFIG_FILE
    echo "innodb_io_capacity_max                                 = 8000"                                                        >> $MYSQL_CONFIG_FILE
    echo "innodb_lock_wait_timeout                               = 30"                                                          >> $MYSQL_CONFIG_FILE
    echo "innodb_log_buffer_size                                 = 32M"                                                         >> $MYSQL_CONFIG_FILE
    echo "# innodb_log_files_in_group                            = 2"                                                           >> $MYSQL_CONFIG_FILE
    echo "# innodb_log_file_size                                 = 1G"                                                          >> $MYSQL_CONFIG_FILE
    echo "innodb_log_group_home_dir                              = $MYSQL_BASE_DIR/var/log/mysql"                               >> $MYSQL_CONFIG_FILE
    echo "innodb_max_dirty_pages_pct                             = 75"                                                          >> $MYSQL_CONFIG_FILE
    echo "# innodb_page_size                                     = 4K"                                                          >> $MYSQL_CONFIG_FILE
    echo "innodb_read_io_threads                                 = 8"                                                           >> $MYSQL_CONFIG_FILE
    echo "# innodb_support_xa                                    = 1"                                                           >> $MYSQL_CONFIG_FILE
    echo "innodb_thread_concurrency                              = 48"                                                          >> $MYSQL_CONFIG_FILE
    echo "innodb_write_io_threads                                = 16"                                                          >> $MYSQL_CONFIG_FILE
    echo "join_buffer_size                                       = 8M"                                                          >> $MYSQL_CONFIG_FILE
    echo "local_infile                                           = OFF"                                                         >> $MYSQL_CONFIG_FILE
    echo "log_bin                                                = $MYSQL_BASE_DIR/var/log/mysql/mysql_bin"                     >> $MYSQL_CONFIG_FILE
    echo "log_error                                              = $MYSQL_BASE_DIR/var/log/mysql/mysql_error.log"               >> $MYSQL_CONFIG_FILE
    echo "# log-slave-updates                                    = 1"                                                           >> $MYSQL_CONFIG_FILE
    echo "long_query_time                                        = 1"                                                           >> $MYSQL_CONFIG_FILE
    echo "# master_info_repository                               = TABLE"                                                       >> $MYSQL_CONFIG_FILE
    echo "max_allowed_packet                                     = 512M"                                                        >> $MYSQL_CONFIG_FILE
    echo "max_binlog_size                                        = 1G"                                                          >> $MYSQL_CONFIG_FILE
    echo "max_connect_errors                                     = 5120"                                                        >> $MYSQL_CONFIG_FILE
    echo "max_connections                                        = 8000"                                                        >> $MYSQL_CONFIG_FILE
    echo "max_heap_table_size                                    = 128M"                                                        >> $MYSQL_CONFIG_FILE
    echo "open_files_limit                                       = 65535"                                                       >> $MYSQL_CONFIG_FILE
    echo "pid_file                                               = $MYSQL_BASE_DIR/usr/local/mysql/data/$(hostname).pid"        >> $MYSQL_CONFIG_FILE
    echo "socket                                                 = $MYSQL_HOME_DIR/mysql$MYSQL_BIND_PORT.sock"                  >> $MYSQL_CONFIG_FILE
    echo "port                                                   = $MYSQL_BIND_PORT"                                            >> $MYSQL_CONFIG_FILE
    echo "mysqlx_socket                                          = $MYSQL_HOME_DIR/mysqlx$MYSQLX_BIND_PORT.sock"                >> $MYSQL_CONFIG_FILE
    echo "mysqlx_port                                            = $MYSQLX_BIND_PORT"                                           >> $MYSQL_CONFIG_FILE
    echo "# read_only                                            = ON"                                                          >> $MYSQL_CONFIG_FILE
    echo "# read_rnd_buffer_size                                 = 2M"                                                          >> $MYSQL_CONFIG_FILE
    echo "# relay_log_index                                      = $MYSQL_BASE_DIR/var/log/mysql/relay_log.index"               >> $MYSQL_CONFIG_FILE
    echo "# relay_log_recovery                                   = 1"                                                           >> $MYSQL_CONFIG_FILE
    echo "# relay_log                                            = $MYSQL_BASE_DIR/var/log/mysql/relay_log"                     >> $MYSQL_CONFIG_FILE
    echo "# replicate-do-db                                      = "                                                            >> $MYSQL_CONFIG_FILE
    echo "# replicate-do-table                                   = "                                                            >> $MYSQL_CONFIG_FILE
    echo "# replicate-ignore-db                                  = "                                                            >> $MYSQL_CONFIG_FILE
    echo "# replicate-ignore-table                               = "                                                            >> $MYSQL_CONFIG_FILE
    echo "# replicate-wild-do-table                              = "                                                            >> $MYSQL_CONFIG_FILE
    echo "# replicate-wild-ignore-table                          = "                                                            >> $MYSQL_CONFIG_FILE
    echo "# report_host                                          = slave_host"                                                  >> $MYSQL_CONFIG_FILE
    echo "# relay_log_info_repository                            = TABLE"                                                       >> $MYSQL_CONFIG_FILE
    echo "# slave-skip-errors                                    = 1062,1032,1236"                                              >> $MYSQL_CONFIG_FILE
    echo "server_id                                              = $(date "+%s")"                                               >> $MYSQL_CONFIG_FILE
    echo "skip_external_locking"                                                                                                >> $MYSQL_CONFIG_FILE
    echo "# skip-grant-tables"                                                                                                  >> $MYSQL_CONFIG_FILE
    echo "skip-host-cache"                                                                                                      >> $MYSQL_CONFIG_FILE
    echo "skip_name_resolve                                      = ON"                                                          >> $MYSQL_CONFIG_FILE
    echo "skip_show_database                                     = ON"                                                          >> $MYSQL_CONFIG_FILE
    echo "# skip-slave-start"                                                                                                   >> $MYSQL_CONFIG_FILE
    echo "slow_query_log                                         = 1"                                                           >> $MYSQL_CONFIG_FILE
    echo "slow_query_log_file                                    = $MYSQL_BASE_DIR/var/log/mysql/mysql_slow.log"                >> $MYSQL_CONFIG_FILE
    echo "sort_buffer_size                                       = 8M"                                                          >> $MYSQL_CONFIG_FILE
    echo "# sql_mode                                               = \"ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION\"" >> $MYSQL_CONFIG_FILE
    echo "ssl_ca                                                 = $MYSQL_BASE_DIR/usr/local/mysql/data/ca.pem"                 >> $MYSQL_CONFIG_FILE
    echo "ssl_cert                                               = $MYSQL_BASE_DIR/usr/local/mysql/data/server-cert.pem"        >> $MYSQL_CONFIG_FILE
    echo "ssl_key                                                = $MYSQL_BASE_DIR/usr/local/mysql/data/server-key.pem"         >> $MYSQL_CONFIG_FILE
    echo "ssl                                                    = ON"                                                          >> $MYSQL_CONFIG_FILE
    echo "symbolic-links                                         = 0"                                                           >> $MYSQL_CONFIG_FILE
    echo "# sync_binlog                                          = 1"                                                           >> $MYSQL_CONFIG_FILE
    echo "table_open_cache                                       = 8192"                                                        >> $MYSQL_CONFIG_FILE
    echo "thread_cache_size                                      = 512"                                                         >> $MYSQL_CONFIG_FILE
    echo "thread_stack                                           = 256K"                                                        >> $MYSQL_CONFIG_FILE
    echo "tmpdir                                                 = /tmp"                                                        >> $MYSQL_CONFIG_FILE
    echo "tmp_table_size                                         = 128M"                                                        >> $MYSQL_CONFIG_FILE
    echo "transaction_isolation                                  = REPEATABLE-READ"                                             >> $MYSQL_CONFIG_FILE
    echo "user                                                   = mysql"                                                       >> $MYSQL_CONFIG_FILE
    touch $MYSQL_BASE_DIR/var/log/mysql/mysql_error.log
    touch $MYSQL_BASE_DIR/var/log/mysql/mysql_slow.log
    chown mysql:mysql $MYSQL_BASE_DIR/var/log/mysql/mysql_error.log
    chown mysql:mysql $MYSQL_BASE_DIR/var/log/mysql/mysql_slow.log
    chown mysql:mysql $MYSQL_CONFIG_FILE
    chmod 600 $MYSQL_BASE_DIR/var/log/mysql/mysql_error.log
    chmod 600 $MYSQL_BASE_DIR/var/log/mysql/mysql_slow.log
    chmod 600 $MYSQL_CONFIG_FILE
    cp $MYSQL_BASE_DIR/usr/local/mysql/bin/mysql* /usr/bin
    chmod 755 /usr/bin/mysql*
    # cp /home/mysql/mysql$MYSQL_BIND_PORT/usr/local/mysql/lib/libssl.so* /usr/lib64/
    # cp /home/mysql/mysql$MYSQL_BIND_PORT/usr/local/mysql/lib/libcrypto.so* /usr/lib64/
    ulimit -n 655350
    # /etc/security/limits.conf
    # * soft nproc 655350
    # * hard nproc 655350
    # * soft nofile 655350
    # * hard nofile 655350
    # /etc/sysctl.conf
    # fs.file-max=655350
    sudo -u mysql ./bin/mysqld --defaults-file=$MYSQL_CONFIG_FILE --initialize-insecure --user=mysql --basedir=$MYSQL_BASE_DIR/usr/local/mysql --datadir=$MYSQL_BASE_DIR/usr/local/mysql/data/
    sudo -u mysql ./bin/mysql_ssl_rsa_setup --uid=$(id -u mysql) --basedir=$MYSQL_BASE_DIR/usr/local/mysql --datadir=$MYSQL_BASE_DIR/usr/local/mysql/data/
    cp support-files/mysql.server /etc/init.d/mysqld$MYSQL_BIND_PORT
    chmod 755 /etc/init.d/mysqld$MYSQL_BIND_PORT
    sed -i "s/^basedir=/basedir=\/home\/mysql\/mysql$MYSQL_BIND_PORT\/usr\/local\/mysql/"                                                   /etc/init.d/mysqld$MYSQL_BIND_PORT
    sed -i "s/^datadir=/datadir=\/home\/mysql\/mysql$MYSQL_BIND_PORT\/usr\/local\/mysql\/data/"                                             /etc/init.d/mysqld$MYSQL_BIND_PORT
    sed -i "s/^lockdir='\/var\/lock\/subsys'/lockdir=\'\/home\/mysql\/mysql$MYSQL_BIND_PORT'/"                                              /etc/init.d/mysqld$MYSQL_BIND_PORT
    sed -i "s/^mysqld_pid_file_path=/mysqld_pid_file_path=\/home\/mysql\/mysql$MYSQL_BIND_PORT\/usr\/local\/mysql\/data\/$(hostname).pid/"  /etc/init.d/mysqld$MYSQL_BIND_PORT
    sed -i "s/  conf=\/etc\/my.cnf/  conf=\/home\/mysql\/mysql$MYSQL_BIND_PORT\/usr\/local\/mysql\/my.cnf/"                                 /etc/init.d/mysqld$MYSQL_BIND_PORT
    chkconfig mysqld$MYSQL_BIND_PORT on
    service mysqld$MYSQL_BIND_PORT start
    service mysqld$MYSQL_BIND_PORT status
    mysqladmin -S /home/mysql/mysql$MYSQL_BIND_PORT.sock -uroot password "$MYSQL_ROOT_PASSWORD" 2>/dev/null
    echo "Please remember your MySQL database root password $MYSQL_ROOT_PASSWORD"
    mysql -S /home/mysql/mysql$MYSQL_BIND_PORT.sock -uroot -p"$MYSQL_ROOT_PASSWORD" -e "INSTALL PLUGIN validate_password SONAME 'validate_password.so';" 2>/dev/null
    echo "validate_password_policy                               = MEDIUM"                                                      >> $MYSQL_CONFIG_FILE
}

case $1 in
    init)
        init "$2" "$3"
    ;;
esac
