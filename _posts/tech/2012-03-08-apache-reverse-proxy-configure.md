
---
layout: post
title: "CentOS下Apache反向代理的配置"
date: 2012-03-08 14:22:01
category: 技术
tags: Apache CentOS
---


最近要弄个Aapche反向代理，来让子频道访问另外一台机器上的数据，现整理如下。   1、环境 操作系统：CentOS 5.4 WEB Server: Apache2.2  2、必须安装的apache模块 
    
    
    LoadModule proxy_module modules/mod_proxy.so
    LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
    LoadModule proxy_http_module modules/mod_proxy_http.so
    LoadModule proxy_connect_module modules/mod_proxy_connect.so

如果没有该模块，那就需要安装下啦。   3、配置方向代理 编辑apache的配置文件 httpd.conf，或相关的vhost.conf,加入如下代码 
    
    
    <VirtualHost *:80>
    ServerName lab.lamp100.com
    
    ProxyRequests Off (说明开启的是反向代理)
    ProxyPass / http://www.lamplab.com/
    ProxyPassReverse / http://www.lamplab.com/
    </VirtualHost>

重启apache  /etc/init.d/apache2 restart 这样我的lab.lamp100.com在实际访问的时候就是访问的www.lamplab.com 这台服务器了。   
以上就是最简单的通过apache模块访问其他机器的方法。   
其他详细配置可以参见官方文档： <http://httpd.apache.org/docs/2.2/mod/mod_proxy.html>