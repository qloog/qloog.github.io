---
layout: post
title: MongoDB模糊查询(PHP版)
date: 2012-03-09 17:22:03
category: 技术
tags: MongoDB
---


MongoDB的模糊查询在PHP里的具体实现为： 
      
    $query=array("name"=>new MongoRegex("/.*".$name.".*/i"));
    $db->find($query);

  关于更多SQL与MongoDB的对应关系表可以参考PHP官方资料：  

SQL to Mongo Mapping Chart：

<http://us.php.net/manual/en/mongo.sqltomongo.php> 其中的：

	_$db->users->find(array("name" => new MongoRegex("/Joe/"))); 

和上面效果是一样的。