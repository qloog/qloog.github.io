---
layout: post
title: 开始Tornado的源码分析之旅
date: 2014-05-29 16:00
category: 收藏
tags: Tornado, 源码阅读
---

Tornado 是由 Facebook 开源的一个服务器“套装”，适合于做 python 的 web 或者使用其本身提供的可扩展的功能，完成了不完整的 wsgi 协议，可用于做快速的 web 开发，封装了 epoll 性能较好。  
文章主要以分析 tornado 的网络部分即异步事件处理与上层的 IOstream 类提供的异步IO，其他的模块如 web 的 tornado.web 以后慢慢留作分析。

下面开始我们的 Tornado 之旅，看源代码之前必定需要有一份源码了，大家可以去官网下载一份。这里分析的是 3.2.1。

Tornado 的源码组织如下：

	(tornado)➜  tornado  >tree
	.
	├── __init__.py
	├── auth.py
	├── autoreload.py
	├── ca-certificates.crt
	├── concurrent.py
	├── curl_httpclient.py
	├── escape.py
	├── gen.py
	├── httpclient.py
	├── httpserver.py
	├── httputil.py
	├── ioloop.py
	├── iostream.py
	├── locale.py
	├── log.py
	├── netutil.py
	├── options.py
	├── platform
	│   ├── __init__.py
	│   ├── asyncio.py
	│   ├── auto.py
	│   ├── caresresolver.py
	│   ├── common.py
	│   ├── epoll.py
	│   ├── interface.py
	│   ├── kqueue.py
	│   ├── posix.py
	│   ├── select.py
	│   ├── twisted.py
	│   ├── windows.py
	├── process.py
	├── simple_httpclient.py
	├── speedups.so
	├── stack_context.py
	├── tcpserver.py
	├── template.py
	├── test
	│   ├── README
	│   ├── __init__.py
	│   ├── auth_test.py
	│   ├── concurrent_test.py
	│   ├── csv_translations
	│   │   └── fr_FR.csv
	│   ├── curl_httpclient_test.py
	│   ├── escape_test.py
	│   ├── gen_test.py
	│   ├── gettext_translations
	│   │   └── fr_FR
	│   │       └── LC_MESSAGES
	│   │           ├── tornado_test.mo
	│   │           └── tornado_test.po
	│   ├── httpclient_test.py
	│   ├── httpserver_test.py
	│   ├── httputil_test.py
	│   ├── import_test.py
	│   ├── ioloop_test.py
	│   ├── iostream_test.py
	│   ├── locale_test.py
	│   ├── log_test.py
	│   ├── netutil_test.py
	│   ├── options_test.cfg
	│   ├── options_test.py
	│   ├── process_test.py
	│   ├── resolve_test_helper.py
	│   ├── runtests.py
	│   ├── simple_httpclient_test.py
	│   ├── stack_context_test.py
	│   ├── static
	│   │   ├── dir
	│   │   │   └── index.html
	│   │   └── robots.txt
	│   ├── template_test.py
	│   ├── templates
	│   │   └── utf8.html
	│   ├── test.crt
	│   ├── test.key
	│   ├── testing_test.py
	│   ├── twisted_test.py
	│   ├── util.py
	│   ├── util_test.py
	│   ├── web_test.py
	│   ├── websocket_test.py
	│   ├── wsgi_test.py
	├── testing.py
	├── util.py
	├── web.py
	├── websocket.py
	└── wsgi.py


tornado网络部分最核心的两个模块就是`ioloop.py`与`iostream.py`，我们主要分析的就是这两个部分。

 * ioloop.py 主要的是将底层的epoll或者说是其他的IO多路复用封装作异步事件来处理。
 * iostream.py主要是对于下层的异步事件的进一步封装，为其封装了更上一层的buffer（IO）事件。
 
我们先来看看 ioloop（文档地址：<http://www.tornadoweb.org/en/stable/ioloop.html>）：

> We use epoll (Linux) or kqueue (BSD and Mac OS X) if they are available, or else we fall back on select(). If you are implementing a system that needs to handle thousands of simultaneous connections, you should use a system that supports either epoll or kqueue.

Example usage for a simple TCP server:

	import errno
	import functools
	import ioloop
	import socket
	
	def connection_ready(sock, fd, events):
	    while True:
	        try:
	            connection, address = sock.accept()
	        except socket.error, e:
	            if e.args[0] not in (errno.EWOULDBLOCK, errno.EAGAIN):
	                raise
	            return
	        connection.setblocking(0)
	        handle_connection(connection, address)
	
	sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM, 0)
	sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	sock.setblocking(0)
	sock.bind(("", port))
	sock.listen(128)
	
	# 创建一个ioloop 实例
	io_loop = ioloop.IOLoop.instance()
	# connection_ready 的第一个参数为 sock,即 socket 的返回值
	callback = functools.partial(connection_ready, sock)
	# 注册函数，第一个参数是将 sock 转换为标准的描述符，第二个为回调函数，第三个是事件类型
	io_loop.add_handler(sock.fileno(), callback, io_loop.READ)
	io_loop.start()


可以看到在注释前都是使用了传统的创建服务器的方式，不用多介绍，注意就是把套接口设置为非阻塞方式。

创建ioloop实例，这里是使用了ioloop.IOLoop中的 instance()静态方法，以 @classmethod 方式包装。

在后面的add_handler中，程序为我们的监听套接口注册了一个回调函数和一个事件类型。工作方式是这样，在注册了相应的事件类型和回调函数以后，程序开始启动，如果在相应的套接口上有事件发生（注册的事件类型）那么调用相应的回调函数。

当监听套接口有可读事件发生，意味着来了一个新连接，在回调函数中就可以对这个套接口accept，并调用相应的处理函数，其实应该是处理函数也设置为异步的，将相应的连接套接口也加入到事件循环并注册相应的回调函数，只是这里没有展示出来。

在使用非阻塞方式的accept时候常常返回EAGAIN,EWOULDBLOCK 错误，这里采取的方式是放弃这个连接。