---
layout: post
title: Composer 常用命令
date: 2015-07-31 09:48:23
category: 技术  
tags: Composr
---

## 安装

	composer install
	
`install` 命令从当前目录读取 `composer.json` 文件，处理了依赖关系，并把其安装到 `vendor` 目录下

如果当前目录下存在 composer.lock 文件，它会从此文件读取依赖版本，而不是根据 composer.json 文件去获取依赖。这确保了该库的每个使用者都能得到相同的依赖版本。

如果没有 composer.lock 文件，composer 将在处理完依赖关系后创建它。

## 更新 composer 到最新版

	composer self-update 

## 安装第三方package

	composer require "intervention/image"
 
## 查看已安装的包及对应的版本号
 
	composer show --installed
	

 示例：
 
 ![image](http://www.lnmp100.com/static/uploads/2015/07/composer-show-installed.png)
 
 关于版本号的定义：
 
 ![image](http://www.lnmp100.com/static/uploads/2015/07/develop-version-define.png)
 
 版本号演进：
 
 ![image](http://www.lnmp100.com/static/uploads/2015/07/developer-version-begin.png)
 
 
   
 `dev > alpha > beta > RC > scable`
 > 稳定定依次增强
 
 如果对版本号没有把握的话，可以用[Packagist Semver Checker](http://semver.mwl.be/)验证您的写法
 
 
## 更新autoloader

比如在包中加入了一个新的类，需要执行`dump-autoload`,而不必执行`install` or `update`
 
	composer dump-autoload
  
  
## 更多查阅

 * Composer中文文档: [http://docs.phpcomposer.com/](http://docs.phpcomposer.com/) 
 * 英文官方文档：[https://getcomposer.org/doc/](https://getcomposer.org/doc/)
 * [給 PHP 開發者的 Composer 錦囊](https://www.youtube.com/watch?t=2140&v=GFbrNBQjkpk)