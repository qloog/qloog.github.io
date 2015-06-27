---
layout: post
title: "-bash: wget: command not found的两种解决方法"
date: 2012-03-06 14:56:59
category: 技术
tags: wget bash
---


 -bash: wget: command not found的两种解决方法

今天给服务器安装新LNMP环境时，wget 时提示 -bash:wget command not found,很明显没有安装wget软件包。  
一般linux最小化安装时，wget不会默认被安装。  

可以通过以下两种方法来安装：
  
1、rpm 安装 
rpm 下载源地址：<http://mirrors.163.com/centos/6.2/os/x86_64/Packages/>   
下载wget的RPM包：http://mirrors.163.com/centos/6.2/os/x86_64/Packages/wget-1.12-1.4.el6.x86_64.rpm rpm ivh wget-1.12-1.4.el6.x86_64.rpm 安装即可。   
如果客户端用的是SecureCRT,linux下没装rzsz 包时，rz无法上传文件怎么办？我想到的是安装另一个SSH客户端：SSH Secure Shell。  
然后传到服务器上安装，这个比较费劲，所以推荐用第二种方法，不过如果yum包也没有安装的话，那就只能用这种方法了。   

2、yum安装 yum -y install wget 显然第二种方法比较简单快捷。