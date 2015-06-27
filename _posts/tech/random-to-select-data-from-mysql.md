Title: 从MySQL随机选取数据
Date: 2014-03-06 22:33:32
Tags: mysql, random


从MySQL随机选取数据也是我们最常用的一种发发，其最简单的办法就是使用”ORDER BY RAND()”;

下面从以下四种方案分析各自的优缺点。

## 方案一：
    
    
    SELECT * FROM `table` ORDER BY RAND() LIMIT 0,1;
    

这种方法的问题就是非常慢。原因是因为MySQL会创建一张零时表来保存所有的结果集，然后给每个结果一个随机索引，然后再排序并返回。

有几个方法可以让它快起来。

基本思想就是先获取一个随机数，然后使用这个随机数来获取指定的行。

由于所有的行都有一个唯一的id，我们将只取最小和最大id之间的随机数，然后获取id为这个数行。为了让这个方法当id不连续时也能有效，我们在最终的查询里使用”>=”代替”=”。

为了获取整张表的最小和最大id，我们使用MAX()和MIN()两个聚合函数。这两个方法会返回指定组里的最大和最小值。在这里这个组就是我们表里的所有id字段值。

## 方案二：
    
    
    <?php
    $range_result = mysql_query( " SELECT MAX(`id`) AS max_id , MIN(`id`) AS min_id FROM `table` ");
    $range_row = mysql_fetch_object( $range_result );
    $random = mt_rand( $range_row->min_id , $range_row->max_id );
    $result = mysql_query( " SELECT * FROM `table` WHERE `id` >= $random LIMIT 0,1 ");
    

就像我们刚才提到的，这个方法会用唯一的id值限制表的每一行。那么，如果不是这样情况怎么办？

下面这个方案是使用了MySQL的LIMIT子句。LIMIT接收两个参数值。第一个参数指定了返回结果第一行的偏移量，第二个参数指定了返回结果的最大行数。偏移量指定第一行是0而不是1。

为了计算第一行的偏移量，我们使用MySQL的RAND()方法从0到1之间生成一个随机数。然后我们把这个数字跟我们用COUNT()方法获取倒的表记录数相乘。由于LIMIT的参数必须是int型而不能是float，我们使用FLOOR()来处理结果。FLOOR()会计算小于表达式的最大值。最终的代码就是这样：

## 方案三：
    
    
    <?php
    $offset_result = mysql_query( " SELECT FLOOR(RAND() * COUNT(*)) AS `offset` FROM `table` ");
    $offset_row = mysql_fetch_object( $offset_result );
    $offset = $offset_row->offset;
    $result = mysql_query( " SELECT * FROM `table` LIMIT $offset, 1 " );
    

在MySQL 4.1以后我们可以使用子子查询合并上面两个方法：

## 方案四：
    
    
    SELECT * FROM `table` WHERE id >= (SELECT FLOOR( MAX(id) * RAND()) FROM `table` ) ORDER BY id LIMIT 1;
    

这个方案跟方案二有同样的弱点，只对有唯一id值的表有效。

记住我们最初寻找选择随机行的替代方法的原因，速度！所以，这些方案的在执行时间上的比较会怎么样？我不会指出硬件和软件配置或者给出具体的数字。大概的结果是这样的：

最慢的是解决方案一（我们假定它用了100%的时间）。

  * 方案二用了79% 
  * 方案三 - 13% 
  * 方案四 - 16%

so, 方案三胜出！

原文：<http://blog.yesmeck.com/archives/mysql-random-row/>
