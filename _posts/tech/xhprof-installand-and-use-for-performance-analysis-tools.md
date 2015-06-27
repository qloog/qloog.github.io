Title: XHProf安装及其使用-PHP性能分析工具
Date: 2012-07-01 15:35:22
Tags: PHP, XHProf

XHProf是一个分层PHP性能分析工具。它报告函数级别的请求次数和各种指标，包括阻塞时间，CPU时间和内存使用情况。一个函数的开销，可细分成调用者和被调用者的开销，XHProf数据收集阶段，它记录调用次数的追踪和包容性的指标弧在动态callgraph的一个程序。它独有的数据计算的报告/后处理阶段。在数据收集时，XHProfd通过检测循环来处理递归的函数调用，并通过给递归调用中每个深度的调用一个有用的命名来避开死循环。XHProf分析报告有助于理解被执行的代码的结构，它有一个简单的HTML的用户界面（ PHP写成的）。基于浏览器的性能分析用户界面能更容易查看，或是与同行们分享成果。也能绘制调用关系图。 XHProf是facebook开源出来的一个php轻量级的性能分析工具，跟Xdebug类似，但性能开销更低，还可以用在生产环境中，也可以由程序开 关来控制是否进行profile。 以下是记录和总结： 安装xhprof： 
    
    
    wget http://pecl.php.net/get/xhprof-0.9.2.tgz
    tar zxf xhprof-0.9.2.tgz
    cd xhprof-0.9.2
    cp -r xhprof_html xhprof_lib /www/www.lnmp.com/xhprof/
    cd extension/
    /usr/local/webserver/php/bin/phpize
    ./configure  --with-php-config=/usr/local/webserver/php/bin/php-config
    make && make install

安装完提示： Installing shared extensions:     /usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20060613/ php.ini中添加 extension_dir = "/usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20060613/" 这句我原来就有了，就这用添加下面两句 extension=xhprof.so xhprof.output_dir=/www/logs/xhprof 分析日志输出在/www/logs/xhprof目录。
    
    
    chmod 755 /www/logs/xhprof
    chmod www:www /www/logs/xhprof

重新加载php配置文件和重启web /usr/local/webserver/php/sbin/php-fpm reload /usr/local/webserver/nginx/sbin/nginx -s reload 刷新phpinfo页面，看到输出中有了xhprof信息。 xhprof  0.9.2 CPU num  2 安装graphviz，一个画图工具 
    
    
    wget http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.24.0.tar.gz
    tar zxf graphviz-2.24.0.tar.gz
    cd graphviz-2.24.0
    ./configure
    make && make install

程序试例 头部： 
    
    
    xhprof_enable(); 
    //xhprof_enable(XHPROF_FLAGS_NO_BUILTINS); 不记录内置的函数
    //xhprof_enable(XHPROF_FLAGS_CPU + XHPROF_FLAGS_MEMORY);  同时分析CPU和Mem的开销
    $xhprof_on = true;

我觉得用xhprof_enable();就够用了，只统计运行时间(Wall Time)。 生产环境可使用： if (mt_rand(1, 10000) == 1) { xhprof_enable(); $xhprof_on = true; } 尾部： 
    
    
    if($xhprof_on){
    $xhprof_data = xhprof_disable();
    $xhprof_root = '/www/www.hx.com/xhprof/';
    include_once $xhprof_root."xhprof_lib/utils/xhprof_lib.php"; 
    include_once $xhprof_root."xhprof_lib/utils/xhprof_runs.php"; 
    $xhprof_runs = new XHProfRuns_Default(); 
    $run_id = $xhprof_runs->save_run($xhprof_data, "hx");
    echo '<a href="http://192.168.1.158:858/xhprof/xhprof_html/index.php?run='.$run_id.'&source=hx" target="_blank">统计</a>';
    }

运行程序，底部出现统计字样，点过去就可以看到性能分析了。按运行时间排序，很容易找出化时间最长的函数。 点[View Full Callgraph]图形化显示，最大的性能问题会用红色标出，其次是黄色，很明显。 ![](http://lnmp100.b0.upaiyun.com/2012/07/xhprof_test-300x147.jpg)   参考资料：<http://www.162cm.com/p/xhprofdoc.html#overview>
