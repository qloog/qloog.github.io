---
layout: post
title: nginx+php 502 bad gateway解决方法
date: 2012-03-13 16:38:46
category: 技术
tags: nginx 502
---



今天突然碰到了 nginx+php 502 bad gateway 的错误显示，还以为是nginx的问题，原因基本是：  
php-cgi进程数不够用、php执行时间长、或者是php-cgi进程死掉，都会出现502错误 。  

参考了下网上的资料，修改方法如下： 

	vim /usr/local/webserver/php/etc/php-fpm.conf <value name="request_terminate_timeout">0s</value> 
	
将0s未改5s 修改后重启`php-fpm /usr/local/webserver/php/sbin/php-fpm reload` 问题解决。  

参考阅读： 

   * <http://blog.s135.com/post/361/>     
   * <http://hi.baidu.com/pibuchou/blog/item/5cd413151a0eaf15972b4388.html>