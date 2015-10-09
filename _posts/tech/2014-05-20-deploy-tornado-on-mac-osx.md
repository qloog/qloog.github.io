---
layout: post
title: 在Mac OSX上部署tornado
category: 技术
date: 2014-05-20 17:54:31
tags: tornado
---

在安装前大概介绍下tornado

## 由来

Tornado全称Tornado Web Server，是一个用Python语言写成的Web服务器兼Web应用框架，由FriendFeed公司在自己的网站FriendFeed中使用，被Facebook收购以后框架以开源软件形式开放给大众。

> Tornado 是 FriendFeed 使用的可扩展的非阻塞式 web 服务器及其相关工具的开源版本。这个 Web 框架看起来有些像 web.py 或者 Google 的 webapp，不过为了能有效利用非阻塞式服务器环境，这个 Web 框架还包含了一些相关的有用工具 和优化。

> Tornado 和现在的主流 Web 服务器框架（包括大多数 Python 的框架）有着明显的区别：它是非阻塞式服务器，而且速度相当快。得利于其 非阻塞的方式和对 epoll 的运用，Tornado 每秒可以处理数以千计的连接，这意味着对于实时 Web 服务来说，Tornado 是一个理想的 Web 框架。我们开发这个 Web 服务器的主要目的就是为了处理 FriendFeed 的实时功能 ——在 FriendFeed 的应用里每一个活动用户都会保持着一个服务器连接。（关于如何扩容 服务器，以处理数以千计的客户端的连接的问题，请参阅 C10K problem。）

## 特点

 * 作为Web框架，是一个轻量级的Web框架，类似于另一个Python web 框架Web.py，其拥有异步非阻塞IO的处理方式。
 * 作为Web服务器，Tornado有较为出色的抗负载能力，官方用nginx反向代理的方式部署Tornado和其它Python web应用框架进行对比，结果最大浏览量超过第二名近40%。

## 性能

Tornado有着优异的性能。它试图解决C10k问题，即处理大于或等于一万的并发，下表是和一些其他Web框架与服务器的对比:

处理器为 AMD Opteron, 主频2.4GHz, 4核

|| *服务* || *部署* || *请求/每秒* ||
|| Tornado  || nginx, 4进程     || 8213 ||
|| Tornado  || 1个单线程进程    || 3353 ||
|| Django   || Apache/mod_wsgi  || 2223 ||
|| web.py   || Apache/mod_wsgi  || 2066 ||
|| CherryPy || 独立             || 785  ||

## 安装

为了不影响当前操作系统的python环境，我还是选择通过virtualenv 来部署安装tornado

    pip install virtualenv
    virtualenv tornado
    cd tornado
    sh bin/activate

这时显示为：

    (tornado)➜  ~VIRTUAL_ENV  >

开始安装tornado

    pip install tornado

新建项目目录

    mkdir tornado_demo
    cd tornado_demo

## Hello Tornado

新建hello.py 文件，输入以下内容

    import tornado.httpserver
    import tornado.ioloop
    import tornado.options
    import tornado.web

    from tornado.options import define, options
    define("port", default=8000, help="run on the given port", type=int)

    class IndexHandler(tornado.web.RequestHandler):
        def get(self):
            self.write('Hello, Tornado!')

    if __name__ == "__main__":
        tornado.options.parse_command_line()
        app = tornado.web.Application(handlers=[(r"/", IndexHandler)])
        http_server = tornado.httpserver.HTTPServer(app)
        http_server.listen(options.port)
        tornado.ioloop.IOLoop.instance().start()

## 运行

你可以在命令行里尝试运行这个程序以测试输出：

    python hello.py --port=8000

现在你可以在浏览器中打开http://localhost:8000，或者打开另一个终端窗口使用curl测试我们的应用：

    $ curl http://localhost:8000/
    Hello, Tornado!

到此说明tornado搭建成功，如果想看更详细的内容，可以点击[这里](http://demo.pythoner.com/itt2zh/index.html)

## 参考链接

 * [Tornado 主页](http://www.tornadoweb.org/)
 * [Tornado 中国镜像站点](http://www.tornadoweb.cn/)
 * [GitHub Project Page](http://wiki.github.com/facebook/tornado)
 * [Tornado Google Group](http://groups.google.com/group/python-tornado)
 * [Introduction to Tornado](http://demo.pythoner.com/itt2zh/index.html)
