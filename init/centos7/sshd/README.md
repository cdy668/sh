# sshd
## Port
    定义sshd服务的端口号，默认为22
## SyslogFacility
    定义sshd服务的日志存储位置，默认为local1

    同时需要rsyslog.conf做出调整
    1、追加内容到/etc/rsyslog.conf
        # Save sshd messages also to sshd.log
        local1.*                                                /var/log/sshd.log
    2、追加内容到/etc/logrotate.d/syslog
        /var/log/sshd.log
    3、重启sshd、rsyslog
        systemctl restart sshd rsyslog && systemctl status sshd rsyslog
## LogLevel
    定义sshd服务的日志级别，默认为INFO
## LoginGraceTime
    定义sshd服务的登录过程的超时时间，单位可以是s（秒），也可以是m（分钟）
    默认为30s，超过这个时间，服务器会断开当前建立的连接
## PermitRootLogin
    定义系统root用户是否可以远程登录sshd服务，默认为yes，推荐设置为no
## StrictModes
    定义sshd服务在接收登录请求之前是否检查用户主目录和rhosts文件的权限和所有权，默认为yes
## MaxAuthTries
    定义sshd服务的尝试登录次数，默认为2
    第一次尝试登录失败，还可以进行第二次尝试登录，如果第二次尝试登录失败，会直接被sshd服务拒绝登录
    可以遏制hydra等暴力破解工具对sshd服务的恶意攻击
## MaxSessions
    定义sshd服务可以接受来自同一个IP地址的最大连接数，默认为10
## PubkeyAuthentication
    定义sshd服务是否允许使用公钥认证，默认为yes
    可以同时保持sshd服务的密码认证，二者不会冲突
    推荐使用公钥认证方式登录的时候，关闭掉密码认证方式，可以遏制hydra等暴力破解工具对sshd服务的恶意攻击
    私钥绝对不能被泄露，否则只能更新密钥对
## PermitEmptyPasswords
    定义sshd服务是否允许使用空密码，默认为no
## PasswordAuthentication
    定义sshd服务是否允许使用密码认证，默认为yes
    如果一定要开启密码认证，建议配合谷歌身份验证器（google-authenticator）来完成二次身份认证，可以防止其他人仅凭密码就可以登录系统
## Subsystem	sftp	/usr/libexec/openssh/sftp-server
    定义sshd服务是否开启sftp-server功能，该配置默认被注释
    # Subsystem	sftp	/usr/libexec/openssh/sftp-server

