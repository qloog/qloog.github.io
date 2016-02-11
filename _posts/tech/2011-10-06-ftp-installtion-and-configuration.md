---
layout: post
title: VPS服务器FTP安装与配置
date: 2011-10-06 21:15:28
category: 技术
tags: VPS FTP
---


VPS要自己安装ftp服务器，让我们一起来配置ftp，方便自己上载和下载文件。

## 1.安装vsftpd，使用下面的命令：

	yum install vsftpd
	
## 2.启动/重启/关闭vsftpd服务器  

	[root@localhost ftp]#/sbin/service vsftpd restart
	Shutting down vsftpd:OK
	Starting vsftpd for vsftpd: OK
	
看见OK就表示重启成功.  
启动和关闭分别把restart改为start或stop即可.  
如果是源码安装的,到安装文件夹下找到start.sh和shutdown.sh文件,执行它们就可以了.  

## 3.与vsftpd服务器有关的文件和文件夹  
vsftpd服务器的配置文件的是: `/etc/vsftpd/vsftpd.conf`  
vsftpd服务器的根目录,即FTP服务器的主目录: 
 
	[root@localhost ftp]# more /etc/passwd|grep ftp  
	ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin  
		
这样你就能看到FTP的服务器的目录在/var/ftp处  
如果你想修改服务器目录的路径,那么你只要修改/var/ftp到别处就行了

## 5.添加FTP本地用户  
有的FTP服务器需要用户名和密码才能登录,就是因为设置了FTP用户和权限.  
FTP用户一般是不能登录系统的,只能进入FTP服务器自己的目录中,这是基于安全原因.只能在ftp中指定的目录上载和下载,不能登录SHELL,更不可能登录系统。  

	/usr/sbin/adduser -d /opt/ftp -g ftp -s /sbin/nologin ftpuser
这个命令的意思是:  
使用命令(adduser)添加ftpuser用户,不能登录系统(-s /sbin/nologin),自己的文件夹在(-d /opt/ftp)),属于组ftp(-g ftp)
然后你需要为它设置密码`passwd ftp`  
这样就添加了一个FTP用户了.下面的示例可以帮助你进入FTP服务器了.  
要保证自己能读写自己的目录,就要在配置文件vsftpd.conf里设置一下就可以读写了.
  
	local_enable=yes
	write_enable=yes
	local_umask=022

## 5.匿名上传下载
修改配置文件即可vsftpd.conf,确定有以下几行,没有自己添加进去就可以了.

	anonymous_enable=yes
	anon_upload_enable=yes
	anon_mkdir_write_enable=yes
	anon_umask=022
然后你可以新建一个文件夹,修改它的权限为完全开放,任何用户就可以登录这个文件夹,并上传下载文件:
mkdir /var/ftp/guest
chmod 777 /var/ftp/guest
## 6.定制进入FTP服务器的欢迎信息
在vsftpd.conf文件中设置:
dirmessage_enable=yes
然后进入用户目录建立一个.message文件,输入欢迎信息即可。

## 7.实现虚拟路径
将某个目录挂载到FTP服务器下供用户使用,这就叫做虚拟路径.  
比如将gxl用户的目录挂载到FTP服务器中,供FTP服务器的用户使用,使用如下命令即可:

	[root@localhost opt]# mount –bind /home/gxl /var/ftp/pub #使用挂载命令
	[root@localhost opt]# ls /var/ftp/pub
LumaQQ Screenshot.png 桌面

## 8.打开vsFTPd的日志功能
添加下面一行到vsftpd.conf文件中,一般情况下该文件中有这一行,只要把前面的注释符号#去掉即可,没有的话就添加,或者修改:

	xferlog_file=/var/log/vsftpd.log

## 9.限制链接数,以及每个IP最大的链接数
修改配置文件中,例如vsftp最大支持链接数100个,每个IP能支持5个链接:

	max_client=100
	max_per=5
	
## 10.限制传输速度
修改配置文件中,例如让匿名用户和vsftd上的用户(即虚拟用户)都以80KB=1024*80=81920的速度下载
anon_max_rate=81920
local_max_rate=81920

## 11.将用户(一般指虚拟用户)限制在自家目录
修改配置文件中,这样用户就只能访问自己家的目录了:

	chroot_local_user=yes
如果只想某些用户仅能访问自己的目录,其它用户不做这个限制,那么就需要在chroot_list文件(此文件一般是在/etc/vsftpd/中)中添加此用户.  
编辑此文件,比如将test用户添加到此文件中,那么将其写入即可.一般的话,一个用户占一行.

	[root@localhost vsftpd]# cat chroot_list
	ftpuser

## 12.绑定某个IP到vsFTPd
有时候要限制某些IP访问服务器,只允许某些IP访问,例如只允许192.38.1.43访问这个FTP,同样修改配置文件:

	listen_address=192.38.1.43
配置好ftp后，你就可以通过你的本机登录到ftp服务器，管理你的文件。