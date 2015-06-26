---
layout: post
title: vps配置笔记
category: note
tags: VPS
---



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

 6. 最土团购系统伪静态规则

最土团apache伪静态规则

	RewriteCond %{QUERY_STRING} ^(.*)$
	RewriteRule ^(\w+)/(deals|seconds|goods|partners)$ rewrite.php
	RewriteRule ^(team|partner)/(\d+).html$ rewrite.php
	RewriteRule ^(\w+)$ rewrite.php

最土团iis伪静态规则

	[ISAPI_Rewrite]
	RewriteRule (.*)/([a-zA-Z]+)/(deals|seconds|goods|partners)$ $1/rewrite.php
	RewriteRule (.*)/(team|partner)/([0-9]+)\.html$ $1/rewrite.php
	RewriteRule (.*)/([a-zA-Z]+)$ /rewrite.php

最土团nginx伪静态规则

	rewrite ^([^\.]*)/(\w+)/(deals|seconds|goods|partners)$ $1/rewrite.php last;
	rewrite ^([^\.]*)/(team|partner)/(\d+).html$ $1/rewrite.php last;
	rewrite ^([^\.]*)/([\/\w]*[\w])$ $1/rewrite.php last;
