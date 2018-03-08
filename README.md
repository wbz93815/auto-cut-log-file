# auto-cut-log-file
通过Crontab，每日定时切割日志文件

如：每日零点执行
0 0 * * * /bin/bash /data/crontab/auto_cut_log.sh >> /dev/null 2>&1
