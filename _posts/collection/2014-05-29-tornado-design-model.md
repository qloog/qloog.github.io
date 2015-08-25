---
layout: post
title: 鸟瞰Tornado框架的设计模型
date: 2014-05-29 16:51
category: 收藏
tags: Tornado, 设计模型
---



在深入到模块进行分析之前，首先来看看Tornado的设计模型。


Tornado框架设计模型:

![tornado-design-model](/static/uploads/2014/05/tornado-design-model.png)

从上面的图可以看出，Tornado 不仅仅是一个WEB框架，它还完整地实现了HTTP服务器和客户端，在此基础上提供WEB服务。它可以分为四层：

 * 最底层的EVENT层处理IO事件；
 * TCP层实现了TCP服务器，负责数据传输；
 * HTTP/HTTPS层基于HTTP协议实现了HTTP服务器和客户端；
 * 最上层为WEB框架，包含了处理器、模板、数据库连接、认证、本地化等等WEB框架需要具备的功能。
 
理解Tornado的核心框架之后，就能便于我们后续的理解。

代码文件级别的设计组成，请阅读 [为什么要阅读Tornado的源码？](/collection/why-to-read-source-code-of-the-tornado.html) 。