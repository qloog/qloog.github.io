---
layout: post
title: Mac下安装LNMP环境
category: 技术
date: 2015-07-30
tags: Mac LNMP
---

* This will become a table of contents (this text will be scraped).
{:toc}

Mac下搭建lamp开发环境很容易，有xampp和mamp现成的集成环境。但是集成环境对于经常需要自定义一些配置的开发者来说会非常麻烦，而且Mac本身自带apache和php，在brew的帮助下非常容易手动搭建，可控性很高。

## Brew

brew对于mac，就像apt-get对于ubuntu，安装软件的好帮手，能方便更多...

brew的安装方式如下：

	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

之后就可以使用 `brew` 来安装所需要的依赖了。

brew（意为酿酒）的命名很有意思，全部都使用了酿酒过程中采用的材料/器具，名词对应以下的概念：

 * Formula（配方） 程序包定义，本质上是一个rb文件
 * Keg（桶）程序包的安装路径
 * Cellar（地窖）所有程序包（桶）的根目录
 * Tap（水龙头）程序包的源
 * Bottle （瓶子）编译打包好的程序包

最终编译安装完毕的程序就是一桶酿造好的酒

更详细的信息参考[Homebrew的官方Cookbook](https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Formula-Cookbook.md)

因此使用Homebrew常见的流程是：

 1. 增加一个程序源（新增一个水龙头） `brew tap homebrew/php`
 2. 更新程序源 `brew update`
 3. 安装程序包（按照配方酿酒） `brew install git`
 4. 查看配置 `brew config` 可以看到程序包默认安装在 `/usr/local/Cellar` 下 （酒桶放在地窖内）

brew常用选项

	brew install xxx
	brew uninstall xxx
	brew list
	brew update xxx

还有一个必须要安装的就是os x 自身的命令行开发工具，否则后面的安装也会出问题。

	xcode-select --install  # 弹窗提示后，点击“安装”即可

## Apache || Nginx

### Apache

Apache的话使用mac自带的基本就够了，我的系统是10.9+，可以使用以下命令控制Apache

	sudo apachectl start
	sudo apachectl restart
	sudo apachectl stop

唯一要改的是主目录，mac默认在home下有个sites（站点）目录，访问路径是

	http://localhost/~user_name

这样很不适合做开发用，修改/etc/apache2/httpd.conf内容

	DocumentRoot "/Users/username/Sites"
	<Directory />
	    Options Indexes MultiViews
	    AllowOverride All
	    Order allow,deny
	    Allow from all
	</Directory>

这样sites目录就是网站根目录了，代码都往这个下头丢

### Nginx(推荐)

要使用Nginx也比较方便，首先安装

	brew install nginx

#### Nginx启动关闭命令：

	#测试配置是否有语法错误
	nginx -t

	#打开 nginx （如果想要监听80端口，必须以管理员身份运行）
	sudo nginx

	#重新加载配置|重启|停止|退出 nginx
	nginx -s reload|reopen|stop|quit

	#也可以使用Mac的launchctl来启动|停止
	launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
	launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist


#### Nginx开机启动

	mkdir -p ~/Library/LaunchAgents
	ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents

#### Nginx监听80端口需要root权限执行

	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
	sudo chown root:wheel ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist

update:

	2015-03-30 :

	after upgrading from Mavericks to Yosemite I got the following error:

		/usr/local/var/run/nginx.pid failed (2 no such file or directory)
		nginx: [emerg] mkdir() "/usr/local/var/run/nginx/client_body_temp" failed (2: No such file or directory)


	All I needed to do to solve this issue was to create the folder:

		mkdir -p /usr/local/var/run/nginx/client_body_temp


	OK, 升级碰到的问题解决。

检查是否run起来：

	http://localhost:8080  或者  http://localhost:80

#### 配置Nginx

	cd /usr/local/etc/nginx/
	mkdir conf.d

修改Nginx配置文件

	#配置文件地址 /usr/local/etc/nginx/nginx.conf
	vim nginx.conf

