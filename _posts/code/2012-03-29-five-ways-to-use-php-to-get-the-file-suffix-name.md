---
layout: post
title: 使用 PHP 写出五种方式来获取文件后缀名称
date: 2012-03-29 23:26:33
category: 代码
tags: PHP 后缀
---

##直接上代码

    <?php
    /**
     * 写出五种方式来获取文件后缀名称,一个非常容易考试的题目
     */
    $filename  = 'www.baidu.com/images/logo.png';
    
    //第一种使用strrchr函数进行字符串的截取
    //先截取.后面的部分，然后再使用substr截取从1开始的字符串则可
    echo "<br>" .  substr(strrchr($filename,'.'),1); 
    
    //第二种方式使用pathinfo函数进行数组排列
    $arr =  pathinfo($filename);
    echo "<br>" . $arr['extension'];
    
    //第三种方式使用strrpos函数,查找最后一个.的位置然后再使用substr截取该长度
    echo "<br>" . substr($filename,(strrpos($filename,'.')+1));
    
    //第四种巧妙的使用数组的方式进行获取 :-)
    $ar = explode('.',$filename);
    echo "<br>" . array_pop($ar);
    
    //第五种则可使用正则表达式了
    echo "<br>" . (preg_replace('/.*\.(.*[^\.].*)*/iU','\\1',$filename));
    ?>
