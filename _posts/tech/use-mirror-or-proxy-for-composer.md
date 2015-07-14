---
layout: post
title: 使用镜像或代理 加速Composer
date: 2015-07-04 14:25:23
category: 技术
tags: composer Laravel
---


因为用`Laravel`开发，而`Laravel`是基于`Composer`来管理package的，但在我们这环境（你懂的）用composer确实太慢了，慢到已经严重影响我们的开发工作，所以不得不考虑通过镜像或者代理的方式来加快下载速度。

  

## 1、中国镜像站Packagist  

**宗旨：** 让Composer用得更愉快一点点 。  

**说明：** 该镜像是有熟悉symfony的洪大师建立的。

**官方地址：** [http://packagist.cn/](http://packagist.cn/)



## 2、代理安装依赖

#### 红杏公益版

红杏插件也chrome下大家所熟知的一款翻墙插件，很方便使用，但是需要注册帐号。

但是也有公益版的。

使用方法：`vim ~/.bashrc   (如果是zsh，执行：vim ~/.zshrc`)  在最后加上：

	http_proxy=http://hx.gy:1080
	export http_proxy
	
保存退出后，执行 `source ~/.bashrc`  或者 `source ~/.zshrc`

### 安装依赖包

	composer require "bosnadev/repositories: 0.*" -vvv
	

参考：[https://phphub.org/topics/862](https://phphub.org/topics/862)




	
	




