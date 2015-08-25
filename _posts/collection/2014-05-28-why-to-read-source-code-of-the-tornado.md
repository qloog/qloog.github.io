---
layout: post
title: 为什么要阅读Tornado的源码
date: 2014-05-28 12:35
category: 收藏
tags: Tornado, 源码阅读
---


## 为什么要阅读Tornado源码？

Tornado 由前 google 员工开发，代码非常精练，实现也很轻巧，加上清晰的注释和丰富的 demo，我们可以很容易的阅读分析 tornado. 通过阅读 Tornado 的源码，你将学到：

 * 理解 Tornado 的内部实现，使用 tornado 进行 web 开发将更加得心应手。
 * 如何实现一个高性能，非阻塞的 http 服务器。
 * 如何实现一个 web 框架。
 * 各种网络编程的知识，比如 `epoll`
 * python 编程的绝佳实践

在tornado的子目录中，每个模块都应该有一个.py文件，你可以通过检查他们来判断你是否从已经从代码仓库中完整的迁出了项目。在每个源代码的文件中，你都可以发现至少一个大段落的用来解释该模块的doc string，doc string中给出了一到两个关于如何使用该模块的例子。

下面首先介绍 Tornado 的模块按功能分类。

## Tornado模块分类

 1. Core web framework

    * tornado.web — 包含web框架的大部分主要功能，包含RequestHandler和Application两个重要的类
    * tornado.httpserver — 一个无阻塞HTTP服务器的实现
    * tornado.template — 模版系统
    * tornado.escape — HTML,JSON,URLs等的编码解码和一些字符串操作
    * tornado.locale — 国际化支持


 2. Asynchronous networking 底层模块

    * tornado.ioloop — 核心的I/O循环
    * tornado.iostream — 对非阻塞式的 socket 的简单封装，以方便常用读写操作
    * tornado.httpclient — 一个无阻塞的HTTP服务器实现
    * tornado.netutil — 一些网络应用的实现，主要实现TCPServer类


 3. Integration with other services

    * tornado.auth — 使用OpenId和OAuth进行第三方登录
    * tornado.database — 简单的MySQL服务端封装(3.0版本后，不再提供，而是成为了一个独立的包：torndb，可以直接安装后import trondb)
    * tornado.platform.twisted — 在Tornado上运行为Twisted实现的代码
    * tornado.websocket — 实现和浏览器的双向通信
    * tornado.wsgi — 与其他python网络框架/服务器的相互操作


 4. Utilities

    * tornado.autoreload — 生产环境中自动检查代码更新
    * tornado.gen — 一个基于生成器的接口，使用该模块保证代码异步运行
    * tornado.httputil — 分析HTTP请求内容
    * tornado.options — 解析终端参数
    * tornado.process — 多进程实现的封装
    * tornado.stack_context — 用于异步环境中对回调函数的上下文保存、异常处理
    * tornado.testing — 单元测试

