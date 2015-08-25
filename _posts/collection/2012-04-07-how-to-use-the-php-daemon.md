---
layout: post
title: (转)如何利用PHP做守护进程
date: 2012-04-07 19:29:46
category: 收藏
tags: PHP, 守护进程
---

## 起源
Linux/Unix下守护进程（Daemon）大家都知道，比如我们常用的httpd、mysqld等等，就是常驻内存运行的程序，类似于Windows下的服务。一般守护进程都是使用C/C++来写，就是通过fork生成子进程，当前台shell下的父进程被杀掉，子进程就转到后台运行，为了不在终端产生输出信息，就通过syslog等函数来写日志文件。
我们知道php是脚本语言，通过php的脚本引擎来执行，所以要做成守护进程比较麻烦，我们今天就来结合Unix/Linux的命令来实现我们守护进程的功能。

## 原理
Unix中的nohup命令的功能就是不挂断地运行命令，同时nohup把程序的所有输出到放到当前目录的nohup.out文件中，如果文件不可写，则放到<用户主目录>/nohup.out 文件中。那么有了这个命令以后，我们的php程序就写程shell脚本，使用循环来让我们的脚本一直运行，那么不管我们终端窗口是否关闭，都能够让我们的php脚本一直运行。当然，当我们的php进程被杀或者我们的操作系统重启了，自然就会中止了。

## 功能
肯定会问，让我们的php脚本做了守护进程又有什么用处呢？当然有，比如最典型的作用，能够基本的替代cron的功能，比如我们需要定期实行的某些操作，完全可以交给它来做，不再需要cron，当然，如果服务器重启就没有办法了，不过，一般的Unix服务器不是那么容易重启的。另外，我们还可以做一个简单的服务器端的功能，比如做一个能够Telnet过去的服务器，嘿嘿，可以做成一个小后门，不过这样实现稍微有点复杂。

## 实践
###例子一：自动生成文件
我们现在来做两个例子来证明我们上面的说法。首先第一个是每个三十秒自动生成一个文件，永远执行下去。
首必须确保操作系统是Unix或者Linux，比如可以是FreeBSD、Redhat、Fedora或者SUSE什么的。然后我们必须确保我们的php脚本引擎是在 /usr/local/php/bin/php，具体路径可以按照你实际路径来写，如果没有脚本引擎，请自行安装。
比如当前目录是 /home/heiyeluren/，那么我们使用vi或者其他编辑器编写一个叫做php_daemon1.php的文件：

	$ vi php_daemon1.php
	
然后写入如下代码：

	#! /usr/local/php/bin/php
	<?
	set_time_limit(0);
	while(1)
	{
	@fopen(“test_”.time().”.txt”,”w”);
	sleep(30);
	}
	?>
	
然后保存并且退出vi，然后赋予php_daemon1.php文件可执行权限：

	$ chmod +x /home/heiyeluren/php_daemon1.php
	
然后再让我们的脚本再后台执行，执行如下命令：

	$ nohup /home/heiyeluren/php_daemon1.php &
	
记得最后加上 & 符号，这样才能够跑到后台去运行，执行上述命令后出现如下提示：

	[1] 82480
	appending output to nohup.out
	
再回后车后将出现shell提示符。那么上面的提示就是说，所有命令执行的输出信息都会放到 nohup.out 文件中，这个上面已经讲了。然后执行上面命令后，我们每个三十秒在当前目录就会看到多出以test_开头的文件，比如：test_1139901144.txt test_1139901154.txt等等文件，那么就证明我们的程序已经再后台运行了。
那么我们如何终止程序的运行呢？最好办法就是重启操作系统，呵呵，当然，这是不可取的，我们可以使用kill命令来杀掉这个进程，杀进程之前自然后知道进程的PID号，就是Process ID，使用ps命令就能够看到了。

	$ ps
	PID  TT  STAT      TIME COMMAND
	82374  p3  Ss     0:00.14 -bash (bash)
	82510  p3  S      0:00.06 /usr/local/php/bin/php /home/heiyeluren/php_daemon1.php
	82528  p3  R+     0:00.00 ps
	
上面我们已经看到了我们的php的进程id是：82510 ，于是我们再执行kill命令：

	$ kill -9 82510
	[1]+  Killed                  nohup /home/heiyeluren/php_daemon1.php
	
看到这么提示就明白这个进程被杀了，再ps，就会发现没有了：

	$ ps
	PID  TT  STAT      TIME COMMAND
	82374  p3  Ss     0:00.17 -bash (bash)
	82535  p3  R+     0:00.00 ps
	
如果直接ps命令无法看到进程，那么就使用 ps & apos 两个结合命令来查看，一定能够看到进程。
再上面的基础上进程扩展，能够做成属于自己的cron程序，那就不需要cron啦，当然，这只是一种方式

###例子二：服务器端的守护进程
这个例子跟网络有关，大致就是模拟使用php做服务器端，然后一直后台运行，达到服务器端Daemon的效果。
继续在我们的主目录下：/home/heiyeluren，编辑文件php_daemon2.php：

	$ vi php_daemon2.php
	
