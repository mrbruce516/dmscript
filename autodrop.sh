#!/bin/bash
# 自动删除备份文件脚本
# 数据库备份保留90天，性能数据备份保留180天

# 备份文件路径
all="/home/dmdbms/data/DAMENG/bak/bak"
up="/home/dmdbms/data/DAMENG/bak/zengbei"
perf="/home/dmdbms/data/DAMENG/bak/perf"

# 删除备份
delbak(){
    file=`ls *$(date +%Y_%m_%d --date="-$1 day")*.bak 2>&1`
    if [ -f "$file" ]
    then
        echo "备份文件存在,名称为$file"
        rm -f $file
        if [ $? -eq 0 ]
        then
            echo "已删除$file" >> /root/autodrop.log
        fi
    else
        echo "`date +%Y_%m_%d --date="-$1 day"` 的备份不存在"
    fi
}

delperf(){
    pfile=`ls *$(date +%Y%m%d --date="-$1 day")*.dmp.gz 2>&1`
    if [ -f "$pfile" ]
    then
        echo "备份文件存在,名称为$pfile"
        rm -f $pfile
        if [ $? -eq 0 ]
        then
            echo "已删除$pfile" >> /root/autodrop.log
        fi
    else
        echo "`date +%Y%m%d --date="-$1 day"` 的备份不存在"
    fi
}

main(){
    # 删除数据库90天前的全备
    cd $all
    delbak 91
    # 删除90天前的增量备份
    cd $up
    delbak 91
    # 删除180天前的性能数据备份
    cd $perf
    delperf 181
}

main
