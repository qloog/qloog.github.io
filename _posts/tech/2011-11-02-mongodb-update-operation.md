---
layout: post
title: PHP与MongoDB的update操作
date: 2011-11-02 18:18:11
category: 技术
tags: MongoDB
---


因为mongoDB的update方法有很多与no-sql不同的地方，所以把它单独拿出来讨论。

1、php的mongoDB之update方法中：

只谈到了php方法和语法，
<http://www.php.net/manual/en/mongocollection.update.php> 但这是远远不够的。

2、mongoDB的官方手册中：

只提到了command方式的写法 <http://www.mongodb.org/display/DOCS/Updating> 没有php的具体实做方法。 在学习和实践中，要把两个手册结合起来用。
 

**$inc**

如果记录的该节点存在，让该节点的数值加N；如果该节点不存在，让该节点值等于N 设结构记录结构为 array(’a'=>1,’b'=>’t'),想让a加5，那么：

> $coll->update( array(’b'=>’t'), array(’$inc’=>array(’a'=>5)), )

**$set**

让某节点等于给定值 设结构记录结构为 array(’a'=>1,’b'=>’t'),b为加f，那么：

> $coll->update( array(’a'=>1), array(’$set’=>array(’b'=>’f')), )

**$unset**

删除某节点 设记录结构为 array(’a'=>1,’b'=>’t')，想删除b节点，那么：

> $coll->update( array(’a'=>1), array(’$unset’=>’b'), )

**$push**

如果对应节点是个数组，就附加一个新的值上去；不存在，就创建这个数组，并附加一个值在这个数组上；如果该节点不是数组，返回错误。 设记录结构为array(’a'=>array(0=>’haha’),’b'=>1)，想附加新数据到节点a，那么：

> $coll->update( array(’b'=>1), array(’$push’=>array(’a'=>’wow’)), )

这样，该记录就会成为：array(’a'=>array(0=>’haha’,1=>’wow’),’b'=>1)


**遇到的困难：**

1、在原有的文档里添加新的字段，用update。

> $mongo->dbname->mycoll->update('id'=>1,array('$set' => array('新字段名'=>'对应的值')))

2、在文档里添加新字段，并且值为数组，解决方法为：

> $mongo->dbname->mycoll->update('id'=>1,array('$set' => array('新字段名'=>array('k1'=>'v1'))))

添加第二组数组的方法为：

> $mongo->dbname->mycoll->update('id'=>1,array('$push' => array('新字段名'=>('k2'=>'v2')))

仔细对比后会发现，后来添加时少一个 array就可以。这样新加的字段字段就是一个数组。

如图： ![mongo_array](/static/uploads/2011/11/mongo_array.jpg)

此解决方法参考链接为：http://www.bumao.com/index.php/2010/08/mongodb_php_update.html

3、对新添加输入如何查询： 命令行下的查询方法：

> db.foodstore_raw_food.find({"effect_params.effect_id":"111"},{"food_id":true,"food_name":true});

PHP下的查询方法：

> $mongo->db->mycoll->find('新字段名.数组key' => '要查询的值')

此解决方法参考链接为：http://www.cnblogs.com/piaolingxue/archive/2011/06/28/2092505.html

**$pushAll**

与$push类似，只是会一次附加多个数值到某节点

**$addToSet**

如果该阶段的数组中没有某值，就添加之 设记录结构为array(’a'=>array(0=>’haha’),’b'=>1)，如果想附加新的数据到该节点a，那么：

> $coll->update( array(’b'=>1), array(’$addToSet’=>array(’a'=>’wow’)), )

如果在a节点中已经有了wow,那么就不会再添加新的，如果没有，就会为该节点添加新的item——wow。

**$pop**

设该记录为 array(’a'=>array(0=>’haha’,1=>’wow’),’b'=>1) 删除某数组节点的最后一个元素:

> $coll->update( array(’b'=>1), array(’$pop=>array(’a'=>1)), )

删除某数组阶段的第一个元素

> $coll->update( array(’b'=>1), array(’$pop=>array(’a'=>-1)), )

**$pull**

如果该节点是个数组，那么删除其值为value的子项，如果不是数组，会返回一个错误。 设该记录为 array(’a'=>array(0=>’haha’,1=>’wow’),’b'=>1)，想要删除a中value为haha的子项：

> $coll->update( array(’b'=>1), array(’$pull=>array(’a'=>’haha’)), )

结果为： array(’a'=>array(0=>’wow’),’b'=>1) $pullAll 与$pull类似，只是可以删除一组符合条件的记录。
