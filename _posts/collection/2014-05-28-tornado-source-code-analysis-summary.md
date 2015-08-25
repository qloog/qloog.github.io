---
layout: post
title: Tornado源码解析目录汇总
date: 2014-05-28 12:16
category: 收藏
tags: Tornado, 源码分析
---

为了能够更好的学习tornado框架，更好的运用它，接下来将对tornado进行分析讲解。

大概目录如下：

 * [section 01 为什么要阅读Tornado的源码？](/note/why-to-read-source-code-of-the-tornado.html)
 * [section 02 预备知识：我读过的对epoll最好的讲解](/collection/prior-knowledge-i-have-read-the-best-explanation-for-epoll.html)
 * section 03 epoll与select/poll性能，CPU/内存开销对比
 * section 04 开始Tornado的源码分析之旅
 * section 05 鸟瞰Tornado框架的设计模型
 * section 06 Tornado源码必须要读的几个核心文件
 * section 07 Tornado HTTP服务器的基本流程
 * section 08 Tornado RequestHandler和Application类
 * section 09 Application对象的接口与起到的作用
 * section 10 RequestHandler的分析
 * section 11 Tornado的核心web框架tornado.web小结
 * section 12 HTTP层：HTTPRequest,HTTPServer与HTTPConnection
 * section 13 Tornado在TCP层里的工作机制
 * section 14 Tornado TCPServer类的设计解读
 * section 15 从代码分析TCPServer类的机制
 * section 16 Tornado高性能的秘密：ioloop对象分析
 * section 17 Tornado IOLoop instance()方法的讲解
 * section 18 Tornado IOLoop start()里的核心调度
 * section 19 Tornado IOLoop与Configurable类
 * section 20 弄清楚HTTPServer与Request处理流程
 * section 21 对socket封装的IOStream机制概览
 * section 22 IOStream实现读写的一些细节
 * section 23 番外篇：Tornado的多进程管理分析
