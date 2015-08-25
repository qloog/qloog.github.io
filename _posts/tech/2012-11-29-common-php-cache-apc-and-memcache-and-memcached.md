---
layout: post
title: PHP 常用缓存 APC & Memcache & Memcached
date: 2012-11-29 22:48:42
category: 技术
tags: PHP, cache, apc, memcache, memcached
---


APC：Alternative PHP Cache（APC）是 PHP 的一个免费公开的优化代码缓存。它用来提供免费，公开并且强健的架构来缓存和优化 PHP 的中间代码。
 
链接地址：<http://php.net/manual/en/book.apc.php>
 
Memcache：Memcache module provides handy procedural and object oriented interface to memcached, highly effective caching daemon, which was especially designed to decrease database load in dynamic web applications. 
 
链接地址：<http://php.net/manual/en/book.memcache.php>
 
Memcached：高性能的，分布式的内存对象缓存系统，用于在动态应用中减少数据库负载，提升访问速度。
 
链接地址：<http://memcached.org/>


## APC VS Memcached

Memcached 为分布式缓存系统，而 APC 为非分布式缓存系统。 

如果你的 web 应用程序架设于不同的 web 服务器（负载平衡），你可以使用 memcached 构建你的缓存系统。如果不是，完全可以使用 APC 来构建，而且架设于一台服务器上，APC 的速度优于 memcached。 

Memcached 内存使用方式也和 APC 不同。APC是基于共享内存和 MMAP 的，memcachd 有自己的内存分配算法和管理方式，它和共享内存没有关系，也没有共享内存的限制，通常情况下，每个 memcached 进程可以管理2GB的内存空间，如果需要更多的空间，可以增加进程数。 （截取自：<http://blog.developers.api.sina.com.cn/?p=124>） 

Memcached 是“分布式”的内存对象缓存系统，那么就是说，那些不需要“分布”的，不需要共享的，或者干脆规模小到只有一台服务器的应用，memcached 不会带来任何好处，相反还会拖慢系统效率，因为网络连接同样需要资源，即使是 UNIX 本地连接也一样。 在我之前的测试数据中显示，memcached 本地读写速度要比直接PHP内存数组慢几十倍，而 APC、共享内存方式都和直接数组差不多。可见，如果只是本地级缓存，使用 memcached 是非常不划算的。（截取自：<http://blog.developers.api.sina.com.cn/?p=124>） 

跨服务器使用 memcached，最好要使用内网，不然的话，受路由的影响，memcached 经常会连接超时(超过100ms)，而且会凭空多出来两倍的宽带流量。（截取自：<http://www.9enjoy.com/compare-one-server-apc-memcached/>）

注：更多关于Memcached信息，移步 <http://blog.developers.api.sina.com.cn/?p=124>

 

## Memcached VS Memcache

主要区别是php memcached扩展比较新,几乎支持 memcached 的所有特性(如 Delayed Get, Append/Prepend 等). 但是它依赖 libmemcached 才能运行(在debian里面包名是libMemcached5).  
所以如果你不使用如 Delayed Get 这样的特性,又不想多依赖 libmemcached 库, 完全可以使用 memcache 扩展. 反之请选择 memcached 扩展。（截取自：<http://www.leonzhang.com/2011/06/24/memcached-vs-php-memcache/>）

 

Memcached client library was just recently released as stable. It is being used by **digg** ( was developed for digg by Andrei Zmievski, now no longer with digg) and implements much more of the memcached protocol than the older memcache client. The most important features that memcached has are:

  1. Cas tokens. This made my life much easier and is an easy preventive system for stale data. Whenever you pull something from the cache, you can receive with it a cas token (a double number). You can than use that token to save your updated object. If no one else updated the value while your thread was running, the swap will succeed. Otherwise a newer cas token was created and you are forced to reload the data and save it again with the new token.
  2. Read through callbacks are the best thing since sliced bread. It has simplified much of my code.
  3. getDelayed() is a nice feature that can reduce the time your script has to wait for the results to come back from the server.
  4. While the memcached server is supposed to be very stable, it is not the fastest. You can use binary protocol instead of ASCII with the newer client.
  5.
