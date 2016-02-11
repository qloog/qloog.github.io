---
layout: post
title: PHP多线程类
date: 2012-07-08 00:30:26
category: 技术
tags: PHP 多进程
---

通过php的Socket方式实现php程序的多线程。php本身是不支持多线程的，那么如何在php中实现多线程呢？可以想一下，WEB服务器本身都是支持多线程的。每一个访问者，当访问WEB页面的时候，都将调用新的线程，通过这一点我们可以利用WEB服务器自身的线程来解决PHP不支持多线程的问题。  下面给出通过 fsockopen() 建立socket连接，然后用 用fputs() 发送消息，来实现的PHP多线程类代码： 
    
    
    $fp=fsockopen($_SERVER['HTTP_HOST'],80,&$errno,&$errstr,5); 
    if(!$fp){
    echo "$errstr ($errno)<br />\n";
    }
    fputs($fp,"GET $_SERVER[PHP_SELF]?flag=1\r\n"); 
    fclose($fp);

上面这段代码只是一个线程的操作过程。多进行几个这样的操作就是多线程了。目前所谓PHP的多线程程序都是基于这个方式的。 下面给一个完整的线程类代码。 
    
    
    <?php 
    /** 
    @title:PHP多线程类(Thread) 
    @version:1.0 
    @author:axgle <axgle@126.com> 
    */ 
    class thread { 
    var $count; 
    function thread($count=1) { 
    
    $this->count=$count; 
    } 
    
    function _submit() { 
    for($i=1;$i<=$this->count;$i++) $this->_thread(); 
    return true; 
    } 
    
    function _thread() { 
    $fp=fsockopen($_SERVER['HTTP_HOST'],80,&$errno,&$errstr,5); 
    
    if(!$fp){
    echo "$errstr ($errno)<br />\n";
    }
    fputs($fp,"GET $_SERVER[PHP_SELF]?flag=1\r\n"); 
    fclose($fp); 
    } 
    
    function exec($func) { 
    isset($_GET['flag'])?call_user_func($func):$this->_submit(); 
    } 
    
    } 
    
    //应用例子：
    $th=new thread(10);//10个线程 
    $th->exec('demo');//执行行自定义的函数 
    
    function demo() { 
    fopen('data/'.microtime(),'w'); 
    } 
    
    ?>

axgle百度贴吧：<http://tieba.baidu.com/f?kw=axgle>