输入如下代码（代码来自PHP手册，我进行了修改注释）：

	#! /usr/local/php/bin/php
	<?php
	/* 设置不显示任何错误 */
	error_reporting(0);
	/* 脚本超时为无限 */
	set_time_limit(0);
	/* 开始固定清除 */
	ob_implicit_flush();
	/* 本机的IP和需要开放的端口 */
	$address = ’192.168.0.1′;
	$port = 10000;
	/* 产生一个Socket */
	if (($sock = socket_create(AF_INET, SOCK_STREAM, SOL_TCP)) < 0) {
	echo “socket_create() failed: reason: ” . socket_strerror($sock) . “\n”;
	}
	/* 把IP地址端口进行绑定 */
	if (($ret = socket_bind($sock, $address, $port)) < 0) {
	echo “socket_bind() failed: reason: ” . socket_strerror($ret) . “\n”;
	}
	/* 监听Socket连接 */
	if (($ret = socket_listen($sock, 5)) < 0) {
	echo “socket_listen() failed: reason: ” . socket_strerror($ret) . “\n”;
	}
	/* 永远循环监接受用户连接 */
	do {
	if (($msgsock = socket_accept($sock)) < 0) {
	echo “socket_accept() failed: reason: ” . socket_strerror($msgsock) . “\n”;
	break;
	}
	/* 发送提示信息给连接上来的用户 */
	$msg = “==========================================\r\n” .
	” Welcome to the PHP Test Server. \r\n\r\n”.
	” To quit, type ‘quit’. \r\n” .
	” To shut down the server type ‘shutdown’.\r\n” .
	” To get help message type ‘help’.\r\n” .
	“==========================================\r\n” .
	“php> “;
	socket_write($msgsock, $msg, strlen($msg));
	do {
	if (false === ($buf = socket_read($msgsock, 2048, PHP_NORMAL_READ))) {
	echo “socket_read() failed: reason: ” . socket_strerror($ret) . “\n”;
	break 2;
	}
	if (!$buf = trim($buf)) {
	continue;
	}
	/* 客户端输入quit命令时候关闭客户端连接 */
	if ($buf == ‘quit’) {
	break;
	}
	/* 客户端输入shutdown命令时候服务端和客户端都关闭 */
	if ($buf == ‘shutdown’) {
	socket_close($msgsock);
	break 2;
	}
	/* 客户端输入help命令时候输出帮助信息 */
	if ($buf == ‘help’) {
	$msg = ” PHP Server Help Message \r\n\r\n”.
	” To quit, type ‘quit’. \r\n” .
	” To shut down the server type ‘shutdown’.\r\n” .
	” To get help message type ‘help’.\r\n” .
	“php> “;
	socket_write($msgsock, $msg, strlen($msg));
	continue;
	}
	/* 客户端输入命令不存在时提示信息 */
	$talkback = “PHP: unknow command ‘$buf’.\r\nphp> “;
	socket_write($msgsock, $talkback, strlen($talkback));
	echo “$buf\n”;
	} while (true);
	socket_close($msgsock);
	} while (true);
	/* 关闭Socket连接 */
	socket_close($sock);
	?>
	
保存以上代码退出。
上面的代码大致就是完成一个类似于Telnet服务器端的功能，就是当服务器端运行该程序的时候，客户端能够连接该服务器的10000端口进行通信。
加上文件的可执行权限：

	$ chmod +x /home/heiyeluren/php_daemon2.php
	
在服务器上执行命令：

	$ nohup /home/heiyeluren/php_daemon2.php &
	
就进入了后台运行，我们通过Windows的客户端telnet上去：

	C:\>telnet 192.168.0.1 10000
	
如果提示：
正在连接到192.168.0.188…不能打开到主机的连接， 在端口 10000: 连接失败
则说明服务器端没有开启，或者上面的程序没有正确执行，请检查php是否 –enable-sockets 功能。

如果提示：

	Welcome to the PHP Test Server.
	To quit, type ‘quit’.
	To shut down the server type ‘shutdown’.
	To get help message type ‘help’.
	php>
	
则说明顺利连接上了我们的PHP写的服务器端守护进程，在php>提示符后面能够执行help、quit、shutdown等三个命令，如果命令输入不是这三个，则提示：

	php> asdf
	PHP: unknow command ‘asdf’.
	
执行help命令可以获取帮助：

	php> help
	PHP Server Help Message
	To quit, type ‘quit’.
	To shut down the server type ‘shutdown’.
	To get help message type ‘help’.
	
这个服务器端就不介绍了，可以自行扩展。杀进程跟例子一类似。

## 总结
通过以上学习，我们知道php也可以做守护进程，如果设计的好，功能也会比较强大，不过我们这里只是学习而已，可以自行研究更新。
本文参考了php中文手册，多看手册，对自己非常有好处。
 
## 原文链接：
<http://hi.baidu.com/lei_com/blog/item/d4293b10045f3be4c2ce796d.html>

