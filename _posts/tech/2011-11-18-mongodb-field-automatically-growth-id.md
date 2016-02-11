---
layout: post
title: MongoDB 实现字段自动增长id
date: 2011-11-18 17:23:57
category: 技术
tags: MongoDB
---


MongoDB 本身不支持类似 MySQL 的ID自动增长，所以需要通过其他方法来进行id自动增长的实现。  

* 首先创建一个自动增长id集合 ids  

		db.ids.save({name:”user”, id:0});
		
	注：name:是存储集合的名称，好做对应
	id : 存储对应表的最大ID

* 可以查看一下是否成功  

		db.ids.find();
		{ “_id” : ObjectId(“4c637dbd900f00000000686c”), “name” : “user”, “id” : 0 }

* 然后每次添加新用户之前自增一下 ids集合 获得id

		userid = db.ids.findAndModify({update:{$inc:{‘id’:1}}, query:{“name”:”user”}, new:true});
		{ “_id” : ObjectId(“4c637dbd900f00000000686c”), “name” : “user”, “id” : 1 }
		
	注：因为findAndModify是一个方法完成更新查找两个操作，所以具有原子性，多线程不会冲突。

* 然后保存相应的数据

		db.user.save({uid:userid.id, username:”kekeles”, password:”kekeles”, info:”http://www.lnmp100.com// “});

* 查看结果

		db.user.find();
		{ “_id” : ObjectId(“4c637f79900f00000000686d”), “uid” : 1, “username” : “admin”, “password” : “admin” }

这是mongo的shell，如果用的是服务器端程序java php python，可以自己对这些操作封装一下，只用传几个参数就可以返回自增的id，还可以实现像Oracle的跨表的自增id。

自己写了一段php的，拿出来给大家分享。
    
    
    <?php
    function mid($name, $db){
        $update = array(‘$inc’=>array(“id”=>1));
        $query = array(‘name’=>$name);
        $command = array(
        'findandmodify' => 'ids', 'update' => $update,
        'query' => $query, 'new => true, 'upsert' => true
        );
       $id = $db->command($command);
       return $id['value']['id'];
    }
    
    $conn = new Mongo();
    $db = $conn->idtest;
    $id = mid(‘user’, $db);
    $db->user->save(array(‘uid’=>$id, ‘username’=>’kekeles’, ‘password’=>’kekeles’, ‘info’=>’http://www.lnmp100.com// ‘));
    $conn->close();
    ?>

  原文链接：<http://www.dotcoo.com/post-39.html>   
  也可参考：<http://huoding.com/2011/02/09/47>