---
layout: post
title: MongoDB问题汇总
date: 2011-11-11 16:36:17
category: 技术
tags: MongoDB
---


1、MongoDB客户端连接服务端出现异常。 ![mongo_conn_error](http://lnmp100.b0.upaiyun.com/2011/11/mongo_conn_error.jpg)
一般是因为机器异常重启或硬关机造成的，解决方法为：
①、删除mongod.lock文件后，重新启动MongoDB即可。

	rm -rf /data/mongodb/mongod.lock (此为mongodb数据存放的路径)

②、修复mongodb

	mongod --repair --dbpath=/data/mongodb/data

2、从MongoDB获取数据 通常情况下通过如下方式获取数据：


    $this->coll = $this->mdb->username;
    $MongoCursor = $this->coll->find(array('uid' => $uid));

但是却无法获取到数据。
解决的两种方法：

①、通过PHP 方法来获


    $array =array();
    foreach ($MongoCursor as $id => $value) {
    	$array[]=$value;
    }

②、通过PHP函数获取


    iterator_to_array : Copy the iterator into an array
    官方描述：array iterator_to_array ( Traversable $iterator [, bool $use_keys = true ] )
    作用：Copy the elements of an iterator into an array

此函数的作用就是通过迭代把Mongodb里的数据放到array里
