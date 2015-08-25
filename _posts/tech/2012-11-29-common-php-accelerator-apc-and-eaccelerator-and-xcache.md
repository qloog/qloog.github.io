---
layout: post
title: PHP 常用加速器 APC & eAccelerator & XCache
date: 2012-11-29 22:45:43
category: 技术
tags: PHP, APC, eAccelerator, XCache
---

> PHP 加速器是一个为了提高 PHP 执行效率，从而缓存起 PHP 的操作码，这样 PHP 后面执行就不用解析转换了，可以直接调用 PHP 操作码，这样速度上就提高了不少。
>
> Apache 中使用 mod_php 的请求、响应执行流程：
1、Apache 接收请求
2、Apache 传递请求给 mod_php
3、mod_php 定位磁盘文件，并加载到内存中
4、mod_php 编译源代码成为 opcode 树
5、mod_php 执行 opcode 树
>
> PHP加速器相应的就是第四步，它的目的就是防止PHP每次请求都重复编译PHP代码，因为在高访问量的网站上，大量的编译往往没有执行速度快呢？所以这里面有个瓶颈就是PHP的重复编译既影响了速度又加载了服务器负载，为了解决此问题，PHP加速器就这样诞生了。
>
>  
>
> APC：Alternative PHP Cache（APC）是 PHP 的一个免费公开的优化代码缓存。它用来提供免费，公开并且强健的架构来缓存和优化 PHP 的中间代码。
>
> 链接地址：<http://php.net/manual/en/book.apc.php>
>
> eAccelerator：eAccelerator 是一个自由开放源码php加速器，优化和动态内容缓存，提高了 php 脚本的缓存性能，使得PHP脚本在编译的状态下，对服务器的开销几乎完全消除。 它还有对脚本起优化作用，以加快其执行效率。使您的PHP程序代码执效率能提高1-10倍（截取自：<http://baike.baidu.com/view/1376127.htm>）
>
> 链接地址：<http://eaccelerator.net/>
>
> XCache：XCache 是一个开源的 opcode 缓存器/优化器, 这意味着他能够提高您服务器上的 PHP 性能. 他通过把编译 PHP 后的数据缓冲到共享内存从而避免重复的编译过程, 能够直接使用缓冲区已编译的代码从而提高速度. 通常能够提高您的页面生成速率 2 到5 倍, 降低服务器负载（截取自：<http://baike.baidu.com/view/1999371.htm>）
>
> 链接地址：<http://xcache.lighttpd.net/wiki/WikiStart.>

 

**APC VS eAccelerator VS XCache **

**速度比较**

![2012082309322532](http://pic002.cnblogs.com/images/2012/117304/2012082309322532.jpg)

图中可以看到：APC，XCache，eAccelerator 的测试数据，相对来说 XCache 表现最好，但是每个加速器都有各种微调参数，具体视部署环境而定。

 

**版本存活状态**

（截取自：<http://en.wikipedia.org/wiki/List_of_PHP_accelerators>）

##  Alternative PHP Cache (APC)

Alternative PHP Cache is a free, open source ([PHP license](http://en.wikipedia.org/wiki/PHP_license)) framework that optimizes PHP intermediate code and caches data and compiled code from the PHP bytecode compiler in shared memory.

  * **Website:** <http://pecl.php.net/package/APC>
  * **PHP version:** works with all PHP versions including PHP 5.2-5.4 (3.1.10 - beta release) (not PHP 5.0)
  * **Latest stable version:** 3.1.9 (released 2011-05-14)
  * **Status:** stable, actively maintained.
  * **Download link:** <http://pecl.php.net/package/APC> (source)
  * **Download link for Windows:** <http://downloads.php.net/pierre/> (provides some of the PECL extensions, previously available on pecl4win)
  * **Official installation help:** <http://php.net/apc.setup>

##  eAccelerator

eAccelerator was born in December 2004 as a fork of the Turck MMCache project. Turck MMCache was created by Dmitry Stogov and much of the eAccelerator code is still based on his work. eAccelerator also contained a PHP encoder and loader, but the development staff discontinued the encoder and removed this feature after December 2006.

  *
