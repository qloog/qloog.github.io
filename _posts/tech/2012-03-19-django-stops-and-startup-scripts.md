---
layout: post
title: django停止与启动脚本分享
category: 技术
date: 2012-03-19 22:22:31
tags: Django Pyton
---


刚装好django之后，修改完project里的urls.py或setting之后，总要重启fcgi来重新加载其配置，需要以下三步才可以完成：

  1. ps aux|grep python 找到相应的进程号
  2. kill –9 进程号
  3. python manage.py runfcgi method=threaded host=127.0.0.1 port=8080 pidfile=django.pid

　　很明显，如果配置经常改动的话这也太麻烦了，所以将其整理为一个脚本来管理，方便操作。

`vim manage_django.sh`脚本,加入以下内容：
 

> #!/bin/bash
> 
> PROJDIR="/home/pylabs"  
PIDFILE="$PROJDIR/django.pid"
> 
> cd $PROJDIR
> 
> func_kill_py(){  
    if [ -f $PIDFILE ]; then  
        kill `cat $PIDFILE`  
        rm -f $PIDFILE  
    fi  
}
> 
> if [ "$1" = "stop" ]; then  
    printf "Stop django...\n";  
    func_kill_py  
elif [ "$1" = "start" ] || [ "$1" = "restart" ]; then  
    printf "Start django...\n";  
    func_kill_py;  
    exec python manage.py runfcgi method=threaded host=127.0.0.1 port=8080 pidfile=$PIDFILE  
fi

保存后退出： wq

修改文件使其有可执行权限：

chmod +x manage_django.sh

这样就可以stop 和 start django了。

> ./manage_django.sh stop
> 
> ./manage_django.sh start
