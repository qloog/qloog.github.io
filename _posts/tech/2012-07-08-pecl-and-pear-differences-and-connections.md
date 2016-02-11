---
layout: post
title: Pecl和Pear的区别和联系
date: 2012-07-08 11:58:51
category: 技术
tags: Pecl Pear
---


Pear、Pecl都是PHP扩展模块的集合。

扩展PHP有两种方法： 

A. 一种是用纯粹的PHP代码写函数和类。 Pear就是这样一个项目。PEAR是PHP的官方开源类库(PHP Extension and Application Repository的缩写)。Pear在英文中是梨子的意思。PEAR将PHP程序开发过程中常用的功能编写成类库，涵盖了页面呈面、数据库访问、文件操作、数据结构、缓存操作、网络协议等许多方面，用户可以很方便地使用。它是一个PHP扩展及应用的一个代码仓库，简单地说，PEAR就是PHP的cpan。其主页是pear.php.net。 

B. 另外一种是用c或者c++编写外部模块加载至php中。 Pecl(The PHP Extension Community Library)就是干这个事的，PHP的标准扩展，可以补充实际开发中所需的功能。所有的扩展都需要安装，在Windows下面以DLL的形式出现；在linux下面需要单独进行编译，它的表现形式为根据PHP官方的标准用C语言写成，尽管源码开放但是一般人无法随意更改源码。其主页是pecl.php.net。 最直接的表述：Pear是PHP的上层扩展，Pecl是PHP的底层扩展。 

这两种方法其实都是为特定的应用提供现成的函数或者类，本质上来说都是一样的。
