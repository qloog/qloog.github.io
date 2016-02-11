---
layout: post
title: MongoDB介绍及在Linux的安装
date: 2011-10-14 16:38:28
category: 技术
tags: MongoDB
---

## 一、前言

最近开始学习非关系型数据库MongoDB，网上找不到比较系统的教程，很多资料都要去查阅英文网站，效率比较低下。本人不才，借着自学的机会把心得体会都记录下来，方便感兴趣的童鞋分享讨论。部分资源出自其他博客，旨将零散知识点集中到一起，如果有侵犯您的权利，请留言。大部分内容均系原创，欢迎大家转载分享，但转载的同时别忘了注明作者和原文链接哦。 

## 二、MongoDB简介

官方主页：[http://www.mongodb.org/](http://www.mongodb.org) MongoDB是一个高性能，开源，无模式的文档型数据库，是当前NoSql数据库中比较热门的一种。它在许多场景下可用于替代传统的关系型数据库或键/值存储方式。Mongo使用C++开发。Mongo的官方网站地址是：http://www.mongodb.org/，读者可以在此获得更详细的信息。 

> 小插曲：什么是NoSql？ NoSql，全称是 Not Only Sql,指的是非关系型的数据库。下一代数据库主要解决几个要点：非关系型的、分布式的、开源的、水平可扩展的。原始的目的是为了大规模web应用，这场运动开始于2009年初，通常特性应用如：模式自由、支持简易复制、简单的API、最终的一致性（非ACID）、大容量数据等。NoSQL被我们用得最多的当数key-value存储，当然还有其他的文档型的、列存储、图型数据库、xml数据库等。

**特点:** 高性能、易部署、易使用，存储数据非常方便。主要功能特性有： 

  * 面向集合存储，易存储对象类型的数据。
  * 模式自由。
  * 支持动态查询。
  * 支持完全索引，包含内部对象。
  * 支持查询。
  * 支持复制和故障恢复。
  * 使用高效的二进制数据存储，包括大型对象（如视频等）。
  * 自动处理碎片，以支持云计算层次的扩展性
  * 支持Python，PHP，Ruby，Java，C，C#，Javascript，Perl及C++语言的驱动程序，社区中也提供了对Erlang及.NET等平台的驱动程序。
  * 文件存储格式为BSON（一种JSON的扩展）。
  * 可通过网络访问。
**功能:**

  * **面向集合的存储：**适合存储对象及JSON形式的数据。
  * **动态查询：**Mongo支持丰富的查询表达式。查询指令使用JSON形式的标记，可轻易查询文档中内嵌的对象及数组。
  * **完整的索引支持：**包括文档内嵌对象及数组。Mongo的查询优化器会分析查询表达式，并生成一个高效的查询计划。
  * **查询监视：**Mongo包含一个监视工具用于分析数据库操作的性能。
  * **复制及自动故障转移：**Mongo数据库支持服务器之间的数据复制，支持主-从模式及服务器之间的相互复制。复制的主要目标是提供冗余及自动故障转移。
  * **高效的传统存储方式：**支持二进制数据及大型对象（如照片或图片）
  * **自动分片以支持云级别的伸缩性：**自动分片功能支持水平的数据库集群，可动态添加额外的机器。
**适用场合:**

  * 网站数据：Mongo非常适合实时的插入，更新与查询，并具备网站实时数据存储所需的复制及高度伸缩性。
  * 缓存：由于性能很高，Mongo也适合作为信息基础设施的缓存层。在系统重启之后，由Mongo搭建的持久化缓存层可以避免下层的数据源 过载。
  * 大尺寸，低价值的数据：使用传统的关系型数据库存储一些数据时可能会比较昂贵，在此之前，很多时候程序员往往会选择传统的文件进行存储。
  * 高伸缩性的场景：Mongo非常适合由数十或数百台服务器组成的数据库。Mongo的路线图中已经包含对MapReduce引擎的内置支持。
  * 用于对象及JSON数据的存储：Mongo的BSON数据格式非常适合文档化格式的存储及查询。
 

## 三、下载安装和配置

官网下载地址：<http://www.mongodb.org/downloads> 

### 1、下载MongoDB安装文件
    
    
    wget http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.0.0.tgz
    
    或：curl  http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.0.0.tgz
    
    tar zxvf  mongodb-linux-i686-2.0.0.tgz
    
    mv mongodb-linux-i686-2.0.0.tgz  mongodb
    
    mv mongodb  /usr/local/webserver/

### 2、创建数据目录

默认情况下，MongoDB会在/data/db/这个文件夹存放数据，这个文件夹需要自己手动创建。

通过如下方式创建： 
    
    
    adduser mongodb
    passwd mongodb
    sudo mkdir -p /data/mongodb_data/
    sudo chown `id -u` /data/mongodb_data
    chown -R mongodb:mongodb /data/mongodb_data

当然 可以 通过--dbpath 命令 指定MongoDB将数据存储到另外的目录中去。 

### 3：运行数据库

/usr/local/webserver/mongodb/bin/mongod为服务端进程

/usr/local/webserver/mongodb/bin/mongo为客户端进程

** **在控制台中：
    
    
    nohup ./usr/local/webserver/mongodb/bin/mongod &
    
    ./usr/local/webserver/mongodb/bin/mongo
    > db.foo.save( { a : 1 } )
    > db.foo.find()

或者： 启动mongodb (先建立好MongoDB 存放数据文件和日志文件的目录/data/mongodb_data和/data/mongodb_log) 
    
    
    /usr/local/webserver/mongodb/bin/mongod --dbpath=/data/mongodb_data/ --logpath=/data/mongodb_log/mongodb.log --logappend --rest &

默认端口是27017   运行结果： 

> { "_id" : ObjectId("4cd181a31415ffb41a094f43"), "a" : 1 }

以上的三个步骤就OK了！！ 这样一个简单的MongoDB数据库就可以畅通无阻得运行起来了。 或者通过URL方式也可以访问：<http://localhost:28017>   **4、加入开机启动项里** vim /etc/rc.local  加入如下代码保存即可: 
    
    
    #add mongonDB service
    /usr/local/webserver/mongodb/bin/mongod --dbpath /data/db --logpath /data/mongodb_log/mongodb.log --logappend --rest &

几个参数说明：   
\--dbpath arg : directory for datafiles   
\--logpath arg: log file to send write to instead of stdout - has to be a file, not directory   
\--logappend : append to logpath instead of over-writing   
\--rest: turn on simple rest api 注：将mongo作为系统命令使用，使其在任何目录下可用： 

> cp   /usr/local/webserver/mongodb/bin/mongo     /usr/bin/

具体使用方法为： 

> [root@nginx src]# mongo MongoDB shell version: 2.0.0 connecting to: test >

   

## 四、安装PHP扩展

### 1、下载PHP扩展程序包
PHP官方下载地址：<http://pecl.php.net/package/mongo> 或：<https://github.com/mongodb/mongo-php-driver> (推荐)  
wget http://pecl.php.net/get/mongo-1.2.0.tgz   

### 2、安装PHP扩展
    
    
    tar zxvf mongo-1.2.0.tgz
    
    cd mongo-1.2.0/
    
    /usr/local/webserver/php/bin/phpize
    
    ./configure --with-php-config=/usr/local/webserver/php/bin/php-config
    
    make
    
    make install

在PHP配置文件中加入mongo.so 

> vim /usr/local/webserver/php/etc/php.ini

找到：extension_dir 加入如下代码： 

> extension_dir = "/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20060613/"

