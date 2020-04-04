#!/usr/bin/env bash
# Redis script file example
#     ./redis.ubuntu.18.04.sh $1 $2 $3 $4
#     ./redis.ubuntu.18.04.sh init 4.0.14 8.8.8.8 6379
# Redis configuration file example
#     http://download.redis.io/redis-stable/redis.conf
#
#
# if you want to create a redis cluster on two servers, you need three redis nodes per server, and then refer to the following steps
#    
# step 1. each redis node needs to enable the following options
#     a. cluster-enabled                    yes
#     b. cluster-node-timeout               11000
#     c. cluster-require-full-coverage      no
# note: first close the redis node, then modify the configuration, and finally start the redis node
#    
# step 2. execute a command on any redis node to create a redis cluster
# redis-cli --cluster create 192.168.1.1:6379 \
#                            192.168.1.1:6380 \
#                            192.168.1.1:6381 \
#                            192.168.1.2:6382 \
#                            192.168.1.2:6383 \
#                            192.168.1.2:6384 \
#           --cluster-replicas 1 -a 'you redis password' to create cluster
# note: each redis node password must be the same
#
# step 3. Add firewall settings to /etc/sysconfig/iptables
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 6379 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 6380 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 6381 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 6382 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 6383 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 6384 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 6379 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 6380 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 6381 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 6382 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 6383 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 6384 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 16379 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 16380 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 16381 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 16382 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 16383 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.1 --dport 16384 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 16379 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 16380 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 16381 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 16382 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 16383 -j ACCEPT
# -A INPUT -m comment --comment "Added by administrator, for redis" -p tcp -m state --state NEW -m tcp -s 192.168.1.2 --dport 16384 -j ACCEPT