主要修改位置是最后的include

	worker_processes  1;

	error_log       /usr/local/var/log/nginx/error.log warn;

	pid        /usr/local/var/run/nginx.pid;

	events {
	    worker_connections  256;
	}

	http {
	    include       mime.types;
	    default_type  application/octet-stream;

	    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
	                      '$status $body_bytes_sent "$http_referer" '
	                      '"$http_user_agent" "$http_x_forwarded_for"';

	    access_log      /usr/local/var/log/nginx/access.log main;
	    port_in_redirect off;
	    sendfile        on;
	    keepalive_timeout  65;

	    include /usr/local/etc/nginx/conf.d/*.conf;
	}

#### 修改自定义文件

	vim ./conf.d/default.conf

#### 增加一个监听端口

	server {
	    listen       80;
	    server_name  localhost;

	    root /Users/username/Sites/; # 该项要修改为你准备存放相关网页的路径

	    location / {
	        index index.php;
	        autoindex on;
	    }

	    #proxy the php scripts to php-fpm
	    location ~ \.php$ {
	        include /usr/local/etc/nginx/fastcgi.conf;
	        fastcgi_intercept_errors on;
	        fastcgi_pass   127.0.0.1:9000;
	    }

	}

这个时候还不能访问php站点，因为还没有开启php-fpm。继续PHP的安装...

## PHP

PHP在mac下默认安装了，但是不好控制版本，利用brew可以再mac下安装最新版本，甚至是多个版本，我装了php5.5

	brew install php55 --without-apache --with-fpm --with-mysql  #for Nginx
	#brew install php55 #for Apache

PS: 如果在编译过程中出现类似以下问题：

	==> ./configure --prefix=/usr/local/Cellar/php55/5.5.32 --localstatedir=/usr/local/var --sysconfdir=
	Last 15 lines from /Users/qloog/Library/Logs/Homebrew/php55/01.configure:
	checking for Kerberos support... /usr
	checking for krb5-config... /usr/bin/krb5-config
	checking for DSA_get_default_method in -lssl... no
	checking for X509_free in -lcrypto... yes
	checking for RAND_egd... no
	checking for pkg-config... no
	checking for OpenSSL version... >= 0.9.6
	checking for CRYPTO_free in -lcrypto... yes
	checking for SSL_CTX_set_ssl_version in -lssl... yes
	checking for PCRE library to use... bundled
	checking whether to enable the SQLite3 extension... yes
	checking bundled sqlite3 library... yes
	checking for ZLIB support... yes
	checking if the location of ZLIB install directory is defined... no
	configure: error: Cannot find libz

	READ THIS: https://git.io/brew-troubleshooting
	If reporting this issue please do so at (not Homebrew/homebrew):
	  https://github.com/josegonzalez/homebrew-php/issues

主要是 `configure: error: Cannot find libz` 错误，执行 `xcode-select --install` 重新安装一下Xcode Command Line Tools
在[GitHub HomeBrew](https://github.com/Homebrew/homebrew-php/issues/1181)上有关于这个讨论:

	For future reference of anybody looking for Command Line Tools with Xcode 5, open up a Terminal window and type
	xcode-select  --install. A window will appear informing you command line tools are required. Click Install and
	you should be good to go

安装成功后提示：

	＃To have launchd start php55 at login:
    	mkdir -p ~/Library/LaunchAgents
    	ln -sfv /usr/local/opt/php55/*.plist ~/Library/LaunchAgents

	＃Then to load php55 now:
    	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php55.plist

等待PHP编译完成，开始安装PHP常用扩展，扩展安装过程中brew会自动安装依赖包，例如php55-pdo-pgsql 会自动装上postgresql,这里我安装以下PHP扩展：

	brew install php55-memcache
	brew install php55-memcached
	brew install php55-redis
	brew install php55-mongo
	brew install php55-xdebug
	brew install php55-mcrypt    #Laravel 框架依赖此扩展
	brew install php55-xhprof    #php性能分析工具
	brew install php55-gearman
	brew install php55-msgpack
	brew install php55-phalcon   #一个是C语言写的PHP框架


由于Mac自带了php和php-fpm，因此需要添加系统环境变量PATH来替代自带PHP版本。

	echo 'export PATH="$(brew --prefix php55)/bin:$PATH"' >> ~/.bash_profile  #for php
	echo 'export PATH="$(brew --prefix php55)/sbin:$PATH"' >> ~/.bash_profile  #for php-fpm
	echo 'export PATH="/usr/local/bin:/usr/local/sbib:$PATH"' >> ~/.bash_profile #for other brew install soft
	source ~/.bash_profile
	#或者
	source ~/.zshrc

测试一下效果：

	#brew安装的php 他在/usr/local/opt/php55/bin/php
	php -v
	HP 5.5.32 (cli) (built: Mar  3 2016 14:07:53)
	Copyright (c) 1997-2015 The PHP Group
	Zend Engine v2.5.0, Copyright (c) 1998-2015 Zend Technologies
	    with Xdebug v2.2.5, Copyright (c) 2002-2014, by Derick Rethans

	#Mac自带的PHP
	/usr/bin/php -v
	PHP 5.5.30 (cli) (built: Oct 23 2015 17:21:45)
	Copyright (c) 1997-2015 The PHP Group
	Zend Engine v2.5.0, Copyright (c) 1998-2015 Zend Technologies

	#brew安装的php-fpm 他在/usr/local/opt/php55/sbin/php-fpm
	php-fpm -v
	PHP 5.5.32 (fpm-fcgi) (built: Mar  3 2016 14:07:54)
	Copyright (c) 1997-2015 The PHP Group
	Zend Engine v2.5.0, Copyright (c) 1998-2015 Zend Technologies
	    with Xdebug v2.2.5, Copyright (c) 2002-2014, by Derick Rethans

	#Mac自带的php-fpm
	/usr/sbin/php-fpm -v
	PHP 5.5.30 (fpm-fcgi) (built: Oct 23 2015 17:22:03)
	Copyright (c) 1997-2015 The PHP Group
	Zend Engine v2.5.0, Copyright (c) 1998-2015 Zend Technologies

修改php-fpm配置文件，`vim /usr/local/etc/php/5.5/php-fpm.conf`，找到pid相关大概在25行，去掉注释 pid = run/php-fpm.pid, 那么php-fpm的pid文件就会自动产生在 `/usr/local/var/run/php-fpm.pid`，Nginx pid文件也是放在这里的。

	#测试php-fpm配置
	php-fpm -t
	php-fpm -c /usr/local/etc/php/5.5/php.ini -y /usr/local/etc/php/5.5/php-fpm.conf -t

	#启动php-fpm
	php-fpm -D
	php-fpm -c /usr/local/etc/php/5.5/php.ini -y /usr/local/etc/php/5.5/php-fpm.conf -D

	#关闭php-fpm
	kill -INT `cat /usr/local/var/run/php-fpm.pid`

	#重启php-fpm
	kill -USR2 `cat /usr/local/var/run/php-fpm.pid`

	#也可以用上文提到的brew命令来重启php-fpm，不过他官方不推荐用这个命令了
	brew services restart php55

	#还可以用这个命令来启动php-fpm
	launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist

启动php-fpm之后，确保它正常运行监听9000端口：

	lsof -Pni4 | grep LISTEN | grep php
	php-fpm   79812 qloog    6u  IPv4 0xcee975aa333a6905      0t0  TCP 127.0.0.1:9000 (LISTEN)
	php-fpm   79859 qloog    0u  IPv4 0xcee975aa333a6905      0t0  TCP 127.0.0.1:9000 (LISTEN)
	php-fpm   80386 qloog    0u  IPv4 0xcee975aa333a6905      0t0  TCP 127.0.0.1:9000 (LISTEN)
	php-fpm   80387 qloog    0u  IPv4 0xcee975aa333a6905      0t0  TCP 127.0.0.1:9000 (LISTEN)
	php-fpm   80388 qloog    0u  IPv4 0xcee975aa333a6905      0t0  TCP 127.0.0.1:9000 (LISTEN)
	php-fpm   82068 qloog    0u  IPv4 0xcee975aa333a6905      0t0  TCP 127.0.0.1:9000 (LISTEN)
	#正常情况，会看到上面这些进程

PHP-FPM开机启动：

	ln -sfv /usr/local/opt/php55/*.plist ~/Library/LaunchAgents
	launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php55.plist

如果是apache就用刚刚安装的php代替了系统默认cli的php版本。然后在/etc/apache2/httpd.conf下增加

	LoadModule php5_module /usr/local/Cellar/php55/5.5.15/libexec/apache2/libphp5.so

这样就对apache使用的php版本也进行了修改。

## MySQL

mac不自带mysql，这里需要重新安装，方法依然很简单

	brew install mysql

安装后的提示：

	A "/etc/my.cnf" from another install may interfere with a Homebrew-built
	server starting up correctly.

	To connect:
	    mysql -uroot

	# 开机登录启动mysql
	To have launchd start mysql at login:
	    mkdir -p ~/Library/LaunchAgents
	    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
	# 手动开启mysql
	Then to load mysql now:
	    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
	#非launchctl开启方式
	Or, if you don't want/need launchctl, you can just run:
	    mysql.server start

最好给mysql设个密码，方法如下

	mysqladmin -u root password 'xxx'

如果想修改mysql的配置，在/usr/local/etc下建立一个my.cnf，例如增加log

	[mysqld]
	general-log
	general_log_file = /usr/local/var/log/mysqld.log

检查MySQL运行情况

	➜  ~ ps aux | grep mysql
	qloog             488   0.0  0.0  3121804   2712   ??  S    22Feb16   1:25.50 /usr/local/Cellar/mysql/5.6.20/bin/mysqld --basedir=/usr/local/Cellar/mysql/5.6.20 --datadir=/usr/local/var/mysql --plugin-dir=/usr/local/Cellar/mysql/5.6.20/lib/plugin --bind-address=127.0.0.1 --log-error=/usr/local/var/mysql/qloogdeMacBook-Pro.local.err --pid-file=/usr/local/var/mysql/qloogdeMacBook-Pro.local.pid

测试连接MySQL

	➜  ~ mysql -uroot -p
	Warning: Using a password on the command line interface can be insecure.
	Enter password:
	Welcome to the MySQL monitor.  Commands end with ; or \g.
	Your MySQL connection id is 43
	Server version: 5.6.20 Homebrew

	Copyright (c) 2000, 2014, Oracle and/or its affiliates. All rights reserved.

	Oracle is a registered trademark of Oracle Corporation and/or its
	affiliates. Other names may be trademarks of their respective
	owners.

	Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

	mysql>

## Memcache

	brew install memcached

启动/停止指令

	memcached -d
	killall memcached

加入开机启动

	ln -sfv /usr/local/Cellar/memcached/1.4.20/homebrew.mxcl.memcached.plist ~/Library/LaunchAgents/

## Redis

	brew install redis

Redis默认配置文件不允许以Deamon方式运行，因此需要先修改配置文件

	vim /usr/local/etc/redis.conf

将daemonize修改为yes，然后载入配置文件即可实现后台进程启动

	redis-server /usr/local/etc/redis.conf

加入开机启动

	ln -sfv /usr/local/Cellar/redis/2.8.19/homebrew.mxcl.redis.plist ~/Library/LaunchAgents/

## 设置别名

最后可以对所有服务的启动停止设置别名方便操作

	vim ~/.bash_profile (如果是zsh, vim ~/.zshrc)

加入

	alias nginx.start='launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
	alias nginx.stop='launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist'
	alias nginx.restart='nginx.stop && nginx.start'
	alias php-fpm.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist"
	alias php-fpm.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist"
	alias php-fpm.restart='php-fpm.stop && php-fpm.start'
	alias mysql.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
	alias mysql.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
	alias mysql.restart='mysql.stop && mysql.start'
	alias redis.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
	alias redis.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.redis.plist"
	alias redis.restart='redis.stop && redis.start'
	alias memcached.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
	alias memcached.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist"
	alias memcached.restart='memcached.stop && memcached.start'

然后执行

	source ~/.zshrc

## MongoDB

MongoDB可以说是最简单的一个，直接执行

	brew install mongodb

成功安装后的提示：

	#开机启动
	To have launchd start mongodb at login:
	    ln -sfv /usr/local/opt/mongodb/*.plist ~/Library/LaunchAgents
	#立刻运行
	Then to load mongodb now:
	    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mongodb.plist
	#如果不想加入到开机启动，也可以收到运行
	Or, if you don't want/need launchctl, you can just run:
	    mongod --config /usr/local/etc/mongod.conf

## PHPMyAdmin

phpmyadmin几乎是管理mysql最容易的web应用了吧，每次我都顺道装上。

去官网下载最新的版本
 - 解压到~/Sites/phpmyadmin下
 - 在phpmyadmin目录下创建一个可写的config目录
 - 打开http://localhost/phpmyadmin/setup，安装一个服务，最后保存（这里只需要输入帐号密码就够了）
 - 将config下生成的config.inc.php移到phpmyadmin根目录下
 - 删除config
这样就装好了，虽然可能有点小复杂，但是来一次就习惯了。

这里很可能会遇到2002错误，就是找不到mysql.sock的问题，用下面方法解决

	sudo mkdir /var/mysql
	sudo ln -s /tmp/mysql.sock /var/mysql/mysql.sock

## RockMongo

RockMongo是MongoDB很好用的一个web应用，安装也很容易

 - 去官网下载最新版本
 - 解压到~/Sites/rockmongo下
 - 运行http://localhost/rockmongo即可
完成
这样就在mac下配置好一个php开发环境了，enjoy it!

参考:

 * [Hot to install nginx, PHP-fpm 5.5.6, mongo and MySql on mac with homebrew](http://www.nabito.net/hot-to-install-nginx-php-fpm-5-5-6-mongo-and-mysql-on-mac-with-homebrew/)
 * [Install NGINX, PHP-FPM (5.5.6), Mongo and MySql](https://gist.github.com/OzzyCzech/7658282)
 * [Install Nginx, PHP-FPM, MySQL and phpMyAdmin on OS X Mavericks using Homebrew](http://blog.frd.mn/install-nginx-php-fpm-mysql-and-phpmyadmin-on-os-x-mavericks-using-homebrew/)
 * [Mac下用brew搭建PHP(LNMP/LAMP)开发环境](http://yansu.org/2013/12/11/lamp-in-mac.html)
 * [Install Nginx, PHP-FPM, MySQL and phpMyAdmin on OS X Mavericks or Yosemite](http://blog.frd.mn/install-nginx-php-fpm-mysql-and-phpmyadmin-on-os-x-mavericks-using-homebrew/)
