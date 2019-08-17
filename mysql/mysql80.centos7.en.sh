#!/usr/bin/env bash
# MySQL script file example
#     ./mysql80.centos7.en.sh $1 $2
#     ./mysql80.centos7.en.sh init 8.0.16
# MySQL 8.0 Reference Manual
#     https://dev.mysql.com/doc/refman/8.0/en/

init(){
    systemctl daemon-reload
    systemctl stop mysqld
    systemctl status mysqld
    userdel -r mysql
    rm -fr /etc/my.cnf*
    rm -f /etc/init.d/mysql*
    rm -f /usr/bin/mysql*
    rm -f /usr/lib64/libssl.so.1.0.0
    rm -f /usr/lib64/libcrypto.so.1.0.0
    base_dir="/home/mysql"
    config_file="$base_dir/usr/local/mysql/my.cnf"
    yum -y install libaio wget bzip2 numactl numactl-libs
    useradd -r -s /bin/false -m -d $base_dir -c 'MySQL Server' mysql
    cd $base_dir
    wget "https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-$1-linux-glibc2.12-x86_64.tar.xz"
    mkdir -p $base_dir/usr/local
    mkdir -p $base_dir/var/log/mysql
    mkdir -p $base_dir/var/run/mysql
    chown -R  mysql:mysql $base_dir/var/log/mysql
    chown -R  mysql:mysql $base_dir/var/run/mysql
    chmod -R 700 $base_dir/var/log/mysql
    chmod -R 700 $base_dir/var/run/mysql
    tar -xf mysql-$1-linux-glibc2.12-x86_64.tar.xz -C $base_dir/usr/local
    rm -f mysql-$1-linux-glibc2.12-x86_64.tar.xz
    cd $base_dir/usr/local
    mv mysql-$1-linux-glibc2.12-x86_64 mysql
    chown -R mysql:mysql mysql
    chmod -R 700 mysql
    cd mysql/
    mkdir -p data
    chown mysql:mysql data
    chmod 750 data
    echo "[client]"                                                                                       > $config_file
    echo "default-character-set                                  = utf8mb4"                              >> $config_file
    echo "socket                                                 = /tmp/mysql.sock"                      >> $config_file
    echo "port                                                   = 3306"                                 >> $config_file
    echo "[mysql]"                                                                                       >> $config_file
    echo "default-character-set                                  = utf8mb4"                              >> $config_file
    echo "socket                                                 = /tmp/mysql.sock"                      >> $config_file
    echo "port                                                   = 3306"                                 >> $config_file
    echo "[mysqld]"                                                                                      >> $config_file
    echo "back_log                                               = 5120"                                 >> $config_file
    echo "basedir                                                = $base_dir/usr/local/mysql"            >> $config_file
    echo "binlog_cache_size                                      = 32M"                                  >> $config_file
    echo "binlog_checksum                                        = CRC32"                                >> $config_file
    echo "# binlog-do-db                                         = "                                     >> $config_file
    echo "binlog_format                                          = ROW"                                  >> $config_file
    echo "binlog-ignore-db                                       = mysql,sys,information_schema,performance_schema" >> $config_file
    echo "character-set-server                                   = utf8mb4"                              >> $config_file
    echo "collation-server                                       = utf8mb4_unicode_ci"                   >> $config_file
    echo "datadir                                                = $base_dir/usr/local/mysql/data"       >> $config_file
    echo "default_storage_engine                                 = InnoDB"                               >> $config_file
    echo "binlog_expire_logs_seconds                             = 2592000"                              >> $config_file
    echo "ft_min_word_len                                        = 4"                                    >> $config_file
    echo "init-connect                                           = 'SET NAMES utf8mb4'"                  >> $config_file
    echo "innodb_buffer_pool_chunk_size                          = 500M"                                 >> $config_file
    echo "innodb_buffer_pool_instances                           = 8"                                    >> $config_file
    echo "innodb_buffer_pool_size                                = 4G"                                   >> $config_file
    echo "# innodb_data_file_path                                = ibdata1:256M;ibdata2:256M:autoextend" >> $config_file
    echo "innodb_data_home_dir                                   = $base_dir/usr/local/mysql/data"       >> $config_file
    echo "# innodb_fast_shutdown                                 "                                       >> $config_file
    echo "innodb_file_per_table                                  = ON"                                   >> $config_file
    echo "innodb_flush_log_at_trx_commit                         = 2"                                    >> $config_file
    echo "innodb_flush_method                                    = O_DIRECT"                             >> $config_file
    echo "# innodb_flush_neighbors                               = 0"                                    >> $config_file
    echo "# innodb_force_recovery                                = 1"                                    >> $config_file
    echo "innodb_io_capacity                                     = 6000"                                 >> $config_file
    echo "innodb_io_capacity_max                                 = 8000"                                 >> $config_file
    echo "innodb_lock_wait_timeout                               = 30"                                   >> $config_file
    echo "innodb_log_buffer_size                                 = 32M"                                  >> $config_file
    echo "# innodb_log_files_in_group                            = 2"                                    >> $config_file
    echo "# innodb_log_file_size                                 = 1G"                                   >> $config_file
    echo "innodb_log_group_home_dir                              = $base_dir/var/log/mysql"              >> $config_file
    echo "innodb_max_dirty_pages_pct                             = 75"                                   >> $config_file
    echo "# innodb_page_size                                     = 4K"                                   >> $config_file
    echo "innodb_read_io_threads                                 = 8"                                    >> $config_file
    echo "# innodb_support_xa                                    = 1"                                    >> $config_file
    echo "innodb_thread_concurrency                              = 48"                                   >> $config_file
    echo "innodb_write_io_threads                                = 16"                                   >> $config_file
    echo "join_buffer_size                                       = 8M"                                   >> $config_file
    echo "local_infile                                           = OFF"                                  >> $config_file
    echo "log_bin                                                = $base_dir/var/log/mysql/mysql_bin"    >> $config_file
    echo "log_error                                              = $base_dir/var/log/mysql/mysql_error.log" >> $config_file
    echo "long_query_time                                        = 1"                                    >> $config_file
    echo "# master_info_repository                               = TABLE"                                >> $config_file
    echo "max_allowed_packet                                     = 512M"                                 >> $config_file
    echo "max_binlog_size                                        = 1G"                                   >> $config_file
    echo "max_connect_errors                                     = 5120"                                 >> $config_file
    echo "max_connections                                        = 8000"                                 >> $config_file
    echo "max_heap_table_size                                    = 128M"                                 >> $config_file
    echo "open_files_limit                                       = 65535"                                >> $config_file
    echo "pid_file                                               = $base_dir/usr/local/mysql/data/$(hostname).pid" >> $config_file
    echo "port                                                   = 3306"                                 >> $config_file
    echo "# read_only                                            = ON"                                   >> $config_file
    echo "# read_rnd_buffer_size                                 = 2M"                                   >> $config_file
    echo "# relay_log_index                                      = relay_log.index"                      >> $config_file
    echo "# relay_log_recovery                                   = 1"                                    >> $config_file
    echo "# relay_log                                            = relay_log"                            >> $config_file
    echo "# replicate-do-db                                      = "                                     >> $config_file
    echo "# replicate-do-table                                   = "                                     >> $config_file
    echo "# replicate-ignore-db                                  = "                                     >> $config_file
    echo "# replicate-ignore-table                               = "                                     >> $config_file
    echo "# replicate-wild-do-table                              = "                                     >> $config_file
    echo "# replicate-wild-ignore-table                          = "                                     >> $config_file
    echo "# report_host                                          = slave_host"                           >> $config_file
    echo "# relay_log_info_repository                            = TABLE"                                >> $config_file
    echo "server_id                                              = $(date "+%s")"                        >> $config_file
    echo "skip_external_locking"                                                                         >> $config_file
    echo "# skip-grant-tables"                                                                           >> $config_file
    echo "skip-host-cache"                                                                               >> $config_file
    echo "skip_name_resolve                                      = ON"                                   >> $config_file
    echo "skip_show_database                                     = ON"                                   >> $config_file
    echo "# skip-slave-start"                                                                            >> $config_file
    echo "slow_query_log                                         = 1"                                    >> $config_file
    echo "slow_query_log_file                                    = $base_dir/var/log/mysql/mysql_slow.log" >> $config_file
    echo "socket                                                 = /tmp/mysql.sock"                      >> $config_file
    echo "sort_buffer_size                                       = 8M"                                   >> $config_file
    echo "# sql_mode                                               = \"ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION\"" >> $config_file
    echo "ssl_ca                                                 = $base_dir/usr/local/mysql/data/ca.pem" >> $config_file
    echo "ssl_cert                                               = $base_dir/usr/local/mysql/data/server-cert.pem" >> $config_file
    echo "ssl_key                                                = $base_dir/usr/local/mysql/data/server-key.pem" >> $config_file
    echo "ssl                                                    = ON"                                   >> $config_file
    echo "symbolic-links                                         = 0"                                    >> $config_file
    echo "# sync_binlog                                          = 1"                                    >> $config_file
    echo "table_open_cache                                       = 8192"                                 >> $config_file
    echo "thread_cache_size                                      = 512"                                  >> $config_file
    echo "thread_stack                                           = 256K"                                 >> $config_file
    echo "tmpdir                                                 = /tmp"                                 >> $config_file
    echo "tmp_table_size                                         = 128M"                                 >> $config_file
    echo "transaction_isolation                                  = REPEATABLE-READ"                      >> $config_file
    echo "user                                                   = mysql"                                >> $config_file
    touch $base_dir/var/log/mysql/mysql_error.log
    touch $base_dir/var/log/mysql/mysql_slow.log
    chown mysql:mysql $base_dir/var/log/mysql/mysql_error.log
    chown mysql:mysql $base_dir/var/log/mysql/mysql_slow.log
    chown mysql:mysql $config_file
    chmod 600 $base_dir/var/log/mysql/mysql_error.log
    chmod 600 $base_dir/var/log/mysql/mysql_slow.log
    chmod 600 $config_file
    cp $base_dir/usr/local/mysql/bin/mysql* /usr/bin
    chmod 755 /usr/bin/mysql*
    ln -s $config_file /etc/my.cnf
    cp /home/mysql/usr/local/mysql/lib/libssl.so.1.0.0 /usr/lib64/libssl.so.1.0.0
    cp /home/mysql/usr/local/mysql/lib/libcrypto.so.1.0.0 /usr/lib64/libcrypto.so.1.0.0
    ulimit -n 655350
    # /etc/security/limits.conf
    # * soft nproc 655350
    # * hard nproc 655350
    # * soft nofile 655350
    # * hard nofile 655350
    # /etc/sysctl.conf
    # fs.file-max=655350
    sudo -u mysql ./bin/mysqld --defaults-file=$config_file --initialize-insecure --user=mysql --basedir=$base_dir/usr/local/mysql --datadir=$base_dir/usr/local/mysql/data/
    sudo -u mysql ./bin/mysql_ssl_rsa_setup --uid=$(id -u mysql) --basedir=$base_dir/usr/local/mysql --datadir=$base_dir/usr/local/mysql/data/
    cp support-files/mysql.server /etc/init.d/mysqld
    chmod 755 /etc/init.d/mysqld
    chkconfig mysqld on
    systemctl daemon-reload
    systemctl start mysqld
    systemctl status mysqld
    systemctl enable mysqld
    mysql_root_password="$(openssl rand -base64 20)"
    mysqladmin -uroot password "$mysql_root_password" 2>/dev/null
    echo "Please remember your MySQL database root password $mysql_root_password"
    # mysql -uroot -p"$mysql_root_password" -e "SELECT PLUGIN_NAME,PLUGIN_VERSION,PLUGIN_STATUS,LOAD_OPTION FROM information_schema.PLUGINS WHERE PLUGIN_NAME='validate_password'\G;"
    mysql -uroot -p"$mysql_root_password" -e "INSTALL PLUGIN validate_password SONAME 'validate_password.so';" 2>/dev/null
    echo "validate_password_policy                               = MEDIUM" >> $config_file
}

case $1 in
    init)
        init "$2"
    ;;
esac
