#!/usr/bin/env bash
# Gogs script file example
#     ./gogs.centos7.sh $1 $2 $3
#     ./gogs.centos7.sh init 0.11.86 0.0.0.0
# Gogs Configuration Cheat Sheet
#     https://gogs.io/docs/advanced/configuration_cheat_sheet

init(){
    kill -9 "$(ps -o pid -u git | grep -v "PID")"
    userdel -r git
    base_dir="/home/git"
    config_file="$base_dir/usr/local/gogs/custom/conf/app.ini"
    bind_ip="$2"
    setenforce 0
    yum -y install git wget curl openssh-server
    systemctl restart sshd
    systemctl enable sshd
    systemctl status sshd
    wget "https://dl.gogs.io/$1/gogs_$1_linux_amd64.tar.gz"
    useradd -r -s /bin/bash -m -d $base_dir git
    mkdir -p $base_dir/.ssh
    touch $base_dir/.ssh/authorized_keys
    mkdir -p $base_dir/var/log/gogs
    mkdir -p $base_dir/usr/local
    mkdir -p $(dirname $config_file)
    mkdir -p $base_dir/var/lib/gogs/avatar
    mkdir -p $base_dir/var/lib/gogs/attachment
    mkdir -p $base_dir/var/lib/gogs/release
    mkdir -p $base_dir/var/lib/gogs/temp
    mkdir -p $base_dir/var/lib/gogs/data
    mkdir -p $base_dir/var/lib/gogs/gogs-repositories
    mkdir -p $base_dir/var/lib/gogs/sessions
    tar -xf gogs_$1_linux_amd64.tar.gz -C $base_dir/usr/local
    rm -f gogs_$1_linux_amd64.tar.gz
    chown -R git:git $base_dir/.ssh
    chmod -R 700 $base_dir/.ssh
    chmod 600 $base_dir/.ssh/authorized_keys
    chown -R git:git $base_dir/var/log/gogs
    chmod -R 700 $base_dir/var/log/gogs
    chown -R git:git $base_dir/usr/local/gogs
    chmod -R 700 $base_dir/usr/local/gogs
    chown -R git:git $base_dir/var/lib/gogs
    chmod -R 700 $base_dir/var/lib/gogs
    echo "APP_NAME                              = Gogs"                                           > $config_file
    echo "RUN_USER                              = git"                                            >> $config_file
    echo "RUN_MODE                              = prod"                                           >> $config_file
    echo "[database]"                                                                             >> $config_file
    echo "DB_TYPE                               = sqlite3"                                        >> $config_file
    echo "HOST                                  = "                                               >> $config_file
    echo "NAME                                  = "                                               >> $config_file
    echo "USER                                  = "                                               >> $config_file
    echo "PASSWD                                = "                                               >> $config_file
    echo "SSL_MODE                              = disable"                                        >> $config_file
    echo "PATH                                  = $base_dir/var/lib/gogs/data/gogs.db"            >> $config_file
    echo "[repository]"                                                                           >> $config_file
    echo "ROOT                                  = $base_dir/var/lib/gogs/gogs-repositories"       >> $config_file
    echo "FORCE_PRIVATE                         = true"                                           >> $config_file
    echo "MAX_CREATION_LIMIT                    = -1"                                             >> $config_file
    echo "PREFERRED_LICENSES                    = "                                               >> $config_file
    echo "DISABLE_HTTP_GIT                      = false"                                          >> $config_file
    echo "[server]"                                                                               >> $config_file
    echo "PROTOCOL                              = http"                                           >> $config_file
    echo "DOMAIN                                = $bind_ip"                                       >> $config_file
    echo "ROOT_URL                              = http://$bind_ip:3000"                           >> $config_file
    echo "HTTP_ADDR                             = $bind_ip"                                       >> $config_file
    echo "HTTP_PORT                             = 3000"                                           >> $config_file
    echo "DISABLE_SSH                           = false"                                          >> $config_file
    echo "START_SSH_SERVER                      = false"                                          >> $config_file
    echo "SSH_DOMAIN                            = $bind_ip"                                       >> $config_file
    echo "SSH_PORT                              = 22"                                             >> $config_file
    echo "SSH_ROOT_PATH                         = $base_dir/.ssh"                                 >> $config_file
    echo "REWRITE_AUTHORIZED_KEYS_AT_START      = true"                                           >> $config_file
    echo "SSH_KEYGEN_PATH                       = /usr/bin/ssh-keygen"                            >> $config_file
    echo "OFFLINE_MODE                          = false"                                          >> $config_file
    echo "DISABLE_ROUTER_LOG                    = false"                                          >> $config_file
    echo "[mailer]"                                                                               >> $config_file
    echo "ENABLED                               = false"                                          >> $config_file
    echo "[service]"                                                                              >> $config_file
    echo "REGISTER_EMAIL_CONFIRM                = false"                                          >> $config_file
    echo "ENABLE_NOTIFY_MAIL                    = false"                                          >> $config_file
    echo "DISABLE_REGISTRATION                  = false"                                          >> $config_file
    echo "ENABLE_CAPTCHA                        = false"                                          >> $config_file
    echo "REQUIRE_SIGNIN_VIEW                   = true"                                           >> $config_file
    echo "[picture]"                                                                              >> $config_file
    echo "DISABLE_GRAVATAR                      = true"                                           >> $config_file
    echo "ENABLE_FEDERATED_AVATAR               = false"                                          >> $config_file
    echo "AVATAR_UPLOAD_PATH                    = $base_dir/var/lib/gogs/avatar"                  >> $config_file
    echo "[session]"                                                                              >> $config_file
    echo "PROVIDER                              = file"                                           >> $config_file
    echo "PROVIDER_CONFIG                       = $base_dir/var/lib/gogs/sessions"                >> $config_file
    echo "[log]"                                                                                  >> $config_file
    echo "MODE                                  = file"                                           >> $config_file
    echo "LEVEL                                 = Info"                                           >> $config_file
    echo "ROOT_PATH                             = $base_dir/var/log/gogs"                         >> $config_file
    echo "[security]"                                                                             >> $config_file
    echo "INSTALL_LOCK                          = false"                                          >> $config_file
    echo "SECRET_KEY                            = $(openssl rand -base64 20)"                     >> $config_file
    echo "LOGIN_REMEMBER_DAYS                   = 7"                                              >> $config_file
    echo "[i18n]"                                                                                 >> $config_file
    echo "LANGS                                 = en-US,zh-CN,zh-HK"                              >> $config_file
    echo "NAMES                                 = English,简体中文,繁體中文"                      >> $config_file
    echo "[admin]"                                                                                >> $config_file
    echo "DISABLE_REGULAR_ORG_CREATION          = true"                                           >> $config_file
    echo "[attachment]"                                                                           >> $config_file
    echo "ENABLED                               = true"                                           >> $config_file
    echo "PATH                                  = $base_dir/var/lib/gogs/attachment"              >> $config_file
    echo "ALLOWED_TYPES                         = */*"                                            >> $config_file
    echo "MAX_SIZE                              = 100"                                            >> $config_file
    echo "MAX_FILES                             = 10"                                             >> $config_file
    echo "[release.attachment]"                                                                   >> $config_file
    echo "ENABLED                               = true"                                           >> $config_file
    echo "PATH                                  = $base_dir/var/lib/gogs/release"                 >> $config_file
    echo "ALLOWED_TYPES                         = */*"                                            >> $config_file
    echo "MAX_SIZE                              = 100"                                            >> $config_file
    echo "MAX_FILES                             = 10"                                             >> $config_file
    echo "[repository.upload]"                                                                    >> $config_file
    echo "ENABLED                               = true"                                           >> $config_file
    echo "TEMP_PATH                             = $base_dir/var/lib/gogs/temp"                    >> $config_file
    echo "ALLOWED_TYPES                         = "                                               >> $config_file
    echo "FILE_MAX_SIZE                         = 100"                                            >> $config_file
    echo "MAX_FILES                             = 10"                                             >> $config_file
    echo "[git]"                                                                                  >> $config_file
    echo "DISABLE_DIFF_HIGHLIGHT                = false"                                          >> $config_file
    echo "[git.timeout]"                                                                          >> $config_file
    echo "MIGRATE                               = 3600"                                           >> $config_file
    echo "MIRROR                                = 3600"                                           >> $config_file
    echo "CLONE                                 = 3600"                                           >> $config_file
    echo "PULL                                  = 3600"                                           >> $config_file
    echo "GC                                    = 3600"                                           >> $config_file
    echo "[log.file]"                                                                             >> $config_file
    echo "LOG_ROTATE                            = true"                                           >> $config_file
    echo "DAILY_ROTATE                          = true"                                           >> $config_file
    echo "MAX_SIZE_SHIFT                        = 28"                                             >> $config_file
    echo "MAX_DAYS                              = 120"                                            >> $config_file
    echo "[cache]"                                                                                >> $config_file
    echo "ADAPTER                               = memory"                                         >> $config_file
    echo "[other]"                                                                                >> $config_file
    echo "SHOW_FOOTER_BRANDING                  = false"                                          >> $config_file
    echo "SHOW_FOOTER_VERSION                   = true"                                           >> $config_file
    echo "SHOW_FOOTER_TEMPLATE_LOAD_TIME        = false"                                          >> $config_file
    chown git:git $config_file
    chmod 600 $config_file
    cd $base_dir;sudo -ugit $base_dir/usr/local/gogs/gogs web >> $base_dir/var/log/gogs/start.log 2>&1 &
    sleep 3
    curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36" -d "db_type=SQLite3&db_host=&db_user=&db_passwd=&db_name=&ssl_mode=disable&db_path=%2Fhome%2Fgit%2Fvar%2Flib%2Fgogs%2Fdata%2Fgogs.db&app_name=Gogs&repo_root_path=%2Fhome%2Fgit%2Fvar%2Flib%2Fgogs%2Fgogs-repositories&run_user=git&domain=$bind_ip&ssh_port=22&http_port=3000&app_url=http%3A%2F%2F$bind_ip%3A3000%2F&log_root_path=%2Fhome%2Fgit%2Fvar%2Flog%2Fgogs&smtp_host=&smtp_from=&smtp_user=&smtp_passwd=&disable_gravatar=on&require_sign_in_view=on&admin_name=&admin_passwd=&admin_confirm_passwd=&admin_email=" http://$bind_ip:3000/install
}

case $1 in
    init)
        init "$2" "$3"
    ;;
esac
