Title: iframe页面里的js调用父级页面js函数的解决方法
Date: 2011-12-28 15:20:11
Tags: iframe


通过iframe页面的js调用父级页面的js函数也是比较常用的一种方法，曾用过起码3次以上，这次竟然为了调用父级页面的回调函数又折腾了好久，为了加深记忆，现总结如下。

1、假设当前页面为a.html, iframe的src页面为b.html,其代码如下： 
    
    
    <html>
    <head>
    <title>iframe页面里的js调用父级页面js函数的demo</title>
    </head>
    
    <body>
    <p>iframe页面里的js调用父级页面js函数的demo</p>
    <iframe frameborder="0" width="0" height="0" name="test" src="b.html"></iframe>
    </body>
    <script type="text/javascript">
    exec_success_callback(){}
    </script>
    </html>

2、b.html里的页面元素为： 
    
    
    <script type='text/javascript'>
    	window.parent.document.getElementById('父级页面ID').innerHTML = '内容';
    	window.parent.exec_success_callback();
    </script>

说明： 1、通过 window.parent.document.getElementById('父级页面ID').innerHTML = '内容'  基本可以达到控制父级页面的元素 2、window.parent.login_success_callback()  可以调用父级页面的Js函数来处理一些事情 3、关键是用到了 window.parent