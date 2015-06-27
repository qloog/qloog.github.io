---
layout: post
title: 推荐一款国内PHP开源框架--Yaf(基于C语言编写、PHP扩展形式)
date: 2012-04-03 13:08:19
category: 技术
tags: PHP 框架 PHP扩展
---

## 关于：

Yaf是一个C语言编写的PHP框架（作者:[Laruence](http://www.laruence.com/) , [PHP](http://www.php.net/)开发组成员, [PECL](http://pecl.php.net/)开发者. Yaf, Taint等Pecl扩展作者.曾就职于百度，现就职于新浪微博）。 Yaf is a PHP framework similar to zend framework, which is written in c and built as PHP extension. Yaf是一个用PHP扩展形式提供的PHP开发框架, 相比于一般的PHP框架, 它更快. 它提供了Bootstrap, 路由, 分发, 视图, 插件, 是个一个全功能的PHP框架. you can refer to [Yaf Manual](http://www.php.net/manual/en/book.yaf.php)([中文版](http://yaf.laruence.com/manual/)) for more informations. 

## 特点：

在和其他用PHP写的PHP框架来比的话, Yaf就是剑的第二层境界. 框架不在你手中, 而在PHP的"心"中. 目前PHP的框架层出不穷, 其中不乏很多优秀的框架, 比如Zend官方支持的Zend Framework, Yii, ci等等. 但在这繁多的框架也就造成了公司内多种框架的业务产品. 这些框架之间的不同, 也就导致了多种版本的类库, 框架, 约定, 规范,,,, 那么, 为什么现在开源社区没有一个成熟的用PHP扩展开发的框架呢?  

### 用PHP扩展写PHP框架的难点

  1. 难于开发. 要完成一个PHP扩展的PHP框架, 需要作者有C背景, 有PHP扩展开发背景, 更要有PHP框架的设计经验.
  2. 目标用户群小. 现在国内很多中小型站都是使用虚拟主机, 并不能随意的给PHP添加扩展, 所以这些大部分的中小型企业, 个人博客的用户就无法使用.
  3. 维护成本高. 要维护PHP扩展, 不仅仅需要精通于C的开发和调试, 更要精通于Zend API, 并且升级维护的周期也会很长.

  那既然这样, 为什么还要用PHP扩展来开发框架呢, 或者说, 这可行么? 

### 用PHP扩展写PHP框架的可行性

  1. 扩展逻辑相对比较稳定, 一般不易变化. 把它们抽象出来, 用扩展实现, 不会带来额外的维护负担.
  2. 框架逻辑复杂, 自检耗时耗内存都比较可观, 而如果用扩展来实现, 就能大幅减少这部分对资源的消耗.
 

## 优点：

  1. 用C语言开发的PHP框架, 相比原生的PHP, 几乎不会带来额外的性能开销.
  2. 所有的框架类, 不需要编译, 在PHP启动的时候加载, 并常驻内存.
  3. 更短的内存周转周期, 提高内存利用率, 降低内存占用率.
  4. 灵巧的自动加载. 支持全局和局部两种加载规则, 方便类库共享.
  5. 高性能的视图引擎.
  6. 高度灵活可扩展的框架, 支持自定义视图引擎, 支持插件, 支持自定义路由等等.
  7. 内建多种路由, 可以兼容目前常见的各种路由协议.
  8. 强大而又高度灵活的配置文件支持. 并支持缓存配置文件, 避免复杂的配置结构带来的性能损失.
  9. 在框架本身,对危险的操作习惯做了禁止.
  10. 更快的执行速度, 更少的内存占用.

## 相关资料
  * 安装及使用教程 <https://github.com/laruence/php-yaf#yaf---yet-another-framework>   
  * 关于更多的Yaf框架资料： Yaf(Yet Another Framework)
  * 用户手册：<http://yaf.laruence.com/manual/index.html> P
  * HP官方下载：<http://pecl.php.net/package/yaf> 
  * 安装说明：<http://www.laruence.com/yaf/> 
  * 作者官网：<http://www.laruence.com/>
