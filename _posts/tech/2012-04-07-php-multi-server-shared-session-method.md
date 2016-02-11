---
layout: post
title: PHP中多服务器共享SESSION的方法
date: 2012-04-07 21:25:57
category: 技术
tags: PHP SESSION
---


1. 通过NFS文件共享的方式，多台WEB服务器共享保存session文件的磁盘,参考：[PHP实现多服务器session共享之NFS共享](http://imysql.cn/?q=node/202) 
2. 保存在数据库中，这种方式的扩展性很强，可以随意增加WEB而不受影响 
3. 可以将session数据保存在memcached中，memcached是基于内存存储数据的，性能很高，用户并发量很大的时候尤其合适，参考：[PHP实现多服务器session共享之memcache共享](http://imysql.cn/?q=node/215) 
4. 文件方式保存session时，可以采用php的扩展eaccelerator来存储sesion,参考：[eaccelerator 应用之“使用共享内存存储Session”](http://www.linuxbyte.org/shared-session-eaccelerator.html)   参

## 参考链接
<http://iamcaihuafeng.blog.sohu.com/100036807.html> <http://imysql.cn/?q=node/215> <http://www.linuxbyte.org/shared-session-eaccelerator.html>
