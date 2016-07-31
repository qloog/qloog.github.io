---
layout: post
title: MAC上通过brew安装PHP7
date: 2016-07-31 16:31
category: 技术
tags: PHP7
---

* This will become a table of contents (this text will be scraped).
{:toc}

最近几年一直在LNMP环境下进行开发，其中的PHP还是5.5版本，有点老旧，去年12月PHP7已经正式发布，新增了一些语法特性，最大的亮点是性能的提升，所以一直想升级到PHP7,由于时间关系一直拖到现在。到写本文为止PHP最新版本为：7.0.9的stable，所以稳定性上基本不用担心。

之前写的 [MAC下安装LNMP环境](/2015/07/30/install-lnmp-in-mac.html) 是用brew安装的，这次升级PHP7继续使用brew, 安装/升级软件很方便。

## 升级brew

	brew update
	
## 配置

```
brew tap homebrew/dupes
brew tap homebrew/versions  
brew tap homebrew/homebrew-php
```
	
## 安装PHP7

	brew install php70
	
## 遇到的问题

安装提示：

```
➜  ~ brew install php70
==> Installing php70 from homebrew/php
Error: Cannot install homebrew/php/php70 because conflicting formulae are installed.

  php55: because different php versions install the same binaries.

Please `brew unlink php55` before continuing.

Unlinking removes a formula's symlinks from /usr/local. You can
link the formula again after the install finishes. You can --force this
install, but the build may fail or cause obscure side-effects in the
resulting software.
```

根据提示执行： `brew unlink php55`  
继续安装: `brew install php70`

## 配置文件

安装好后生成的配置文件都在 `/usr/local/etc/php/7.0` 目录里，分别如下：  

php.ini	`/usr/local/etc/php/7.0/php.ini `  
php-fpm.conf `/usr/local/etc/php/7.0/php-fpm.conf`  
php, phpize, php-config `ls /usr/local/opt/php70/bin`  
php-fpm `/usr/local/opt/php70/sbin/php-fpm`

## 加入开机启动

```
mkdir -p ~/Library/LaunchAgents
ln -sfv /usr/local/opt/php70/homebrew.mxcl.php70.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php70.plist
```

## 命令行配置

`vim ~/.zshrc`   
将  
`export PATH="$(brew --prefix php55)/bin:$PATH"`  
替换为  
`export PATH="$(brew --prefix homebrew/php/php70)/bin:$PATH"`

```
alias php-fpm.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55.plist"
alias php-fpm.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php5.plist"
alias php-fpm.restart='php-fpm.stop && php-fpm.start'
```
修改为   

```
alias php-fpm.start="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php70.plist"
alias php-fpm.stop="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.php70.plist"
alias php-fpm.restart='php-fpm.stop && php-fpm.start'
```

重新加载配置文件

```
source ~/.zshrc
```

## 验证版本

PHP版本

```
➜  ~ /usr/local/opt/php70/bin/php -v
PHP 7.0.9 (cli) (built: Jul 21 2016 14:50:47) ( NTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies
```

php-fpm版本

```
➜  ~ /usr/local/opt/php70/sbin/php-fpm -v
PHP 7.0.9 (fpm-fcgi) (built: Jul 21 2016 14:50:51)
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies
```

## 启动PHP-FPM

执行： `php-fpm.start`

检查是否启动成功：

```
➜  ~ ps aux|grep php-fpm
qloog           60380   0.2  0.0  2432792    604 s001  R+    6:00PM   0:00.00 grep --color=auto --exclude-dir=.bzr --exclude-dir=CVS --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn php-fpm
qloog           60378   0.0  0.0  2473348    620   ??  S     6:00PM   0:00.00 /usr/local/opt/php70/sbin/php-fpm --fpm-config /usr/local/etc/php/7.0/php-fpm.conf
qloog           60377   0.0  0.0  2473348    648   ??  S     6:00PM   0:00.00 /usr/local/opt/php70/sbin/php-fpm --fpm-config /usr/local/etc/php/7.0/php-fpm.conf
qloog           60372   0.0  0.0  2475396   7844   ??  S     6:00PM   0:00.03 /usr/local/opt/php70/sbin/php-fpm --fpm-config /usr/local/etc/php/7.0/php-fpm.conf
```

## 安装扩展

### yaf

`brew install php70-yaf`

配置文件  
`/usr/local/etc/php/7.0/conf.d/ext-yaf.ini`


### memcached

`brew install php70-memcached`

配置文件  
`/usr/local/etc/php/7.0/conf.d/ext-memcached.ini`

### redis

`brew install php70-redis`

配置文件  
`/usr/local/etc/php/7.0/conf.d/ext-redis.ini`

### xdebug

`brew install php70-xdebug`

配置文件  
`/usr/local/etc/php/7.0/conf.d/ext-xdebug.ini`

### swoole

`brew install php70-swoole`

配置文件  
`/usr/local/etc/php/7.0/conf.d/ext-swoole.ini`

更多扩展执行 `brew install 扩展名` 进行安装