init(){
    bind="$2"
    port="$3"
    systemctl stop redis_$port
    systemctl disable redis_$port
    systemctl status redis_$port
    rm -f /usr/bin/redis-server
    rm -f /usr/bin/redis-sentinel
    rm -f /usr/bin/redis-cli
    rm -f /usr/lib/systemd/system/redis*
    rm -f /usr/libexec/redis*
    userdel -r redis
    apt -y install libssl-dev make gcc wget curl vim lrzsz
    base_dir="/home/redis"
    redis_config_file="$base_dir/etc/redis/redis_$port.conf"
    redis_sentinel_config_file="$base_dir/etc/redis/redis_2$port-sentinel.conf"
    password="$(openssl rand -base64 20)"
    redis_pidfile="$base_dir/var/run/redis/redis_$port.pid"
    redis_sentinel_pidfile="$base_dir/var/run/redis/redis_2$port-sentinel.pid"
    redis_logfile="$base_dir/var/log/redis/redis_$port.log"
    redis_sentinel_logfile="$base_dir/var/log/redis/redis_2$port-sentinel.log"
    data_dir="$base_dir/var/lib/redis"
    dbfilename="dump_$port.rdb"
    appendfilename="appendonly_$port.aof"
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
    source /etc/profile.d/rvm.sh
    rvm list known
    rvm install 2.4.1
    gem install redis
    useradd -r -s /sbin/nologin -m -d $base_dir -c 'Redis Database Server' redis
    cd $base_dir
    wget "http://download.redis.io/releases/redis-$1.tar.gz"
    mkdir -p $base_dir/usr/local
    mkdir -p $base_dir/var/log/redis
    mkdir -p $base_dir/var/run/redis
    mkdir -p $base_dir/var/lib/redis
    mkdir -p $base_dir/etc/redis
    mkdir -p $base_dir/tmp
    chown -R redis:redis $base_dir/var/log/redis
    chown -R redis:redis $base_dir/var/run/redis
    chown -R redis:redis $base_dir/var/lib/redis
    chown -R redis:redis $base_dir/etc/redis
    chown -R redis:redis $base_dir/tmp
    chmod -R 700 $base_dir/var/log/redis
    chmod -R 700 $base_dir/var/run/redis
    chmod -R 700 $base_dir/var/lib/redis
    chmod -R 700 $base_dir/etc/redis
    chmod -R 700 $base_dir/tmp
    tar -xf redis-$1.tar.gz -C $base_dir/usr/local
    rm -f redis-$1.tar.gz
    cd $base_dir/usr/local/redis-$1
    make -j2
    cp src/redis-server                  /usr/bin/
    cp src/redis-cli                     /usr/bin/
    cp src/redis-sentinel                /usr/bin/
    echo "bind                                 $bind"                                                                                                 > $redis_config_file
    echo "protected-mode                       yes"                                                                                                   >> $redis_config_file
    echo "port                                 $port"                                                                                                 >> $redis_config_file
    echo "tcp-backlog                          511"                                                                                                   >> $redis_config_file
    echo "timeout                              0"                                                                                                     >> $redis_config_file
    echo "tcp-keepalive                        300"                                                                                                   >> $redis_config_file
    echo "daemonize                            yes"                                                                                                   >> $redis_config_file
    echo "supervised                           no"                                                                                                    >> $redis_config_file
    echo "pidfile                              \"$redis_pidfile\""                                                                                    >> $redis_config_file
    echo "loglevel                             notice"                                                                                                >> $redis_config_file
    echo "logfile                              \"$redis_logfile\""                                                                                    >> $redis_config_file
    echo "databases                            16"                                                                                                    >> $redis_config_file
    echo "always-show-logo                     yes"                                                                                                   >> $redis_config_file
    echo "stop-writes-on-bgsave-error          yes"                                                                                                   >> $redis_config_file
    echo "rdbcompression                       yes"                                                                                                   >> $redis_config_file
    echo "rdbchecksum                          yes"                                                                                                   >> $redis_config_file
    echo "save                                 900 1"                                                                                                 >> $redis_config_file
    echo "save                                 300 10"                                                                                                >> $redis_config_file
    echo "save                                 60 10000"                                                                                              >> $redis_config_file
    echo "dbfilename                           \"$dbfilename\""                                                                                       >> $redis_config_file
    echo "dir                                  \"$data_dir\""                                                                                         >> $redis_config_file
    echo "slave-serve-stale-data               yes"                                                                                                   >> $redis_config_file
    echo "slave-read-only                      yes"                                                                                                   >> $redis_config_file
    echo "repl-diskless-sync                   no"                                                                                                    >> $redis_config_file
    echo "repl-diskless-sync-delay             5"                                                                                                     >> $redis_config_file
    echo "repl-disable-tcp-nodelay             no"                                                                                                    >> $redis_config_file
    echo "slave-priority                       100"                                                                                                   >> $redis_config_file
    echo "lazyfree-lazy-eviction               no"                                                                                                    >> $redis_config_file
    echo "lazyfree-lazy-expire                 no"                                                                                                    >> $redis_config_file
    echo "lazyfree-lazy-server-del             no"                                                                                                    >> $redis_config_file
    echo "slave-lazy-flush                     no"                                                                                                    >> $redis_config_file
    echo "appendonly                           yes"                                                                                                   >> $redis_config_file
    echo "appendfilename                       \"$appendfilename\""                                                                                   >> $redis_config_file
    echo "appendfsync                          everysec"                                                                                              >> $redis_config_file
    echo "no-appendfsync-on-rewrite            no"                                                                                                    >> $redis_config_file
    echo "auto-aof-rewrite-percentage          100"                                                                                                   >> $redis_config_file
    echo "auto-aof-rewrite-min-size            64mb"                                                                                                  >> $redis_config_file
    echo "aof-load-truncated                   yes"                                                                                                   >> $redis_config_file
    echo "aof-use-rdb-preamble                 no"                                                                                                    >> $redis_config_file
    echo "lua-time-limit                       5000"                                                                                                  >> $redis_config_file
    echo "# cluster-enabled                    yes"                                                                                                   >> $redis_config_file
    echo "# cluster-config-file                \"$base_dir/usr/local/redis-$1/redis-cluster/nodes-$port/redis_$port.conf\""                           >> $redis_config_file
    echo "# cluster-node-timeout               11000"                                                                                                 >> $redis_config_file
    echo "# cluster-require-full-coverage      no"                                                                                                    >> $redis_config_file
    echo "slowlog-log-slower-than              1000"                                                                                                  >> $redis_config_file
    echo "slowlog-max-len                      2000"                                                                                                  >> $redis_config_file
    echo "latency-monitor-threshold            0"                                                                                                     >> $redis_config_file
    echo "notify-keyspace-events               \"\""                                                                                                  >> $redis_config_file
    echo "hash-max-ziplist-entries             512"                                                                                                   >> $redis_config_file
    echo "hash-max-ziplist-value               64"                                                                                                    >> $redis_config_file
    echo "list-max-ziplist-size                -2"                                                                                                    >> $redis_config_file
    echo "list-compress-depth                  0"                                                                                                     >> $redis_config_file
    echo "set-max-intset-entries               512"                                                                                                   >> $redis_config_file
    echo "zset-max-ziplist-entries             128"                                                                                                   >> $redis_config_file
    echo "zset-max-ziplist-value               64"                                                                                                    >> $redis_config_file
    echo "hll-sparse-max-bytes                 3000"                                                                                                  >> $redis_config_file
    echo "activerehashing                      yes"                                                                                                   >> $redis_config_file
    echo "client-output-buffer-limit           normal 0 0 0"                                                                                          >> $redis_config_file
    echo "client-output-buffer-limit           slave 256mb 64mb 60"                                                                                   >> $redis_config_file
    echo "client-output-buffer-limit           pubsub 32mb 8mb 60"                                                                                    >> $redis_config_file
    echo "hz                                   10"                                                                                                    >> $redis_config_file
    echo "aof-rewrite-incremental-fsync        yes"                                                                                                   >> $redis_config_file
    echo "# Generated by CONFIG REWRITE"                                                                                                              >> $redis_config_file
    echo "# redis replication"                                                                                                                        >> $redis_config_file
    echo "# masterauth                         $password"                                                                                             >> $redis_config_file
    echo "# replicaof                          redis_master_ip redis_master_port"                                                                     >> $redis_config_file
    echo "requirepass                          $password"                                                                                             >> $redis_config_file
    echo "port                                 2$port"                                                                                                > $redis_sentinel_config_file
    echo "daemonize                            yes"                                                                                                   >> $redis_sentinel_config_file
    echo "pidfile                              $redis_sentinel_pidfile"                                                                               >> $redis_sentinel_config_file
    echo "logfile                              \"$redis_sentinel_logfile\""                                                                           >> $redis_sentinel_config_file
    echo "dir                                  $base_dir/tmp"                                                                                         >> $redis_sentinel_config_file
    echo "sentinel monitor mymaster $bind $port 2"                                                                                                    >> $redis_sentinel_config_file
    echo "sentinel down-after-milliseconds mymaster 30000"                                                                                            >> $redis_sentinel_config_file
    echo "sentinel parallel-syncs mymaster 1"                                                                                                         >> $redis_sentinel_config_file
    echo "sentinel failover-timeout mymaster 180000"                                                                                                  >> $redis_sentinel_config_file
    echo "sentinel deny-scripts-reconfig yes"                                                                                                         >> $redis_sentinel_config_file
    echo "sentinel auth-pass mymaster $password"                                                                                                      >> $redis_sentinel_config_file
    echo "protected-mode no"                                                                                                                          >> $redis_sentinel_config_file
    wget -O "/usr/lib/systemd/system/redis_$port.service" https://0vj6.github.io/sh/redis/redis.service
    wget -O "/usr/lib/systemd/system/redis_2$port-sentinel.service" https://0vj6.github.io/sh/redis/redis-sentinel.service
    wget -O "/usr/libexec/redis_$port-shutdown" https://0vj6.github.io/sh/redis/redis-shutdown
    sed -i "s/\/etc\/redis.conf/\/home\/redis\/etc\/redis\/redis_$port.conf/g" /usr/lib/systemd/system/redis_$port.service
    sed -i "s/redis-shutdown/redis_$port-shutdown/g" /usr/lib/systemd/system/redis_$port.service
    sed -i "s/\/etc\/redis-sentinel.conf/\/home\/redis\/etc\/redis\/redis_2$port-sentinel.conf/g" /usr/lib/systemd/system/redis_2$port-sentinel.service
    sed -i "s/redis-shutdown/redis_$port-shutdown/g" /usr/lib/systemd/system/redis_2$port-sentinel.service
    sed -i "s/\/etc\/\$SERVICE_NAME.conf/\/home\/redis\/etc\/redis\/redis_$port.conf/g" /usr/libexec/redis_$port-shutdown
    sed -i "s/SERVICE_NAME=redis/SERVICE_NAME=redis_$port/g" /usr/libexec/redis_$port-shutdown
    systemctl enable redis_$port
    systemctl start redis_$port
    systemctl status redis_$port
    # sudo -uredis $base_dir/usr/local/redis-$1/src/redis-server $redis_config_file
    ps -o user,stime,etime,pid,ppid,command -u redis
}

case $1 in
    init)
        init "$2" "$3" "$4"
    ;;
esac
