---
layout: post
title: Can't connect to MySQL server 问题的处理方法
date: 2012-03-12 14:09:39
category: 技术
tags: MySQL
---


上午来公司刚坐没多久，同事反馈测试机无法访问。既然问题来了，那咱就的解决。  


 1. 打开CI框架的调试功能，浏览器访问，发现提示：Unable to connect to your database server using the provided settings. 到此并不知道是什么问题。  
  
 2. 在Mysql的命令行下进行连接操作： /usr/local/webserver/mysql/bin/mysql -hlocalhost -uroot -proot 提示如下：Can't connect to local MySQL server through socket "/tmp/mysql.sock(2)    
  
 3. 通过ps aux|grep mysql 查看mysql进程是否在运行，结果也是有的： 
    
    
		root 1465 0.0 0.0 108352 1636 ? S 20:40 0:00 /bin/sh /usr/local/webserver/mysql/bin/mysqld_safe --defaults-file=/data0/mysql/3306/my.cnf

		mysql 2341 0.5 1.7 1628628 136364 ? Sl 20:40 0:00 /usr/local/webserver/mysql/libexec/mysqld --defaults-file=/data0/mysql/3306/my.cnf --basedir=/usr/local/webserver/mysql --datadir=/data0/mysql/3306/data --plugin-dir=/usr/local/webserver/mysql/lib/mysql/

		plugin --user=mysql --log-error=/data0/mysql/3306/mysql_error.log --open-files-limit=10240 --pid-file=/data0/mysql/3306、mysql.pid --so

		cket=/tmp/mysql.sock --port=3306

		root 2397 0.0 0.0 103292 888 pts/0 S+ 20:43 0:00 grep mysql

	说明mysql 是在运行。   

 4. find / -name mysql.sock 查找mysql.sock 文件也没有，奇怪了，咋回事?   
 5. 那就让我们来看下mysql_error日志文件会有什么提示吧:  
   
		tail -f /data0/mysql/3306/mysql_error.log
	   
		InnoDB: buffer...
	   
		InnoDB: Last MySQL binlog file position 0 855928331, file name /data0/mysql/3306/binlog/binlog.000002
	   
		120312 20:45:21 InnoDB Plugin 1.0.6 started; log sequence number 58372397
	   
		120312 20:45:21 [Note] Recovering after a crash using /data0/mysql/3306/binlog/binlog
	   
		120312 20:45:21 [ERROR] Error in Log_event::read_log_event(): 'read error', data_len: 140, event_type: 2
	   
		120312 20:45:21 [Note] Starting crash recovery...
	   
		120312 20:45:21 [Note] Crash recovery finished.
	   
		/usr/local/webserver/mysql/libexec/mysqld: Disk is full writing '/data0/mysql/3306/binlog/binlog.~rec~' (Errcode: 28). Waiting for someone to free space... (Expect up to 60 secs delay for server to continue after freeing disk space)
	   
		/usr/local/webserver/mysql/libexec/mysqld: Retry in 60 secs. Message reprinted in 600 secs

	从Disk is full writing 部分来看，应该是/data0/mysql/3306/binlog/里的文件写满所致（其实是/分区已满），那我们来看看binlog里的文件到底有多大： 
    
    
		ll -h /data0/mysql/3306/binlog

		total 817M

		-rw-rw----. 1 mysql mysql 394 Mar 7 00:20 binlog.000001

		-rw-rw----. 1 mysql mysql 817M Mar 9 19:16 binlog.000002

		-rw-rw----. 1 mysql mysql 78 Mar 7 17:46 binlog.index

		-rw-rw----. 1 mysql mysql 0 Mar 12 21:07 binlog.~rec~

	817M 还确实不小。满了那我们就做下删除操作或者关掉日志。  

	下面给出两种方法：  

      * 手动删除（计划任务） #关闭mysql /data0/mysql/3306/mysql stop rm -rf /data0/mysql/3306/binlog/binlog.00* #开启mysql /data0/mysql/3306/mysql start 
  	  * 在my.cnf里关闭Log日志 vim /data0/mysql/3306/my.cnf 找到log-bin = /data0/mysql/3306/binlog/binlog 前加# 即可。 重启mysql /data0/mysql/3306/mysql restart   
  	    
 
 6. 这下可以刷新页面来访问了。  
 
 	log-bin说明（转来的）：  
  	 * mysql5运行一段时间，在mysql/data目录下出现一堆类似mysql-bin.000***的文件，从mysql-bin.000001开始一直排列下来，有的占用了大量硬盘空间，高达上百兆。这些文件是MySQL的事务日志log-bin。  
   	 * 删除复制服务器已经拿走的binlog是安全的，一般来说网络状况好的时候，保留最新一个足矣(缺点是将无法使数据库恢复先前的状态)。  
   	 * logbin主要是用来做回滚和增量备份的。还可以在my.ini里把log-bin注释掉，就不产生日志文件了。(mysql-bin 就是我这里的binlog.*)   
 
参考阅读
 
  *  <http://hi.baidu.com/jiaodj/blog/item/694fd523456e5b4eac34de33.html>