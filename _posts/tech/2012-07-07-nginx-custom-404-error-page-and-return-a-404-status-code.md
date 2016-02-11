---
layout: post
title: Nginx自定义404错误页面并返回404状态码
date: 2012-07-07 10:35:18
category: 技术
tags: nginx 404
---


**什么是404页面** 

如果碰巧网站出了问题，或者用户试图访问一个并不存在的页面时，此时服务器会返回代码为404的错误信息，此时对应页面就是404页面。404页面的默认内容和具体的服务器有关。  如果后台用的是NGINX服务器，那么404页面的内容则为： 

	404 Not Found 

	nginx/0.8.6

**为什么要自定义404页面** 

在访问时遇到上面这样的404错误页面，我想99%（未经调查，估计数据）的用户会把页面关掉，用户就这样悄悄的流失了。如果此时能有一个漂亮的页面能够引导用户去他想去的地方必然可以留住用户。因此，每一个网站都应该自定义自己的404页面。

**NGINX下如何自定义404页面** 

APACHE下自定义404页面的经验介绍文章已经非常多了，NGINX的目前还比较少，凑巧我的几台服务器都是NGINX的，为了解决自家的问题特地对此作了深入的研究。研究结果表明，NGINX下配置自定义的404页面是可行的，而且很简单，只需如下几步： 

**1.** 创建自己的404.html页面   
**2.** 更改nginx.conf在http定义区域加入： 

	fastcgi_intercept_errors on;   
	
**3.** 更改nginx.conf在server 区域加入： 

	error_page 404 = /404.html //错误做法，返回的状态码是200 error_page 404 /404.html //正确做法，返回状态码是404   
	
**4.** 测试nginx.conf正确性： 
	
	/opt/nginx/sbin/nginx –t 
	如果正确应该显示如下信息： 
	the configuration file /opt/nginx/conf/nginx.conf syntax is ok configuration file /opt/nginx/conf/nginx.conf test is successful 
	平滑重启nginx /opt/nginx/sbin/nginx –s reload 

**配置文件实例：** 

```
…… http { 

	include       mime.types; 
	default_type  application/octet-stream; charset  utf-8; 	server_names_hash_bucket_size 128; 
	client_header_buffer_size 32k; 
	large_client_header_buffers 4 32k; 
	client_max_body_size 8m; 
	sendfile on; 
	tcp_nopush     on; 
	keepalive_timeout 60; 
	tcp_nodelay on; 
	fastcgi_connect_timeout 300; 
	fastcgi_send_timeout 300; 
	fastcgi_read_timeout 300; 
	fastcgi_buffer_size 64k; 
	fastcgi_buffers 4 64k; 
	fastcgi_busy_buffers_size 128k; 
	fastcgi_temp_file_write_size 128k; 
	fastcgi_intercept_errors on; 
	
	gzip on; 
	gzip_min_length  1k; 
	gzip_buffers     4 16k; 
	gzip_http_version 1.0; 
	gzip_comp_level 2; 
	gzip_types       
	
	text/plain application/x-javascript text/css application/xml; 
	gzip_vary on; 
	
	#limit_zone  
	crawler  $binary_remote_addr  10m; 
	#配置信息 
	server { 
		listen       80; 
		server_name  
		www.lnmp100.com; 
		index index.html index.htm index.php; 
		root  /opt/www/lnmp100.com; 
		location ~ .*\\.(php|php5)?$ { 
			#fastcgi_pass  
			unix:/tmp/php-cgi.sock; 
			fastcgi_pass  127.0.0.1:9000; 
			fastcgi_index index.php; 
			include fcgi.conf; 
		} 
		
		error_page  404  /404.html; 
		#502 等错误可以用同样的方法来配置。 
		error_page   500 502 503 504  /50x.html; 
		
		location  /50x.html { 
			root   html; 
		} 
		
		log_format  lnmp100  ‘$remote_addr – $remote_user [$time_local] "$request" ‘ ‘$status $body_bytes_sent "$http_referer" ‘ 		‘"$http_user_agent" $http_x_forwarded_for’; 
		access_log  /opt/nginx/logs/		lnmp100.log  lnmp100; 
	} 
…… 

```

**注意事项：** 

1.必须要添加：fastcgi_intercept_errors on; 如果这个选项没有设置，即使创建了404.html和配置了error_page也没有效果。   
fastcgi_intercept_errors 语法: fastcgi_intercept_errors on|off 默认: fastcgi_intercept_errors off 添加位置: http, server, location 默认情况下，nginx不支持自定义404错误页面，只有这个指令被设置为on，nginx才支持将404错误重定向。这里需要注意的是，并不是说设置了fastcgi_intercept_errors on，nginx就会将404错误重定向。在nginx中404错误重定向生效的前提是设置了fastcgi_intercept_errors on,并且正确的设置了error_page这个选项（包括语法和对应的404页面)   

2.不要出于省事或者提高首页权重的目的将首页指定为404错误页面，也不要用其它方法跳转到首页。   
3.自定义的404页面必须大于512字节，否则可能会出现IE默认的404页面。例如，假设自定义了404.html,大小只有11个字节（内容为：404错误）。
