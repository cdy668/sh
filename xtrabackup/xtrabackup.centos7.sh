#!/usr/bin/env bash
# xtrabackup script file example
# 安装xtrabackup
# ./xtrabackup.centos7.sh init 24
# 全库全量备份
# ./xtrabackup.centos7.sh backup_all_database
# 全库全量恢复
# ./xtrabackup.centos7.sh recovery_all_database 20200101
# 全库增量备份
# ./xtrabackup.centos7.sh incremental_backup_of_all_database
# 全库增量恢复
# ./xtrabackup.centos7.sh incremental_recovery_of_all_database 20200101 7
# 单库全量备份
# ./xtrabackup.centos7.sh backup_a_single_database "database name"
# 单库全量恢复
# ./xtrabackup.centos7.sh recovery_a_single_database 20200101 "database name"
# 单库增量备份
# ./xtrabackup.centos7.sh incremental_backup_of_a_single_database "database name"
# 单库增量恢复
# ./xtrabackup.centos7.sh incremental_recovery_of_a_single_database 20200101 "database name" 7

WORKSPACE="/home/mysql/xtrabackup"
if [[ ! -d "$WORKSPACE" ]];then
    mkdir -p $WORKSPACE
fi

MYSQL_USERNAME="root"
MYSQL_PASSWORD=""
MYSQL_HOST="localhost"
MYSQL_DATADIR="/usr/local/mysql/data"
MYSQL_CNF="/etc/my.cnf"
MYSQL_PORT="3306"
MYSQL_SOCK="/tmp/mysql.sock"
MYSQL_SLAVE="OFF"
SERVICE_NAME="mysqld"

init(){
    yum -y install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
    percona-release enable-only tools release
    yum -y install "percona-xtrabackup-$1"
}

mysql_status(){
    if [[ "$1" = "stop" ]];then
        systemctl stop $SERVICE_NAME
        systemctl status $SERVICE_NAME
    elif [[ "$1" = "start" ]];then
        systemctl start $SERVICE_NAME
        systemctl status $SERVICE_NAME
    fi
}

# 备份所有数据库 
backup_all_database(){
    echo "$(date +"%y%m%d %H:%M:%S") 正在进行全库全量备份，备份目录为$WORKSPACE/$(date +"%Y%m%d")/base，被备份目录为$MYSQL_DATADIR"
    mkdir -p "$WORKSPACE/$(date +"%Y%m%d")/base"
    if [[ "$MYSQL_SLAVE" = "ON" ]];then
        xtrabackup --defaults-file=$MYSQL_CNF \
                   --backup \
                   --slave-info \
                   --target-dir="$WORKSPACE/$(date +"%Y%m%d")/base" \
                   --user=$MYSQL_USERNAME \
                   --password=$MYSQL_PASSWORD \
                   --host=$MYSQL_HOST \
                   --port=$MYSQL_PORT \
                   --socket=$MYSQL_SOCK \
                   --datadir=$MYSQL_DATADIR
    else
        xtrabackup --defaults-file=$MYSQL_CNF \
                   --backup \
                   --target-dir="$WORKSPACE/$(date +"%Y%m%d")/base" \
                   --user=$MYSQL_USERNAME \
                   --password=$MYSQL_PASSWORD \
                   --host=$MYSQL_HOST \
                   --port=$MYSQL_PORT \
                   --socket=$MYSQL_SOCK \
                   --datadir=$MYSQL_DATADIR
    fi
}

# 恢复所有数据库
recovery_all_database(){
    if [[ -d "$WORKSPACE/$1/base" ]];then
        mysql_status stop
        echo "$(date +"%y%m%d %H:%M:%S") 正在准备全库原始基础备份$WORKSPACE/$1/base"
        xtrabackup --prepare \
                   --use-memory=1G \
                   --target-dir="$WORKSPACE/$1/base"
        echo "$(date +"%y%m%d %H:%M:%S") 正在进行全库全量恢复，恢复目录为$WORKSPACE/$1/base，被恢复目录为$MYSQL_DATADIR"
        xtrabackup --copy-back \
                   --target-dir="$WORKSPACE/$1/base"
        rsync -avrP "$WORKSPACE/$1/base/" $MYSQL_DATADIR/
        chown -R mysql:mysql $MYSQL_DATADIR
        chmod -R 750 $MYSQL_DATADIR
        mysql_status start
    else
        echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$1/base，本次恢复操作未改变任何数据库数据"
    fi
}

