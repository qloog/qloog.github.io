---
layout: post
title: expect安装和使用需要注意的几个问题
category: 技术
date: 2011-12-15 16:47:30
tags: expect
---


从远程服务器拷贝数据文件到指定的服务器上，估计是需要同学都遇到过的问题。
scp 和rsync 都可以实现，rsync俺还没玩过，不过应该也比较简单吧。
如果用scp来实现自动拷贝文件，但是需要用户来输入的密码，否则无法实现，怎么办？
听说expect可以解决这个问题。

1。首先确认expect的包是否安装。

	[root@lamp100 opt]$ rpm -qa | grep expect
	
如果没有则需要下载安装，可以参考：
编译安装：<http://www.lnmp100.com/note/expect-download-and-install.html>
rpm安装：expect-5.42.1-1.x86_64.rpm 和 expect-devel-5.42.1-1.x86_64.rpm 这个安装相对简单些
rpm下载地址：
<http://mirrors.163.com/centos/5/os/i386/CentOS/>
<http://mirrors.163.com/centos/5/os/x86_64/CentOS/>

安装过后会显示：

	[root@lamp100 opt]$ rpm -qa | grep expect
	expect-5.43.0-5.1
	expect-devel-5.42.1-1
	
2.查看expect的路径，可以用

	[root@lamp100 opt]$ which expect
	/usr/bin/expect
	[root@lamp100 opt]$ vim auto_cp_data.sh
	
3。确定脚本有可执行权限

	chmod +x auto_cp_data.sh
    
    
    #!/usr/bin/expect  //这个expect的路径就是用which expect 查看的结果
    
    set date [exec date "+%y_%m_%d"]
    
    spawn scp root@10.3.32.57:/opt/htdocs/search_data/"$date"_raw_food.xml /opt/sourcedata/
    
    expect "password:"  //匹配password
    
    send "123456\r" //发送密码
    
    interact  //执行完毕

另外需要注意的是：
不能按照习惯来用`sh auto_cp_data.sh`来这行expect的程序，会提示找不到命令，如下：

	auto_cp_data.sh: line 3: spawn: command not found
	couldn’t read file “password:”: no such file or directory
	auto_cp_data.sh: line 5: send: command not found
	auto_cp_data.sh: line 6: interact: command not found

因为expect用的不是bash所以会报错。执行的时候直接`./auto_cp_data.sh`就可以了。～切记！
 
参考链接：<http://blog.csdn.net/zhuying_linux/article/details/6657020>