#!/usr/bin/env bash
# Redis script file example
#     ./redis.centos6.sh $1 $2 $3 $4
#     ./redis.centos6.sh init 4.0.14 8.8.8.8 6379
# Redis configuration file example
#     http://download.redis.io/redis-stable/redis.conf

init(){
    kill -9 "$(ps -o pid -u redis | grep -v "PID")"
    rm -f /usr/bin/redis-server
    rm -f /usr/bin/redis-cli
    userdel -r redis
    base_dir="/home/redis"
    config_file="$base_dir/etc/redis/redis.conf"
    bind="$2"
    password="$(openssl rand -base64 20)"
    port="$3"
    pidfile="$base_dir/var/run/redis/redis_$port.pid"
    logfile="$base_dir/var/log/redis/redis_$port.log"
    dir="$base_dir/var/lib/redis"
    dbfilename="dump_$port.rdb"
    appendfilename="appendonly_$port.aof"
    yum -y install openssl-devel make gcc libyaml
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
    chown -R redis:redis $base_dir/var/log/redis
    chown -R redis:redis $base_dir/var/run/redis
    chown -R redis:redis $base_dir/var/lib/redis
    chown -R redis:redis $base_dir/etc/redis
    chmod -R 700 $base_dir/var/log/redis
    chmod -R 700 $base_dir/var/run/redis
    chmod -R 700 $base_dir/var/lib/redis
    chmod -R 700 $base_dir/etc/redis
    tar -xf redis-$1.tar.gz -C $base_dir/usr/local
    rm -f redis-$1.tar.gz
    cd $base_dir/usr/local/redis-$1
    make -j2
    cp src/redis-server /usr/bin
    cp src/redis-cli /usr/bin
    echo "bind                                 $bind"                                                                                                 > $config_file
    echo "protected-mode                       yes"                                                                                                   >> $config_file
    echo "port                                 $port"                                                                                                 >> $config_file
    echo "tcp-backlog                          511"                                                                                                   >> $config_file
    echo "timeout                              0"                                                                                                     >> $config_file
    echo "tcp-keepalive                        300"                                                                                                   >> $config_file
    echo "daemonize                            yes"                                                                                                   >> $config_file
    echo "supervised                           no"                                                                                                    >> $config_file
    echo "pidfile                              \"$pidfile\""                                                                                          >> $config_file
    echo "loglevel                             notice"                                                                                                >> $config_file
    echo "logfile                              \"$logfile\""                                                                                          >> $config_file
    echo "databases                            16"                                                                                                    >> $config_file
    echo "always-show-logo                     yes"                                                                                                   >> $config_file
    echo "stop-writes-on-bgsave-error          yes"                                                                                                   >> $config_file
    echo "rdbcompression                       yes"                                                                                                   >> $config_file
    echo "rdbchecksum                          yes"                                                                                                   >> $config_file
    echo "save                                 900 1"                                                                                                 >> $config_file
    echo "save                                 300 10"                                                                                                >> $config_file
    echo "save                                 60 10000"                                                                                              >> $config_file
    echo "dbfilename                           \"$dbfilename\""                                                                                       >> $config_file
    echo "dir                                  \"$dir\""                                                                                              >> $config_file
    echo "slave-serve-stale-data               yes"                                                                                                   >> $config_file
    echo "slave-read-only                      yes"                                                                                                   >> $config_file
    echo "repl-diskless-sync                   no"                                                                                                    >> $config_file
    echo "repl-diskless-sync-delay             5"                                                                                                     >> $config_file
    echo "repl-disable-tcp-nodelay             no"                                                                                                    >> $config_file
    echo "slave-priority                       100"                                                                                                   >> $config_file
    echo "lazyfree-lazy-eviction               no"                                                                                                    >> $config_file
    echo "lazyfree-lazy-expire                 no"                                                                                                    >> $config_file
    echo "lazyfree-lazy-server-del             no"                                                                                                    >> $config_file
    echo "slave-lazy-flush                     no"                                                                                                    >> $config_file
    echo "appendonly                           yes"                                                                                                   >> $config_file
    echo "appendfilename                       \"$appendfilename\""                                                                                   >> $config_file
    echo "appendfsync                          everysec"                                                                                              >> $config_file
    echo "no-appendfsync-on-rewrite            no"                                                                                                    >> $config_file
    echo "auto-aof-rewrite-percentage          100"                                                                                                   >> $config_file
    echo "auto-aof-rewrite-min-size            64mb"                                                                                                  >> $config_file
    echo "aof-load-truncated                   yes"                                                                                                   >> $config_file
    echo "aof-use-rdb-preamble                 no"                                                                                                    >> $config_file
    echo "lua-time-limit                       5000"                                                                                                  >> $config_file
    echo "# cluster-enabled                    yes"                                                                                                   >> $config_file
    echo "# cluster-config-file                \"$base_dir/usr/local/redis-$1/redis-cluster/nodes-$port/redis_$port.conf\""                           >> $config_file
    echo "# cluster-node-timeout               11000"                                                                                                 >> $config_file
    echo "# cluster-require-full-coverage      no"                                                                                                    >> $config_file
    echo "slowlog-log-slower-than              1000"                                                                                                  >> $config_file
    echo "slowlog-max-len                      2000"                                                                                                  >> $config_file
    echo "latency-monitor-threshold            0"                                                                                                     >> $config_file
    echo "notify-keyspace-events               \"\""                                                                                                  >> $config_file
    echo "hash-max-ziplist-entries             512"                                                                                                   >> $config_file
    echo "hash-max-ziplist-value               64"                                                                                                    >> $config_file
    echo "list-max-ziplist-size                -2"                                                                                                    >> $config_file
    echo "list-compress-depth                  0"                                                                                                     >> $config_file
    echo "set-max-intset-entries               512"                                                                                                   >> $config_file
    echo "zset-max-ziplist-entries             128"                                                                                                   >> $config_file
    echo "zset-max-ziplist-value               64"                                                                                                    >> $config_file
    echo "hll-sparse-max-bytes                 3000"                                                                                                  >> $config_file
    echo "activerehashing                      yes"                                                                                                   >> $config_file
    echo "client-output-buffer-limit           normal 0 0 0"                                                                                          >> $config_file
    echo "client-output-buffer-limit           slave 256mb 64mb 60"                                                                                   >> $config_file
    echo "client-output-buffer-limit           pubsub 32mb 8mb 60"                                                                                    >> $config_file
    echo "hz                                   10"                                                                                                    >> $config_file
    echo "aof-rewrite-incremental-fsync        yes"                                                                                                   >> $config_file
    echo "# Generated by CONFIG REWRITE"                                                                                                              >> $config_file
    echo "masterauth                           \"$password\""                                                                                       >> $config_file
    echo "requirepass                          \"$password\""                                                                                       >> $config_file
    sudo -uredis $base_dir/usr/local/redis-$1/src/redis-server $config_file
    ps -o user,stime,etime,pid,ppid,command -u redis
}

case $1 in
    init)
        init "$2" "$3" "$4"
    ;;
esac