# 备份一个数据库
backup_a_single_database(){
    echo "$(date +"%y%m%d %H:%M:%S") 正在进行$1数据库全量备份，备份目录为$WORKSPACE/$(date +"%Y%m%d")/$1_base，被备份目录为$MYSQL_DATADIR/$1"
    mkdir -p "$WORKSPACE/$(date +"%Y%m%d")/$1_base"
    if [[ "$MYSQL_SLAVE" = "ON" ]];then
        xtrabackup --defaults-file=$MYSQL_CNF \
                   --backup \
                   --slave-info \
                   --target-dir="$WORKSPACE/$(date +"%Y%m%d")/$1_base" \
                   --databases="$1" \
                   --user=$MYSQL_USERNAME \
                   --password=$MYSQL_PASSWORD \
                   --host=$MYSQL_HOST \
                   --port=$MYSQL_PORT \
                   --socket=$MYSQL_SOCK \
                   --datadir=$MYSQL_DATADIR
    else
        xtrabackup --defaults-file=$MYSQL_CNF \
                   --backup \
                   --target-dir="$WORKSPACE/$(date +"%Y%m%d")/$1_base" \
                   --databases="$1" \
                   --user=$MYSQL_USERNAME \
                   --password=$MYSQL_PASSWORD \
                   --host=$MYSQL_HOST \
                   --port=$MYSQL_PORT \
                   --socket=$MYSQL_SOCK \
                   --datadir=$MYSQL_DATADIR
    fi
}

# 恢复一个数据库
recovery_a_single_database(){
    if [[ -d $WORKSPACE/$1/$2_base ]];then
        mysql_status stop
        echo "$(date +"%y%m%d %H:%M:%S") 正在准备$2数据库原始基础备份$WORKSPACE/$1/$2_base"
        xtrabackup --prepare \
                   --use-memory=1G \
                   --target-dir="$WORKSPACE/$1/$2_base"
        echo "$(date +"%y%m%d %H:%M:%S") 正在进行$2数据库全量恢复，恢复目录为$WORKSPACE/$1/$2_base，被恢复目录为$MYSQL_DATADIR/$2"
        xtrabackup --copy-back \
                   --force-non-empty-directories \
                   --target-dir="$WORKSPACE/$1/$2_base/"
        rsync -avrP "$WORKSPACE/$1/$2_base/" $MYSQL_DATADIR/
        chown -R mysql:mysql $MYSQL_DATADIR
        chmod -R 750 $MYSQL_DATADIR
        mysql_status start
    else
        echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$1/$2_base，本次恢复操作未改变任何数据库数据"
    fi
}

