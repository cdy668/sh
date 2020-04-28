# logrotate
## rotate
    保留日志文件的数量(日志轮转次数),如果为0,代表没有备份
## daily,weekly,monthly
    daily,每天轮转一次日志
    weekly,每周轮转一次日志
    monthly,每月轮转一次日志
## missingok
    日志出现丢失后,不报错,继续轮转下一个日志
## notifempty
    当日志文件为空时,不进行轮转
## compress
    通过gzip压缩轮转后的日志
## delaycompress
    和compress一起使用时,日志到了下一次轮转时才压缩
## sharedscripts
    运行postrotate脚本,作用是在所有日志都轮转后统一执行一次脚本.如果没有配置这个,那么每个日志轮转后都会执行一次脚本
## postrotate
    在logrotate转储之后需要执行的指令,例如重新启动 (kill -HUP) 某个服务,必须独立成行
## nocompress
    不做gzip压缩处理
## copytruncate
    用于还在打开中的日志文件,把当前日志备份并截断;
    是先拷贝再清空的方式,拷贝和清空之间有一个时间差,可能会丢失部分日志数据
## nocopytruncate
    备份日志文件不过不截断
## create
    轮转时指定创建新文件的属性,如create 0777 nobody nobody
## nocreat
    不建立新的日志文件
## nodelaycompress
    覆盖delaycompress选项,转储同时压缩
## errors
    专储时的错误信息发送到指定的Email地址
##  ifempty
    即使日志文件为空文件也做轮转,这个是logrotate的缺省选项
## mail
    把转储的日志文件发送到指定的E-mail地址
## nomail
    转储时不发送日志文件
## olddir
    转储后的日志文件放入指定的目录,必须和当前日志文件在同一个文件系统
##  noolddir
    转储后的日志文件和当前日志文件放在同一个目录下
## prerotate
    在logrotate转储之前需要执行的指令,例如修改文件的属性等动作,必须独立成行
## dateext
    使用当期日期作为命名格式
## dateformat .%s
    配合dateext使用,紧跟在下一行出现,定义文件切割后的文件名,必须配合dateext使用,只支持 %Y %m %d %s 这四个参数
## size,minsize,log-size
    当日志文件到达指定的大小时才转储
    
    log-size能指定bytes(缺省)及KB(sizek)或MB(sizem)
        当日志文件 >= log-size 的时候就转储,以下为合法格式:(其他格式的单位大小写没有试过)

    size = 5 或 size 5 （>= 5 个字节就转储）
    size = 100k 或 size 100k
    size = 100M 或 size 100M