Title: phpQuery—基于jQuery的PHP实现
Date: 2013/12/25 12:06:07
Tags: PHP, phpQuery

## phpQuery—基于jQuery的PHP实现

Query的选择器之强大是有目共睹的，[phpQuery](http://code.google.com/p/phpquery/) 让php也拥有了这样的能力，它就相当于服务端的jQuery。

先来看看官方简介：

> phpQuery is a server-side, chainable, CSS3 selector driven Document Object Model (DOM) API based on jQuery JavaScript Library.
> 
> Library is written in PHP5 and provides additional Command Line Interface (CLI).

## 存在的意义

我们有时需要抓取一个网页的内容，但只需要特定部分的信息，通常会用正则来解决，这当然没有问题。正则是一个通用解决方案，但特定情况下，往往有更简单快 捷的方法。比如你想查询一个编程方面的问题，当然可以使用Google，但[stackoverflow](http://stackoverflow.com) 作为一个专业的编程问答社区，会提供给你更多，更靠谱的答案。

对于html页面，不应该使用正则的原因主要有3个

### 1、编写条件表达式比较麻烦

尤其对于新手，看到一堆”不知所云”的字符评凑在一起，有种脑袋都要炸了的感觉。如果要分离的对象没有太明显的特征，正则写起来更是麻烦。

### 2、效率不高

对于php来说，正则应该是没有办法的办法，能通过字符串函数解决的，就不要劳烦正则了。用正则去处理一个30多k的文件，效率不敢保证。

### 3、有phpQuery

如果你使用过jQuery，想获取某个特定元素应该是轻而易举的事情，phpQuery让这成为了可能。

## 浅析phpQuery

phpQuery是基于php5新添加的DOMDocument。而DOMDocument则是专门用来处理html/xml。它提供了强大xpath选 择器及其他很多html/xml操作函数，使得处理html/xml起来非常方便。那为什么不直接使用呢？这个，去看一下官网的函数列表 就知道了，如果对自己的记忆力很有信心， 不妨一试。

## 简单示例
    
    
    <?php
    include 'phpQuery.php';  
    phpQuery::newDocumentFile('http://job.blueidea.com');  
    $companies = pq('#hotcoms .coms')->find('div');  
    foreach($companies as $company)  
    {  
       echo pq($company)->find('h3 a')->text()."<br>";  
    }  
    

## 小结

pq()就像jQuery里的$() 基本上jQuery的选择器都可以用在phpQuery上，只要把’.'变成’->’,phpQuery提供了好几种载入文件的方法，有的使用字符串，有的使用文件(包括url)，选 择的时候要注意 基本上[这一页](http://code.google.com/p/phpquery/wiki/Basics) 就很能说明问题了。

## 其他解析器

[simplehtmldom](http://simplehtmldom.sourceforge.net/) 也是个不错的html解析器，使用起来也挺方便，是基 于正则的，所以没有phpQuery那么强大，如果没有太高的要求，也基本够用了。

[yql](http://developer.yahoo.com/yql/) 是yahoo出的一款使用类似SQL的语言，来获取相应的数据，也很强大，无须任何类 库，可以直接调用，支持xpath，如果对SQL语句比较熟悉的话，可以考虑yql。

[QueryPath, php上的jQuery](http://justcoding.iteye.com/blog/673179)

* * *

在网页采集的时候，通常都会用到正则表达式。但是有时候对于正则不太好的同学，比如我，那就杯具了。。如今google的项目里有个phpQuery , 顾名思义query，完全类似于jquery的语法，但这是服务器端的，总体来说就是可以用php来直接采集对应的网页内容了，真的是太方便了, 它让一切变得可能......

phpQuery is a server-side, chainable, CSS3 selector driven Document Object Model (DOM) API [based on](http://code.google.com/p/phpquery/wiki/jQueryPortingState) [jQuery JavaScript Library](http://jquery.com/).

Library is written in [PHP5](http://code.google.com/p/phpquery/wiki/Dependencies) and provides additional [Command Line Interface (CLI)](http://code.google.com/p/phpquery/wiki/CommandLineInterface).

> 项目下载地址：<http://code.google.com/p/phpquery/>

如果你使用过jQuery，你会发现这一切是如此的相象。

如何快速方便的获取到网页的 title?
