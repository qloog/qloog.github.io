---
layout: post
title: Tornado RequestHandler和Application类
date: 2014-05-29 19:13:13
category: 收藏
tags: Tornado, 源码阅读
---


前面一小节提到了需要了解 web.py 这个文件，这个文件最关键的地方是定义了 Application 和 RequestHandler 类。我们再看看 Tornado 的 Hello World，我们再精简一下，下面是最简单的实例化并启动 Application 的方式：

	import ioloop
	import web
	
	application = web.Application([
	    (r'/', MainHandler),
	])
	application.listen(8888)
	ioloop.IOLoop.instance().start()

从代码里可以看到的是：应用里定义了 URI 路由和对应的处理类，并以此构建了application对象，然后让这个对象监听在8888端口，最后由 ioloop 单例进入循环，不断分发事件。

这里的URI路由就是r"/"，对应处理类就是 MainHandler，它们被放在同一个 tuple 里形成了关联。可以看到，application 是接受一个列表的，因此可以定义多个全局路由对应不同处理，往列表里 append 就是了。

如果只是在 tornado 的框架基础上进行开发，那就只需要不断定义不同的处理类，并把对应路由与其关联即可。

tornado.web 里的 RequestHandler 和 Application 类

Tornado 使用 web 模块的 Application 做URI转发，然后通过 RequestHandler 处理请求。 Application 提供了一个 listen 方法作为 HTTPServer 中的 listen 的封装。

初始化 Application 时，一般将处理器直接传入，它会调用 add_handlers 添加这些处理器，初始化还包括 transforms （分块、压缩等）、UI模块、静态文件处理器的初始化。 add_handlers 方法负责添加URI和处理器的映射。

Application 实现 URI 转发时使用了一个技巧，它实现了 `__call__` 方法，并将 Application 的实例传递给 HTTPServer ，当监听到请求时，它通过调用 Application 实例触发` __call__` 。 `__call__ `方法中完成具体的URI转发工作，并调用已注册的处理器的 _execute 方法，处理请求。

	def __call__(self, request):
	    transforms = [t(request) for t in self.transforms]
	    handler = None
	    args = []
	    kwargs = {}
	    handlers = self._get_host_handlers(request) # 取得请求的host的一组处理器
	    if not handlers:
	        handler = RedirectHandler(
	            self, request, url="http://" + self.default_host + "/")
	    else:
	        for spec in handlers:
	            match = spec.regex.match(request.path)  # 匹配请求的URI
	            if match:
	                handler = spec.handler_class(self, request, **spec.kwargs) # 实例化
	                if spec.regex.groups:   # 取得参数
	                    ...
	                    if spec.regex.groupindex:
	                        kwargs = dict(
	                            (str(k), unquote(v))
	                            for (k, v) in match.groupdict().iteritems())
	                    else:
	                        args = [unquote(s) for s in match.groups()]
	                break
	        if not handler:     # 无匹配
	            handler = ErrorHandler(self, request, status_code=404)
	    ...
	    handler._execute(transforms, *args, **kwargs)   # 处理请求
	    return handler

RequestHandler 完成具体的请求，开发者需要继承它，并根据需要，覆盖 head 、 get 、 post 、 delete 、 patch 、 put 、 options 等方法，定义处理对应请求的业务逻辑。

RequestHandler 提供了很多钩子，包括 initialize 、 prepare 、 on_finish 、 on_connection_close 、 set_default_headers 等等。

下面是 _execute 的处理流程：

RequestHandler 中涉及到很多 HTTP 相关的技术，包括 Header、Status、Cookie、Etag、Content-Type、链接参数、重定向、长连接等等，还有和用户身份相关的XSRF和CSRF等等。这方面的知识可以参考《HTTP权威指南》。

Tornado默认实现了几个常用的处理器：

 * ErrorHandler ：生成指定状态码的错误响应。
 * RedirectHandler ：重定向请求。
 * StaticFileHandler ：处理静态文件请求。
 * FallbackHandler ：使可以在Tornado中混合使用其他HTTP服务器。
 
上面提到了 transform ，Tornado 使用这种机制来对输出做分块和压缩的转换，默认给出了 GZipContentEncoding 和 ChunkedTransferEncoding 。也可以实现自定义的转换，只要实现 transform_first_chunk 和 transform_chunk 接口即可，它们由 RequestHandler 中的 flush 调用。