# 全库增量备份
incremental_backup_of_all_database(){
    if [[ "$1" -gt "0" ]];then
        latest_date="$1"
    else
        latest_date="$(date +"%Y%m%d")"
    fi
    if [[ -d "$WORKSPACE/$latest_date/base" ]];then
        if [[ -d "$WORKSPACE/$latest_date/base_plus_1" ]];then
            latest_number="$(ls "$WORKSPACE/$latest_date/" 2>/dev/null | grep -oE "^base_plus_[0-9]{1,100}$" | sed "s/base_plus_//g" | sort -n | awk 'END {print}')"
            new_number="$(echo "$latest_number+1" | bc -l)"
            echo "$(date +"%y%m%d %H:%M:%S") 检测到最新的增量备份为$WORKSPACE/$latest_date/base_plus_$latest_number"
            echo "$(date +"%y%m%d %H:%M:%S") 检测到最新原始基础备份为$WORKSPACE/$latest_date/base"
            echo "$(date +"%y%m%d %H:%M:%S") 本次增量基础备份为$WORKSPACE/$latest_date/base_plus_$latest_number"
            echo "$(date +"%y%m%d %H:%M:%S") 本次增量备份为$WORKSPACE/$latest_date/base_plus_$new_number"
            echo "$(date +"%y%m%d %H:%M:%S") 正在进行全库增量备份，备份目录为$WORKSPACE/$latest_date/base_plus_$new_number，被备份目录为$MYSQL_DATADIR"
            mkdir -p "$WORKSPACE/$latest_date/base_plus_$new_number"
            if [[ "$MYSQL_SLAVE" = "ON" ]];then
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --slave-info \
                           --target-dir="$WORKSPACE/$latest_date/base_plus_$new_number" \
                           --incremental-basedir="$WORKSPACE/$latest_date/base_plus_$latest_number" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            else
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --target-dir="$WORKSPACE/$latest_date/base_plus_$new_number" \
                           --incremental-basedir="$WORKSPACE/$latest_date/base_plus_$latest_number" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            fi
        else
            echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$latest_date/base_plus_1"
            echo "$(date +"%y%m%d %H:%M:%S") 检测到最新原始基础备份为$WORKSPACE/$latest_date/base"
            echo "$(date +"%y%m%d %H:%M:%S") 本次增量基础备份为$WORKSPACE/$latest_date/base"
            echo "$(date +"%y%m%d %H:%M:%S") 本次增量备份为$WORKSPACE/$latest_date/base_plus_1"
            echo "$(date +"%y%m%d %H:%M:%S") 正在进行首次全库增量备份，备份目录为$WORKSPACE/$latest_date/base_plus_1，被备份目录为$MYSQL_DATADIR"
            mkdir -p "$WORKSPACE/$latest_date/base_plus_1"
            if [[ "$MYSQL_SLAVE" = "ON" ]];then
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --slave-info \
                           --target-dir="$WORKSPACE/$latest_date/base_plus_1" \
                           --incremental-basedir="$WORKSPACE/$latest_date/base" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            else
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --target-dir="$WORKSPACE/$latest_date/base_plus_1" \
                           --incremental-basedir="$WORKSPACE/$latest_date/base" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            fi
        fi
    else
        echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$latest_date/base，正在进行首次全库全量备份"
        backup_all_database
    fi
}

# 全库增量恢复
incremental_recovery_of_all_database(){
    if [[ -d "$WORKSPACE/$1/base" ]];then
        if [[ -d "$WORKSPACE/$1/base_plus_$2" ]];then
            mysql_status stop
            echo "$(date +"%y%m%d %H:%M:%S") 正在准备全库原始基础备份$WORKSPACE/$1/base"
            xtrabackup --prepare \
                       --use-memory=1G \
                       --apply-log-only \
                       --target-dir="$WORKSPACE/$1/base"
            for ((number=1;number<=$2;number++))
            do
                echo "$(date +"%y%m%d %H:%M:%S") 正在准备全库增量备份$WORKSPACE/$1/base_plus_$number"
                if [[ "$number" -eq "$2" ]];then
                    xtrabackup --prepare \
                               --use-memory=1G \
                               --target-dir="$WORKSPACE/$1/base" \
                               --incremental-dir="$WORKSPACE/$1/base_plus_$number"
                else
                    xtrabackup --prepare \
                               --use-memory=1G \
                               --apply-log-only \
                               --target-dir="$WORKSPACE/$1/base" \
                               --incremental-dir="$WORKSPACE/$1/base_plus_$number"
                fi
            done
            echo "$(date +"%y%m%d %H:%M:%S") 正在进行全库增量恢复，恢复目录为$WORKSPACE/$1/base，被恢复目录为$MYSQL_DATADIR"
            xtrabackup --copy-back \
                       --target-dir="$WORKSPACE/$1/base"
            rsync -avrP "$WORKSPACE/$1/base/" $MYSQL_DATADIR/
            chown -R mysql:mysql $MYSQL_DATADIR
            chmod -R 750 $MYSQL_DATADIR
            mysql_status start
        else
            echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$1/base_plus_$2，本次恢复操作未改变任何数据库数据"
        fi
    else
        echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$1/base，本次恢复操作未改变任何数据库数据"
    fi
}

