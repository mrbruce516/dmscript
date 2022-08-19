#!/bin/bash

# 依赖：gzip
# 获取需要备份的文件
day=`date +%Y%m%d`
file=od_cloudperformancehistory`date +%Y%m%d --date="-1 day"`
# 备份目录,若目录不存在需要先创建
dir="/home/dmdbms/data/DAMENG/bak/perf"
# 数据库信息
user="SYSDBA"
pwd="SYSDBA"
dmbin="此处填写达梦绝对路径"
server="此处填写达梦主机ip:port"

# 备份操作
backup(){
    cd $dmbin
    ./dexp USERID=$user/$pwd@$server FILE=$file.dmp DIRECTORY=$dir LOG=$file.log TABLES=$file
    if [ $? -eq 0 ]
    then
        echo "----- $file 文件备份完毕 -----" >> /root/backup.log
    else
        echo "----- $file 文件备份失败,请检查原因 -----" >> /root/backup.log
        exit 1
    fi
    # 压缩操作
    cd $dir
    gzip $file
    if [ $? -eq 0 ]
    then
        echo "----- $file 文件压缩完毕 -----" >> /root/backup.log
    else
        echo "----- $file 文件压缩失败,请检查原因 -----" >> /root/backup.log
    fi
}

echo "-----`date` 开始执行性能天表备份任务 -----"
backup
echo "-----`date` 性能天表备份任务执行完毕 -----"
