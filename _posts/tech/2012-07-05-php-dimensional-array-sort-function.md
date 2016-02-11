---
layout: post
title: PHP二维数组排序函数
date: 2012-07-05 21:33:16
category: 技术
tags: PHP 排序
---

PHP一维数组的排序可以用sort()，asort(),arsort()等函数，但是PHP二维数组的排序需要自定义。  以下函数是对一个给定的二维数组按照指定的键值进行排序，先看函数定义： 
    
    
    function array_sort($arr,$keys,$type='asc'){ 
    	$keysvalue = $new_array = array();
    	foreach ($arr as $k=>$v){
    		$keysvalue[$k] = $v[$keys];
    	}
    	if($type == 'asc'){
    		asort($keysvalue);
    	}else{
    		arsort($keysvalue);
    	}
    	reset($keysvalue);
    	foreach ($keysvalue as $k=>$v){
    		$new_array[$k] = $arr[$k];
    	}
    	return $new_array; 
    }

它可以对二维数组按照指定的键值进行排序，也可以指定升序或降序排序法（默认为升序），用法示例：  
    
    
    $array = array(
    	array('name'=>'手机','brand'=>'诺基亚','price'=>1050),
    	array('name'=>'笔记本电脑','brand'=>'lenovo','price'=>4300),
    	array('name'=>'剃须刀','brand'=>'飞利浦','price'=>3100),
    	array('name'=>'跑步机','brand'=>'三和松石','price'=>4900),
    	array('name'=>'手表','brand'=>'卡西欧','price'=>960),
    	array('name'=>'液晶电视','brand'=>'索尼','price'=>6299),
    	array('name'=>'激光打印机','brand'=>'惠普','price'=>1200)
    );
    
    $ShoppingList = array_sort($array,'price');
    print_r($ShoppingList);

上面是对$array这个二维数组按照'price'从低到高的排序。 输出结果：（略）。
