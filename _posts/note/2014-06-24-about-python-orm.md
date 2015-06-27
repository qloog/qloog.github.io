---
layout: post
title: 关于tornado中数据库操作的那些事
date:  2014-06-24 23:09:00
category: 技术
tags: Tornado SQLAlchemy storm ORM
---


最近一直在用tornado尝试写个后台，从开始到现在一直在用 [SQLAlchemy](http://www.sqlalchemy.org/), 用的时候一直磕磕绊绊，中间也想着放弃来着，后来想想再坚持一下吧。当然也想过其他db客户端, 如 [torndb](https://github.com/bdarnell/torndb), 一个非常简单的orm类 因为这个简单易用，是直接写纯SQL的方式，容易上手，但想想是不太简单了点，所以也一直没用。  

SQLAlchemy 这货简单上手容易，但是要想用他的中高级功能，目前感觉有些吃力。  
还有一些是别人封装好的db类，操作起来倒是也挺方便，可以拿来直接使用。  
如：

1. [query](https://github.com/PaulGuo/F2E.im/blob/master/lib/query.py)
2. [thing](https://github.com/amxku/toaza.com/blob/master/ginoa/extensions/thing.py)

在V2EX上看到帖子说v2ex现在用的是storm, Storm 是一个 Python ORM 库,支持： SQLite ， MySQL 以及 PostgreSQL, 功能间与torndb与SQLAlchemy 之间。  

上面说了一些其他的类或者ORM，不过我还是坚持使用我的 SQLAlchemy，上手随吃力，但是功能很强大，一步一步来掌握它的精髓吧。  



相关资料：  

 * [torndb教程](http://torndb.readthedocs.org/)  
 * [Storm 官方教程](https://storm.canonical.com/Tutorial)  
 * [Storm Tutorial 中文版](https://strom-orm-tutorial.readthedocs.org/en/latest/)  
 * [SQLAlchemy官网](www.sqlalchemy.org)