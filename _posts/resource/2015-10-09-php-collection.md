---
layout: post
title: PHP整理
category: 资源
date: 2015-10-09
tags: PHP
---

> 为了方便自己理解和查阅，整理了下常用的资料：



### 1、Laravel

#### 官网: [http://laravel.com/](http://laravel.com/)

#### 文档

* [中文文档5.1](http://laravel-china.org/docs/5.1)
* [官方文档](http://laravel.com/docs/5.1)

#### 社区

* [PHPHub](https://phphub.org/)
* [LARAVEL DOJO](http://www.laravel-dojo.com/)

#### 视频

* [laracasts](https://laracasts.com)
* [https://scotch.io/tag/laravel](https://scotch.io/tag/laravel)

#### 博客

* [http://www.insp.top/learn-laravel-container](http://www.insp.top/learn-laravel-container) (神奇的服务容器,有助于理解Laravel的架构理念)
* [http://heera.it/](http://heera.it/) （一个blog）
* [LARAVEL – 5.1.X ACL USING MIDDLEWARE](http://heera.it/laravel-5-1-x-acl-middleware)
* [Laravel Coding](http://laravelcoding.com/blog) (如何搭建博客系统完整版-含后台管理功能)
  > Posts Administration: http://laravelcoding.com/blog/laravel-5-beauty-posts-administration
* [Laravel 5.1 Beauty](https://leanpub.com/l5-beauty/read) （博客搭建、图片管理、RSS订阅等）
* [A Laravel 5 Boilerplate Project](https://github.com/rappasoft/laravel-5-boilerplate) (比较全面的一个project)
* https://laraveltips.wordpress.com/

#### 常用的vender

* [wechar-php-sdk](https://github.com/overtrue/wechat)
* [Excel](https://github.com/Maatwebsite/Laravel-Excel)
* [Image](https://github.com/Intervention/image/)
* [User Agent](https://github.com/jenssegers/laravel-agent)
* [Laravel-debugbar](https://github.com/barryvdh/laravel-debugbar)
* [Repository](https://github.com/Bosnadev/Repositories)
* [guzzlehttp/guzzle](https://packagist.org/packages/guzzlehttp/guzzle)
* [验证码](https://github.com/mewebstudio/captcha)
* [laravel 5 Markdown](https://github.com/yccphp/laravel-5-markdown-editor)
* [evaOauth](http://avnpc.com/pages/evaoauth)

### 2、PHP系统编程

* [PHP系统编程](http://rango.swoole.com/php%E7%B3%BB%E7%BB%9F%E7%BC%96%E7%A8%8B)

### 3、扩展

* [Swoole扩展](http://rango.swoole.com/php_swoole)  

  PHP的高性能Server框架Swoole，使用纯C编写，以PHP扩展的方式提供了一个强大的异步并行Server框架，特征如下：
  
  - 基于linux epoll+eventfd，不依赖libevent等第三方库，在Linux下可直接编译。
  - 支持3种模式Call、Writer和Worker。
  - 网络模块是完全异步非阻塞的，而且实现了读写分离，无锁设计。
