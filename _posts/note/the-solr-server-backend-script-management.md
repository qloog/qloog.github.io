Title: solr服务器后端脚本管理
Date: 2011-12-31 11:29:59
Tags: solr


分享一个solr后端服务器的管理脚本 源码： 
    
    
    #!/bin/sh
    
    start_time=`date`
    
    if [ $1 = 'restart' ]; then
            fuser -kv /opt/solr
            cd /opt/solr
            nohup java -jar start_solr.jar  &
            echo "solr服务重启成功"
    elif [ $1 = 'start' ]; then
            cd /opt/solr
            nohup java -jar start_solr.jar  &
            echo "solr服务启动成功"
    elif [ $1 = 'stop' ]; then
            fuser -kv /opt/solr
            echo "solr服务停止成功"
    elif [ $1 = 'add' ]; then
            d=`date +'%y_%m_%d_'`
    
            java -Dauth=username:password -jar /opt/solr/post.jar /opt/solr/sourcedata/$d"demo1.xml"
            java -Dauth=username:password -jar /opt/solr/post.jar /opt/solr/sourcedata/$d"demo2.xml"
    
            echo "重新创建索引成功"
    elif [ $1 = 'dall' ]; then
            java -Ddata=args -Dauth=username:password -jar /opt/solr/post.jar '<delete><query>*:*</query></delete>'
            echo "删除所有索引成功"
    fi
    
    end_time=`date`
    
    echo '使用时间：'
    echo $end_time-$start_time
    
    echo "\n----------------------------------------\n"
    ps aux|grep jar
    echo "\n----------------------------------------\n"

其中认证的配置在： /opt/tomcat6/conf/tomcat-users.xml 内容为: 
    
    
    <?xml version='1.0' encoding='utf-8'?>
    <tomcat-users>
      <role rolename="admin"/>
      <role rolename="solr"/>
      <user username="username" password="password" roles="solr"/>
    </tomcat-users>

运行前需确保start_solr.jar文件存在，如果不存在，使用下面命令拷贝一份过来 

> cp apache-solr-3.2.0/example/start.jar /opt/solr/start_solr.jar

可以通过计划任务crontab来定时生成索引。 
    
    
    48 02 * * * sh /opt/manage_search.sh dall >/dev/null 2>&1
    50 02 * * * sh /opt/manage_search.sh add  >/dev/null 2>&1