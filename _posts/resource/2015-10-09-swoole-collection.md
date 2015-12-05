---
layout: post
title: swoole资源整理
category: 资源
date: 2015-12-05
tags: swoole
---

 PHP的高性能Server框架Swoole，使用纯C编写，以PHP扩展的方式提供了一个强大的异步并行Server框架，特征如下：
  
  - 基于linux epoll+eventfd，不依赖libevent等第三方库，在Linux下可直接编译。
  - 支持3种模式Call、Writer和Worker。
  - 网络模块是完全异步非阻塞的，而且实现了读写分离，无锁设计。


### 1、PHP系统编程

* [PHP系统编程](http://rango.swoole.com/php%E7%B3%BB%E7%BB%9F%E7%BC%96%E7%A8%8B)

### 2、扩展

* [Swoole扩展](http://rango.swoole.com/php_swoole)  

 