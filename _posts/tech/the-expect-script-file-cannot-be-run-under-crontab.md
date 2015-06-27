Title: expect脚本文件在crontab下无法运行的解决方法
Date: 2011-12-15 22:45:40
Tags: expect


为了定时执行脚本，研究了下expect+crontab+scp 来实现自动化。但难免会碰到一些问题，在此记录下。也是折腾了半个下午，写了个脚本直接运行正常，在加入到crontab下始终没有反应。不多说，上代码。也希望对有同样问题的兄弟们有所帮助！  脚本内容： 
    
    
    #!/usr/expect/bin/expect
    
    set date [exec date "+%y_%m_%d"]
    
    spawn /usr/bin/scp root@10.3.32.57:/opt/htdocs/auto_app/search_data/"$date"_raw_food.xml /opt/solr/sourcedata/
    
    expect "password:"
    
    send "abc123\r"
    
    interact

直接运行正常： 

> /opt/auto_cp_raw_food_xml.sh

crontab下么有运行： 

> 46 02 * * *  /opt/auto_cp_dish_food_xml.sh  >/dev/null 2>&1

通过 以下命令查看也可以看到有运行日志： 

> tail -f /var/log/cron

日志内容： 

> Dec 15 02:46:01 localhost crond[23220]: (root) CMD ( /opt/auto_cp_dish_food_xml.sh  >/dev/null 2>&1)

  解决方法： 将 

> interact

替换为： 

> set timeout 60 expect eof exit

此时已可以正常运行 注意：脚本里的命令路径和文件路径最好都写为绝对路径，避免命令或文件找不到的问题。     

参考链接：<http://blog.csdn.net/lucianlv/article/details/6433154>