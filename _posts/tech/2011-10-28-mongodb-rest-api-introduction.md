---
layout: post
title: MongoDB REST Api介绍
date: 2011-10-28 17:25:48
category: 技术
tags: MongoDB REST
---


MongoDB默认会开启一个HTTP协议的端口提供REST的服务，这个端口是你Server端口加上1000，比如你的Server端口为27017，那么这个HTTP端口就是28017，默认的HTTP端口功能是有限的，你可以通过添加–rest参数启动更多功能。

下面是在这个端口通过其RESTFul 的API操作MongoDB数据的几个例子，来源是[MongoDB官方文档](http://www.mongodb.org/display/DOCS/Http+Interface)。

直接通过浏览器访问相应端口的HTTP服务时的页面，页面上显示了很多Server相关的信息(部分截图) ![mongo_total](//static/uploads/2011/10/mongo_total.jpg)

下面是一系列操作数据的方法：

**列出databaseName数据库中的collectionName集合下的所有数据：**

> http://127.0.0.1:28017/databaseName/collectionName/

**给上面的数据集添加一个limit参数限制返回10条**

> http://127.0.0.1:28017/databaseName/collectionName/?limit=-10

**给上面的数据加上一个skip参数设定跳过5条记录**

> http://127.0.0.1:28017/databaseName/collectionName/?skip=5

**同时加上limit限制和skip限制**

> http://127.0.0.1:28017/databaseName/collectionName/?skip=5&limit;=10

**按条件{a:1}进行结果筛选（在关键字filter后面接上你的字段名）**

> http://127.0.0.1:28017/databaseName/collectionName/?filter_a=1

**加条件的同时再加上limit限制返回条数**

> http://127.0.0.1:28017/databaseName/collectionName/?filter_a=1&limit;=-10

**执行任意命令 如果你要执行特定的命令，可以通过在admin.$cmd上面执行find命令，同样的你也可以在REST API里实现，如下，执行{listDatabase:1}命令：**

> http://localhost:28017/admin/$cmd/?filter_listDatabases=1&limit;=1
