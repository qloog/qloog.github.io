---
layout: post
title: Laravel 整理
date: 2015-07-04 15:05:23
category: 技术  
tags: Laravel
---

## 路由

### 1、简单模式
 
	<a href="{{ url('/articles') }}">链接</a>
	// or
	<a href="{{ URL::to('/articles') }}">链接</a>
	
这种方式，只是简单的将你指定的路径拼接到网站根url上。
	
	
### 2、路由模式

	URL::route('articles.index')
	
这种方式是指定匹配注册路由时的 'as' 参数，得到注册的uri。

### 3、控制器动作模式

	URL::action('ArticlesController@index')
	
这种方式是根据注册路由时 'uses' 参数，自动生成映射到控制器方法的uri，规则同 Route::controller() 。 举例如下：

	ArticlesController@index => articles
	ArticlesController@getAdd => articles/add
	ArticlesController@postAdd => articles/add
	ArticlesController@getDelete => articles/delete
	
	
	
## 配置

### 1、获取配置

获取config目录下wechat文件里数组key对应的值：		

	Config::get('wechat.app_id')  
	
wehchat 对应 app/config/wechat.php 文件




更多用法参考：  [http://cheats.jesse-obrien.ca/](http://cheats.jesse-obrien.ca/)
	
		