# 单库增量备份
incremental_backup_of_a_single_database(){
    if [[ "$2" -gt "0" ]];then
        latest_date="$2"
    else
        latest_date="$(date +"%Y%m%d")"
    fi
    if [[ -d "$WORKSPACE/$latest_date/$1_base" ]];then
        if [[ -d "$WORKSPACE/$latest_date/$1_base_plus_1" ]];then
            latest_number="$(ls "$WORKSPACE/$latest_date/" 2>/dev/null | grep -oE "^$1_base_plus_[0-9]{1,100}$" | sed "s/$1_base_plus_//g" | sort -n | awk 'END {print}')"
            new_number="$(echo "$latest_number+1" | bc -l)"
            echo "$(date +"%y%m%d %H:%M:%S") 检测到$1数据库最新的增量备份为$WORKSPACE/$latest_date/$1_base_plus_$latest_number"
            echo "$(date +"%y%m%d %H:%M:%S") 检测到$1数据库最新原始基础备份为$WORKSPACE/$latest_date/$1_base"
            echo "$(date +"%y%m%d %H:%M:%S") 本次$1数据库增量基础备份为$WORKSPACE/$latest_date/$1_base_plus_$latest_number"
            echo "$(date +"%y%m%d %H:%M:%S") 本次$1数据库增量备份为$WORKSPACE/$latest_date/$1_base_plus_$new_number"
            echo "$(date +"%y%m%d %H:%M:%S") 正在进行$1数据库增量备份，备份目录为$WORKSPACE/$latest_date/$1_base_plus_$new_number，被备份目录为$MYSQL_DATADIR/$1"
            mkdir -p "$WORKSPACE/$(date +"%Y%m%d")/$1_base_plus_$new_number"
            if [[ "$MYSQL_SLAVE" = "ON" ]];then
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --slave-info \
                           --target-dir="$WORKSPACE/$latest_date/$1_base_plus_$new_number" \
                           --incremental-basedir="$WORKSPACE/$latest_date/$1_base_plus_$latest_number" \
                           --databases="$1" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            else
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --target-dir="$WORKSPACE/$latest_date/$1_base_plus_$new_number" \
                           --incremental-basedir="$WORKSPACE/$latest_date/$1_base_plus_$latest_number" \
                           --databases="$1" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            fi
        else
            echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$latest_date/$1_base_plus_1"
            echo "$(date +"%y%m%d %H:%M:%S") 检测到$1数据库最新原始基础备份为$WORKSPACE/$latest_date/$1_base"
            echo "$(date +"%y%m%d %H:%M:%S") 本次$1数据库增量基础备份为$WORKSPACE/$latest_date/$1_base"
            echo "$(date +"%y%m%d %H:%M:%S") 本次$1数据库增量备份为$WORKSPACE/$latest_date/$1_base_plus_1"
            echo "$(date +"%y%m%d %H:%M:%S") 正在进行首次$1数据库增量备份，备份目录为$WORKSPACE/$latest_date/$1_base_plus_1，被备份目录为$MYSQL_DATADIR/$1"
            mkdir -p "$WORKSPACE/$1_base_plus_1"
            if [[ "$MYSQL_SLAVE" = "ON" ]];then
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --slave-info \
                           --target-dir="$WORKSPACE/$latest_date/$1_base_plus_1" \
                           --incremental-basedir="$WORKSPACE/$latest_date/$1_base" \
                           --databases="$1" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            else
                xtrabackup --defaults-file=$MYSQL_CNF \
                           --backup \
                           --target-dir="$WORKSPACE/$latest_date/$1_base_plus_1" \
                           --incremental-basedir="$WORKSPACE/$latest_date/$1_base" \
                           --databases="$1" \
                           --user=$MYSQL_USERNAME \
                           --password=$MYSQL_PASSWORD \
                           --host=$MYSQL_HOST \
                           --port=$MYSQL_PORT \
                           --socket=$MYSQL_SOCK \
                           --datadir=$MYSQL_DATADIR
            fi
        fi
    else
        echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$latest_date/$1_base，正在进行首次$1数据库全量备份"
        backup_a_single_database "$1"
    fi
}

