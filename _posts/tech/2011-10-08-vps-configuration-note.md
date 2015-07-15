---
layout: post
title: vps配置笔记
category: 技术
tags: VPS
---


## 基本配置

 1. 更改系统时间为北京时间：

		cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

 2. 修改系统默认编码（设置 loacle 为中文环境）
	方法一：

		LANG=zh_CN.utf8
		LANGUAGE=zh_CN:en
		LC_CTYPE=”zh_CN.utf8″
		LC_NUMERIC=”zh_CN.utf8″
		LC_TIME=”zh_CN.utf8″
		LC_COLLATE=”zh_CN.utf8″
		LC_MONETARY=”zh_CN.utf8″
		LC_MESSAGES=”zh_CN.utf8″
		LC_PAPER=”zh_CN.utf8″
		LC_NAME=”zh_CN.utf8″
		LC_ADDRESS=”zh_CN.utf8″
		LC_TELEPHONE=”zh_CN.utf8″
		LC_MEASUREMENT=”zh_CN.utf8″
		LC_IDENTIFICATION=”zh_CN.utf8″
		LC_ALL=

	方法二：
	
		vim /etc/sysconfig/i18n
		加入：LANG=”zh_CN.UTF-8″

 3. 安装VIM编辑器
	安装：

		yum -y install vim*

	会提示安装四个软件包：

		vim-common.i386                          2:7.0.109-6.el5              base
		vim-enhanced.i386                        2:7.0.109-6.el5               base
		vim-minimal.i386                         2:7.0.109-6.el5               installed
		vim-X11.i386                            2:7.0.109-6.el5               base

 4. 安装计划任务 crontab

		yum install vixie-cron crontabs //安装Crontab
		chkconfig crond on //设为开机自启动
		service crond start //启动

 5. 查看linux版本方法：

		  cat /proc/version
		  uname -a
		  cat /etc/issue
		  
		  
		  
## 问题汇总

  1. 刚登录时如果一下提示:  
  
		Last login: Tue Jul 14 22:13:13 2015 from 114.111.167.156
		
		Welcome to aliyun Elastic Compute Service!
		
		-bash: warning: setlocale: LC_CTYPE: cannot change locale (UTF-8): No such file or directory
		
	解决方法是：
	
	添加`LC_CTYPE="en_US.UTF-8"` 到 `/etc/sysconfig/i18n` 文件中， 重新登录问题解决。			  
		  
 		  

 