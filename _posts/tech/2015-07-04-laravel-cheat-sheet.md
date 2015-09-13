---
layout: post
title: Laravel 整理
date: 2015-07-04 15:05:23
category: 技术  
tags: Laravel
---

## 路由

### 1、简单模式

```php 
<a href="{{ url('/articles') }}">链接</a>
// or
<a href="{{ URL::to('/articles') }}">链接</a>
```
	
这种方式，只是简单的将你指定的路径拼接到网站根url上。
	
	
### 2、路由模式

	URL::route('articles.index')
	// or
	route('articles.index')
	
这种方式是指定匹配注册路由时的 'as' 参数，得到注册的uri。

### 3、控制器动作模式

	URL::action('ArticlesController@index')
	
这种方式是根据注册路由时 'uses' 参数，自动生成映射到控制器方法的uri，规则同 Route::controller() 。 举例如下：

	ArticlesController@index => articles
	ArticlesController@getAdd => articles/add
	ArticlesController@postAdd => articles/add
	ArticlesController@getDelete => articles/delete
	
## 数据库操作

### 1、获取最后插入的ID

> see: http://stackoverflow.com/questions/27873777/how-to-get-last-insert-id-in-eloquent-orm-laravel

	$user = new User;

	$user->name = 'John';
	
	$user->save();
	
	//Getting Last inserted id
	
	$insertedId = $user->id;	
	
	
## 常用命令

	# 生成创建news表文件
	php artisan make:migration create_news_table --create=news
	# 创建表
	php artisan migrate	
	# 生成model文件到App/Models目录
	php artisan make:model Models/News
	
## 常用方法或函数

	# 获取除某字段之外的所有字段
	Input::except(['_token');	
	
	
## 配置

### 1、获取配置

获取config目录下wechat文件里数组key对应的值：		

	Config::get('wechat.app_id')  
	
wehchat 对应 app/config/wechat.php 文件


## 碰到的问题

### 1、无法创建 controller

	php artisan make:controller UserController
	
提示：
	
	[RuntimeException]
	Unable to detect application namespace.
	
解决步骤：

- 看看`composer.json` 是否有语法错误	
- 若无，检查`composer.json`里配置的,看是否丢失了命名空间`psr-4`


参考：[http://stackoverflow.com/questions/29956010/error-running-makerequest-on-laravel-5](http://stackoverflow.com/questions/29956010/error-running-makerequest-on-laravel-5)

	
	





## 参考：
 - [http://cheats.jesse-obrien.ca/](http://cheats.jesse-obrien.ca/)
	
		