# 单库增量恢复
incremental_recovery_of_a_single_database(){
    if [[ -d "$WORKSPACE/$1/$2_base" ]];then
        if [[ -d "$WORKSPACE/$1/$2_base_plus_$3" ]];then
            mysql_status stop
            echo "$(date +"%y%m%d %H:%M:%S") 检测到$2数据库最新原始基础备份为$WORKSPACE/$1/$2_base"
            echo "$(date +"%y%m%d %H:%M:%S") 检测到$2数据库需要恢复到的增量备份为$WORKSPACE/$1/$2_base_plus_$3"
            echo "$(date +"%y%m%d %H:%M:%S") 正在准备$2数据库原始基础备份$WORKSPACE/$1/$2_base"
            xtrabackup --prepare \
                       --use-memory=1G \
                       --apply-log-only \
                       --target-dir="$WORKSPACE/$1/$2_base"
            for ((number=1;number<=$3;number++))
            do
                echo "$(date +"%y%m%d %H:%M:%S") 正在准备$2数据库增量备份$WORKSPACE/$1/$2_base_plus_$number"
                if [[ "$number" -eq "$3" ]];then
                    xtrabackup --prepare \
                               --use-memory=1G \
                               --target-dir="$WORKSPACE/$1/$2_base" \
                               --incremental-dir="$WORKSPACE/$1/$2_base_plus_$number"
                else
                    xtrabackup --prepare \
                               --use-memory=1G \
                               --apply-log-only \
                               --target-dir="$WORKSPACE/$1/$2_base" \
                               --incremental-dir="$WORKSPACE/$1/$2_base_plus_$number"
                fi
            done
            echo "$(date +"%y%m%d %H:%M:%S") 正在进行$2数据库增量恢复，恢复目录为$WORKSPACE/$1/$2_base/，被恢复目录为$MYSQL_DATADIR/$2"
            xtrabackup --copy-back \
                       --force-non-empty-directories \
                       --target-dir="$WORKSPACE/$1/$2_base"
            rsync -avrP "$WORKSPACE/$1/$2_base/" $MYSQL_DATADIR/
            chown -R mysql:mysql $MYSQL_DATADIR
            chmod -R 750 $MYSQL_DATADIR
            mysql_status start
        else
            echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$1/$2_base_plus_$3，本次恢复操作未改变任何数据库数据"
        fi
    else
        echo "$(date +"%y%m%d %H:%M:%S") 目录不存在或未检测到备份文件$WORKSPACE/$1/$2_base，本次恢复操作未改变任何数据库数据"
    fi
}

case $1 in
    backup_all_database)
        # 全库全量备份
        backup_all_database
    ;;
    recovery_all_database)
        # 全库全量恢复
        #     $2，代表需要恢复的日期，例如20200101
        recovery_all_database "$2"
    ;;
    backup_a_single_database)
        # 单库全量备份
        #     $2，代表需要备份的数据库，例如mysql
        backup_a_single_database "$2"
    ;;
    recovery_a_single_database)
        # 单库全量恢复
        #     $2，代表需要恢复的日期，例如20200101
        #     $3，代表需要恢复的数据库，例如mysql
        recovery_a_single_database "$2" "$3"
    ;;
    incremental_backup_of_all_database)
        # 全库增量备份
        incremental_backup_of_all_database ""
    ;;
    incremental_recovery_of_all_database)
        # 全库增量恢复
        #     $2，代表需要恢复的日期，例如20200101
        #     $3，代表需要恢复至第几次增量，例如7
        incremental_recovery_of_all_database "$2" "$3"
    ;;
    incremental_backup_of_a_single_database)
        # 单库增量备份
        #     $2，代表需要备份的数据库，例如mysql
        incremental_backup_of_a_single_database "$2"
    ;;
    incremental_recovery_of_a_single_database)
        # 单库增量恢复
        #     $2，代表需要恢复的日期，例如20200101
        #     $3，代表需要恢复的数据库，例如mysql
        #     $4，代表需要恢复至第几次增量，例如7
        incremental_recovery_of_a_single_database "$2" "$3" "$4"
    ;;
    init)
        # 安装percona-xtrabackup
        # $2，代表percona-xtrabackup的版本号，例如24
        init "$2"
    ;;
esac