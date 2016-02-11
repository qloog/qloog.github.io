---
layout: post
title: PHP调试工具之FirePHP
date: 2012-03-25 11:38:07
category: 技术
tags: PHP FirePHP
---

听说FirePHP是个不错的工具，但一直没有用过，今天就把如何安装及使用整理一下。
 
## FirePHP简单说明
 1. FirePHP能将你的PHP应用程序通过调用一个简单的FirePHP函数输出到Firebug的Console里。
 2. 输出的数据会显示在页面的headers里，而不会是页面本身。
 3. FirePHP也非常适合于需要AJAX或XML来做响应数据要求的场景。
 
## 使用环境
 1. 可用在生成环境或者说叫线上环境，这样调试或排错时不会影响到用户的使用。
 2. 还可用在不能影响页面展示的环境，比如有时候用var_dump或print_r输出数据，明显会影响到页面。
 
## 使用条件
 1. Firefox 浏览器
 2. FireBug 扩展，这个可以在Firefox的插件管理器里搜索安装
 3. FirePHP扩张，这个同样可以在插件管理器里搜索安装
 4. FirePHP服务器端安装，这个下面详细介绍下
 
## FirePHP服务器端安装
###有两种方法可以安装：
 1. PEAR方式安装（可以安装上最新版的）  
  
   	pear channel-discover pear.firephp.org
 	pear install firephp/FirePHPCore
 	
 	如果安装成功，会在PHP的目录下生成一个目录，如：`php_path/lib/php/FirePHPCore`
 	
 2. 直接下载源码包(当前版本0.3.2)，将源码包解压后放到网站的类库里即可  
 
 	wget http://www.firephp.org/DownloadRelease/FirePHPLibrary-FirePHPCore-0.3.2
	
 3. 安装后的文件：
 
	|– FirePHP.class.php
	|– FirePHP.class.php4
	|– fb.php
	`– fb.php4
 
## DEMO
 1. 确保服务器端类库是否已安装，查看方法：
 
	find  / –name FirePHP.class.php //或者在php的类库里找

 2. include FirePHP类
	require_once(‘FirePHPCore/FirePHP.class.php’);
	
 3. 开启输出缓存，如果php.ini里已经开启的话，可以跳过这一步
	ob_start();
	
 4. 现在可以编写代码来查看如何输出信息了
	vim index.php 加入如下内容：  
	
	<?php
	require_once(‘FirePHPCore/FirePHP.class.php’);
	ob_start();
	$firephp = FirePHP::getInstance(true);
	$var = array(‘i’=>10, ‘j’=>2000);
	$firephp->log($var, ‘Iterators’);
	?>
	
	注意：需要确保Firebug 的网络 和 Console面板是开启的

 5. 访问地址看效果（http://localhost/index.php):  
 
	Console_HelloWorld_Screenshot  
	
	注意：当你的鼠标经过Iterators这行消息的时候，所访问文件和行的信息才会展示出来(/www/Inex.php : 5)。
 
通过以上我们可以简单使用FirePHP来log 信息了。  

## 参考(官方)：  

  * <http://www.firephp.org/HQ/Install.htm>  
  
  * <http://www.firephp.org/HQ/Learn.htm>
