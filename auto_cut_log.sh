#!/bin/bash

# 日志分隔，以天维度分隔，由crontab来启动此命令
# 支持多个配置，在wait_cut_log中配置
#  |- 其中路径中的%s，会被替换成昨天的日期
#  |- 原始路径,目标路径 “注：中间逗号分隔即可”
log_path=(
        '/tmp/test.log,/data/log/cli/test_%s.log'
        '/tmp/test1.log,/data/log/cli/test1_%s.log'
)

last_day=`date -d last-day +%Y%m%d`

# 开始循环
for item in ${log_path[@]}
do
        item=${item//,/ }
        key=0
        source_path=''
        target_path=''
        for i in $item;
        do
                if [ $key -eq 0 ]
                then
                        source_path=$i
                elif [ $key -eq 1 ]
                then
                        target_path=$i
                fi
                key=`expr $key + 1`
        done

        # 验证原始路径的文件是否存在
        if [ ! -f "$source_path" ]
        then
                continue
        fi

        # 验证目标路径的目录文件是否存在
        target_path_dir=${target_path%/*}
        if [ ! -x "$target_path_dir" ]
        then
                mkdir -p "$target_path_dir"
        fi

        target_path=${target_path/\%s/"$last_day"}
        mv $source_path $target_path
        echo -e "[success] $source_path to $target_path"
done
