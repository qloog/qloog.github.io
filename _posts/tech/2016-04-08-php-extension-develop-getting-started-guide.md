---
layout: post
title: PHP的C扩展开发入门指南
category: tech
date: 2016-04-08
tags: C PHP扩展
---

* This will become a table of contents (this text will be scraped).
{:toc}

## 为什么要用C扩展

C是静态编译的，执行效率比PHP代码高很多。同样的运算代码，使用C来开发，性能会比PHP要提升数百倍。IO操作如CURL，因为耗时主要在IOWait上，C扩展没有明显优势。

另外C扩展是在进程启动时加载的，PHP代码只能操作Request生命周期的数据，C扩展可操作的范围更广。


## 源码下载

##### From PHP官网

	http://php.net/downloads.php

##### From Git

	git clone https://github.com/php/php-src.git

##### From `git.php.net`

	git clone http://git.php.net/repository/php-src.git

##### From Github

 1. 打开 [php-src project page](https://github.com/php/php-src)
 2. 选择感兴趣的分支
 3. 点击 `Download ZIP` 即可

这里以zip为例：

	wget http://museum.php.net/php5/php-5.3.16.tar.gz
	tar zxvf php-5.3.16.tar.gz
	mv php-5.3.16 php-src

进入到PHP源码目录：

	cd php-src

> 若使用 Git
> 好处是方便切换不同版本
>
>	git clone http://git.php.net/repository/php-src.git
>
>	PHP 5.4: git checkout PHP-5.4
>	PHP 5.5: git checkout PHP-5.5
>	PHP 5.6: git checkout PHP-5.6
>	PHP 7.0: git checkout PHP-7.0
>	PHP HEAD: git checkout master

## 生成扩展

	cd ext


#### 第一步

生成PHP扩展骨架：

	./ext_skel --extname=myext

> ext_skel是PHP官方提供的用于生成php扩展骨架代码的工具

成功创建完基本文件之后会提示如下：

	Creating directory myext
	Creating basic files: config.m4 config.w32 .svnignore myext.c php_myext.h CREDITS EXPERIMENTAL tests/001.phpt myext.php [done].

	To use your new extension, you will have to execute the following steps:

	1.  $ cd ..
	2.  $ vi ext/myext/config.m4
	3.  $ ./buildconf
	4.  $ ./configure --[with|enable]-myext
	5.  $ make
	6.  $ ./php -f ext/myext/myext.php
	7.  $ vi ext/myext/myext.c
	8.  $ make

	Repeat steps 3-6 until you are satisfied with ext/myext/config.m4 and
	step 6 confirms that your module is compiled into PHP. Then, start writing
	code and repeat the last two steps as often as necessary.

> 如果退到php-src根目录，make时会重新编译所有扩展模块，比较费时，所以建议进入到扩展目录编译


查看生成的文件：

	tree myext
	|-- CREDITS
	|-- EXPERIMENTAL
	|-- config.m4
	|-- config.w32
	|-- myext.c
	|-- myext.php
	|-- php_myext.h
	`-- tests
	    `-- 001.phpt

	1 directory, 8 files

> config.m4是AutoConf工具的配置文件，用来修改各种编译选项。

#### 第二步

修改 config.m4

	cd ..
	vi ext/myext/config.m4

将

	dnl PHP_ARG_WITH(myext, for myext support,
	dnl Make sure that the comment is aligned:
	dnl [  --with-myext             Include myext support])

修改为

	PHP_ARG_WITH(myext, for myext support,
	[  --with-myext             Include myext support])

> 下边还有一个 –-enable-myext，是表示编译到php内核中。with是作为动态链接库载入的。

#### 第三步

修改 `php_myext.h`，在45行找到`PHP_FUNCTION(confirm_myext_compiled)`, 这里就是扩展函数声明部分;
可以增加一行 `PHP_FUNCTION(myext_helloworld);`, 表示声明了一个myext_helloworld的扩展函数。

#### 第四步

修改 `myext.c`, 这个是扩展函数的实现部分
在42行之后， 加入 `PHP_FE(myext_helloworld,  NULL)`

	const zend_function_entry myext_functions[] = {
	    PHP_FE(confirm_myext_compiled,  NULL)       /* For testing, remove later. */
	    PHP_FE(myext_helloworld,  NULL)
	    PHP_FE_END  /* Must be the last line in myext_functions[] */
	};

> 这的代码是将函数指针注册到Zend引擎，增加一行PHP_FE(myext_helloworld,  NULL)（后面不要带分号）。

#### 第五步

在`myext.c`末尾加myext_helloworld的执行代码。

	PHP_FUNCTION(myext_helloworld)
	{
	    char *arg = NULL;
		int arg_len, len;
		char *strg;
		if (zend_parse_parameters(ZEND_NUM_ARGS() TSRMLS_CC, "s", &arg, &arg_len) == FAILURE) {
			return;
		}
		php_printf("Hello World!\n");
		RETURN_TRUE;
	}

> `zend_parse_parameters`是用来接受PHP传入的参数，RETURN_XXX宏是用来返回给PHP数据。


#### 第六步

在myext目录下依次执行：

	phpize
	./configure
	make
	make install

> 如果执行 `./configure` 时出现此错误： configure: error: Cannot find php-config. Please use Cwith-php-config=PATH
> 说明php-config配置文件不在缺省目录里， 重新执行： `./configure --with-php-config=/usr/local/php/bin/php-config` 节课
> 这个文件通常是在PHP的安装目录的bi目录下的一个叫做`php-config`或者`php-config5`的文件

然后修改php.ini加入 `extension = "myext.so"`

#### 第七步

通过执行 `php -r "myext_helloworld('test');"` 验证扩展是否成功加载，如果成功则输出 `hello world!`

## 参考

 * [http://php.net/git.php](http://php.net/git.php)
 * [http://rango.swoole.com/archives/152](http://rango.swoole.com/archives/152)
