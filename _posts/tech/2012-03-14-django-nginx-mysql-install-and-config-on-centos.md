---
layout: post
title: CentoS下Django1.3 & Nginx(FastCGI & flup) & MySQL安装配置详解
category: 技术
date: 2012-03-14 22:58:31
tags: Django CentOS
---

Django是一个开源的Web应用框架，由Python写成，并于2005年7月在BSD许可证下发布。  

Django的主要目标是使得开发复杂的、数据库驱动的网站变得简单。Django采用MVC设计模式注重组件的重用性和“可插拔性”，敏捷开发和DRY法则（Don’t Repeat Yourself）。在Django中Python被普遍使用，甚至包括配置文件和数据模型。

**本文介绍Django在Linux+Nginx+MySQL环境下安装、配置的过程，包括安装、运行、添加应用的所有流程，最终建立一个可以从Mysql读取文章并显示的Django应用**。   FastCGI的优点是很明显的，它启用单独的process来处理动态的请求，而静态的文件可以交给Nginx来接手，这样可以实现他们的优势互补，发挥最大性能。 

## 一、下载安装

**1、官网下载Django**

	wget www.djangoproject.com/download/1.3/tarball/

**2、解压、安装**

	tar xzvf Django-1.3.tar.gz cd Django-1.3 sudo python setup.py install

**3、查看安装后django目录内的文件**

	-bash-3.2# ls /usr/lib/python2.4/site-packages/django/bin   
	contrib  db        forms  __init__.py   middleware  template      
	test   views conf  core     dispatch  http   __init__.pyc  shortcuts   	templatetags  utils

 

## 二、创建Django项目

要创建一个Django项目非常简单，使用startproject命令，输入项目名称： 

	django-admin.py startproject mysite

Django会在当前目录下自动生成一个名为mysite的文件夹，即项目文件名，里面有以下文件(.pyc在第一次执行后才有，刚建立时只有几个py的文件)： 

	__init__.py  manage.py  settings.py  urls.py

  1. __init__.py：可以是空文件，只是表明这个文件夹是一个可以导入的包，在安装配置时不会用到。
  2. settings.py：配置文件，配置Django的一些信息，最主要是数据库信息、加载模块的信息。
  3. manage.py：命令行工具，实现与Django之间的交互。

## 三、启动Django自带的web服务器

创建项目后，进入项目文件夹，启动Django自带的web服务器： 

	python manage.py runserver

Django会自动检查配置文件中的错误，如果全部正常则顺利启动： 

	Validating models…
	0 errors found
	Django version 1.3.1, using settings ‘pylabs.settings’
	Development server is running at http://127.0.0.1:8000/
	Quit the server with CONTROL-C.

访问<http://127.0.0.1:8000/>，如果顺利显示，说明Django已经可以正常使用了。但现在只有本机可以访问，要让外网能够访问，或是要更换默认的8000端口，可以执行命令： 

	python manage.py runserver 0.0.0.0:8080

这样就将端口修改为8080，且外网也可以通过IP访问本机上的Django。如图： ![diango_web_server_success](//static/uploads/2012/03/diango_web_server_success_thumb.png)   

## 四、将Django的项目加入到Nginx里
为了方便用域名访问，我们需要将Django与nginx结合，这样我们需要在nginx.conf里加入一个server,在nginx.conf 里加入： 

	django project
	include conf/django.conf;

  在nginx/conf/新建：diango.conf，加入如下代码： 
  
 
	server {
		listen  80;
		server_name pylabs.lamp100.com;
		#include conf/bots.conf;
		location / {
			#fastcgi_pass unix:/home/projectname/server.sock;
			fastcgi_pass 127.0.0.1:8080;
			#include conf/bots.conf;
			include    conf/fastcgi_django.conf;
			access_log  /data1/logs/nginx_django.log;
		}
		location ^~ /admin/ {
			#fastcgi_pass unix:/home/projectname/server.sock;
			include  conf/fastcgi_django.conf;
			access_log   off;
			#auth_basic “Welcome to admin”;
			#auth_basic_user_file /etc/nginx_passwd;
		}
		location ~* ^.+\.(mpg|avi|mp3|swf|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|txt|tar|mid|midi|wav|rtf|mpeg)$ {
			root   /data0/htdocs/pylabs/media;
			limit_rate 2000K;
			access_log  /data1/logs/nginx_django_media.log;
			access_log   off;
		}
		location ~* ^.+\.(jpg|jpeg|gif|png|ico|css|bmp|js)$ {
			root   /data0/htdocs/pylabs/static;
			access_log   off;
			expires      30d;
		}
		location /403.html {
			root   /usr/local/webserver/nginx/sbin/nginx;
			access_log   off;
		}
		location /401.html {
			root   /usr/local/webserver/nginx/sbin/nginx;
			access_log   off;
		}
		location /404.html {
			root   /usr/local/webserver/nginx/sbin/nginx;
			access_log   off;
		}
		location = /_.gif {
			empty_gif;
			access_log   off;
		}
	}
以上用到了fstcgi_django.conf,所以在nginx/conf下，新建：fastcgi_django.conf,加入如下内容： 

    fastcgi_pass_header Authorization;
	fastcgi_intercept_errors off;
	fastcgi_param PATH_INFO         $fastcgi_script_name;
	fastcgi_param REQUEST_METHOD      $request_method;
	fastcgi_param QUERY_STRING        $query_string;
	fastcgi_param CONTENT_TYPE        $content_type;
	fastcgi_param CONTENT_LENGTH      $content_length;
	fastcgi_param SERVER_PORT         $server_port;
	fastcgi_param SERVER_PROTOCOL     $server_protocol;
	fastcgi_param SERVER_NAME         $server_name;
	fastcgi_param REQUEST_URI         $request_uri;
	fastcgi_param DOCUMENT_URI      $document_uri;
	fastcgi_param DOCUMENT_ROOT          $document_root;
	fastcgi_param SERVER_ADDR            $server_addr;
	fastcgi_param REMOTE_USER         $remote_user;
	fastcgi_param REMOTE_ADDR         $remote_addr;
	fastcgi_param REMOTE_PORT         $remote_port;
	fastcgi_param SERVER_SOFTWARE     “nginx”;
	fastcgi_param GATEWAY_INTERFACE     “CGI/1.1″;
	#    fastcgi_param GEO             $geo;
	fastcgi_param UID_SET         $uid_set;
	fastcgi_param UID_GOT         $uid_got;
	#    fastcgi_param SCRIPT_NAME        $fastcgi_script_name;

  重新加载Nginx的配置文件： 

	/usr/local/webserver/nginx/sbin/nginx -s reload

进入python项目目录下，执行以下命令： 

	python manage.py runfcgi method=threaded host=127.0.0.1 port=8080 pidfile=django.pid

可能会出现如下的提示： 

	-bash-3.2# python manage.py runfcgi method=threaded host=127.0.0.1 port=8080 pidfile=django.pid
	ERROR: No module named flup
	Unable to load the flup package.  In order to run django
	as a FastCGI application, you will need to get flup from
	http://www.saddi.com/software/flup/   If you’ve already
	installed flup, then make sure you have it in your PYTHONPATH.

  从提示信息中可以看到，想要运行FastCGI需要安装flup这个模块。   下载flup： 

	wget <http://www.saddi.com/software/flup/dist/flup-1.0.2.tar.gz>

解压： 

	tar zxvf flup-1.0.2.tar.gz

安装：进入flup的解压目录里执行 

	python setup.py install

成功提示： 

	Installed /usr/lib/python2.4/site-packages/setuptools-0.6c9-py2.4.egg
	Processing dependencies for setuptools==0.6c9
	Finished processing dependencies for setuptools==0.6c9
	Processing flup-1.0.2-py2.4.egg
	Copying flup-1.0.2-py2.4.egg to /usr/lib/python2.4/site-packages
	Adding flup 1.0.2 to easy-install.pth file
	Installed /usr/lib/python2.4/site-packages/flup-1.0.2-py2.4.egg
	Processing dependencies for flup==1.0.2
	Finished processing dependencies for flup==1.0.2
	
这里的setuptools是flup的依赖包，这个不用自己安装，这里会自动安装。
 
再次执行：

	python manage.py runfcgi method=threaded host=127.0.0.1 port=8080 	pidfile=django.pid
	
OK，让我们在浏览器里输入看看吧：http://pylabs.lamp100.com
 
## 五、让Django支持MySQL数据库
 1. 安装Mysql for Python。下载：  
 
 	wget http://sourceforge.net/projects/mysql-python/files/mysql-python/1.2.3/MySQL-python-1.2.3.tar.gz/download
	
解压并安装:

	$ tar xfz MySQL-python-1.2.1.tar.gz
	$ cd MySQL-python-1.2.1
	$ # edit site.cfg if necessary
	$ python setup.py build
	
在执行python setup.py bulid 时，可能会碰到以下提示：

	-bash-3.2# python setup.py build
	sh: mysql_config: command not found
	Traceback (most recent call last):
	File “setup.py”, line 15, in ?
	metadata, options = get_config()
	File “/data0/software/MySQL-python-1.2.3/setup_posix.py”, line 43, in get_config
	libs = mysql_config(“libs_r”)
	File “/data0/software/MySQL-python-1.2.3/setup_posix.py”, line 24, in mysql_config
	raise EnvironmentError(“%s not found” % (mysql_config.path,))
	EnvironmentError: mysql_config not found
	
编辑 vim setup_posix.py
在26找到 `mysql_config.path = “mysql_config”`
将26行改为mysql_config的真实路径：`/usr/local/mysql/bin/mysql_config` (可以 locatemysql_config 获取到)
再次执行：

	python setup.py build
	
又报错：

	-bash-3.2# python setup.py build
	running build
	running build_py
	copying MySQLdb/release.py -> build/lib.linux-i686-2.4/MySQLdb
	running build_ext
	building ‘_mysql’ extension
	gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector –param=ssp-buffer-size=4 -m32 -march=i386 -mtune=generic -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC -fPIC -Dversion_info=(1,2,3,’final’,0) -D__version__=1.2.3 -I/usr/local/webserver/mysql/include/mysql -I/usr/include/python2.4 -c _mysql.c -o build/temp.linux-i686-2.4/_mysql.o -g -DUNIV_LINUX
	
在包含自 `_mysql.c：29` 的文件中:

	pymemcompat.h:10:20: 错误：Python.h：没有那个文件或目录
	_mysql.c:30:26: 错误：structmember.h：没有那个文件或目录
	……
	_mysql.c:2810: 错误：expected declaration specifiers before ‘init_mysql’
	_mysql.c:2888: 错误：expected ‘{’ at end of input
	error: command ‘gcc’ failed with exit status 1
	
查了一下，执行以下命令：

	yum install python-devel
	
问题解决。

继续执行：

	sudo python setup.py install
 
 2. 编辑配置文件（setting.py），在第12行中找到：
 
		DATABASES = {
			‘default’: {
			‘ENGINE’: ‘django.db.backends.mysql’, #设置为mysql数据库
			‘NAME’: ‘lamp100′,                     #mysql数据库名.
			‘USER’: ‘root’,                     #mysql用户名，留空则默认为当前linux用户名.
			‘PASSWORD’: ‘root’,                  #mysql密码.
			‘HOST’: ”,                       #留空默认为localhost.
			‘PORT’: ”,                       #留空默认为3306端口.
			}
		}
 
再次使用runserver命令（通常来说Django会自动加载setting.py文件的），就可以使用MySQL数据库了。
 
## DEMO
### URL
URL配置文件很像一个目录，Django会通过URL配置文件来查找相应的对象，URL地址的使用正则表达式设置。在mysite目录下可以找到`urls.py`文件，它是URL配置的默认起点(也可以通过编辑`settings.py`中的`ROOT_URLCONF`值来修改)。直接编辑urls.py

	urlpatterns = patterns(”,
	(r’^$’,'mysite.hello.index’),
	)
	
`r’^$’`正则，表示根目录；
`mysite.hello.index`：指向mysite这个项目下的hello模块中的index函数
在mysite目录下新建一个hello.py文件，写入以下代码：
### hello.py
	from django.http import HttpResponse
	def index(request):
	return HttpResponse(‘hello, world’)
刷新页面，就可以看到输出的内容了：“hello,world”。
另一种方法：: 设置一个hello模块只是方便理解Django的结构，但如果一个首页就要使用那么多代码，是很不pythonic的，所以在生产环境中我们的首页通常会这么来写：
### url.py
	urlpatterns = patterns(”,
	url(r’^$’, ‘django.views.generic.simple.direct_to_template’, {‘template’:'index.html’}),
	)
Django会自动在模板目录中找到并加载index.html，只需要修改url.py一个文件就搞定了。
 
### Application
上一节”hello world”的例子只是说明了URL的用法，可以说完全没有用到Django。Django作为一个Web框架，目的是实现MVC的分离，它可以自行处理一些通用的操作，让开发人员可以专注于核心应用的开发。所以，本文的最后一步将编写一个名为article的应用，从mysql数据库里读取出文章作者、标题、内容。
首先建立应用：
	python manage.py startapp article
在项目文件夹中会增加一个article文件夹，内有如下文件：

	-bash-3.2# cd article/
	-bash-3.2# tree
	.
	|– __init__.py
	|– models.py
	|– tests.py
	`– views.py
	
`models.py`：模型文件，用一个 Python 类来描述数据表，运用它可以通过简单的 Python 的代码来创建、检索、更新、删除数据库中的记录而无需写一条又一条的SQL语句。
`views.py`：视图文件，用来联系模型与模版。
然后编写模型文件(article/models.py)，用来实现对数据库的操作：
from django.db import models
### Create your models here.
	class Article(models.Model):
	title    = models.CharField(max_length=50)
	author   = models.CharField(max_length=50)
	content  = models.CharField(max_length=200)
现在要修改配置文件(`settings.py`)文件，告诉Django这个应用是项目的一部分，打开配置文件，在尾部找到INSTALLED_APPS元组，将article添加进去：

	INSTALLED_APPS = (
	‘django.contrib.auth’,
	‘django.contrib.contenttypes’,
	‘django.contrib.sessions’,
	‘django.contrib.sites’,
	‘django.contrib.messages’,
	‘django.contrib.staticfiles’,
	‘article’, #加入app
	# Uncomment the next line to enable the admin:
	# ‘django.contrib.admin’,
	# Uncomment the next line to enable admin documentation:
	# ‘django.contrib.admindocs’,
	)
可以现运行(需要提前创建数据库):

	python manage.py sql article
命令进行测试，如果可以看到生成的sql语句，说明模型已经正常设置。

	-bash-3.2# python manage.py sql article
	BEGIN;
	CREATE TABLE `article_article` (
	`id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`title` varchar(50) NOT NULL,
	`author` varchar(50) NOT NULL,
	`content` varchar(200) NOT NULL
	)
	;
	COMMIT;
	
如果碰到如下错误：

	django.core.exceptions.ImproperlyConfigured: Error loading MySQLdb module: libmysqlclient.so.16: cannot open shared object file: No such file or directory
解决方法：

	cp /usr/local/webserver/mysql/lib/mysql/libmysqlclient_r.so.16 /usr/lib
	cp /usr/local/webserver/mysql/lib/mysql/libmysqlclient.so.16 /usr/lib
此时可以初始化并安装：

	-bash-3.2# python manage.py syncdb
	Creating tables …
	Creating table auth_permission
	Creating table auth_group_permissions
	Creating table auth_group
	Creating table auth_user_user_permissions
	Creating table auth_user_groups
	Creating table auth_user
	Creating table auth_message
	Creating table django_content_type
	Creating table django_session
	Creating table django_site
	Creating table article_article
	You just installed Django’s auth system, which means you don’t have any superusers defined.
	Would you like to create one now? (yes/no): yes
	Username (Leave blank to use ‘root’): 用户名
	E-mail address: 你的邮箱地址
	Password:
	Password (again):
	Superuser created successfully.
	Installing custom SQL …
	Installing indexes …
	No fixtures found.
 
简单的模型就设置完成了，现在来设置视图，编辑视图(`article/views.py`)文件：
### article/views.py
	from django.shortcuts import render_to_response
	from models import Article
	def latest_article(request):
	article_list = Article.objects.order_by(‘-id’)
	return render_to_response(‘article/article.html’,{‘article_list’:article_list})
	
2行：导入Django的`render_to_response()`函数，它用来调用模板、填充内容和返回包含内容的页面。  
3行：导入之前编写模型文件中的Article类。  
4~6行：定义一个latest_article函数，利用Article类从数据库获得数据，并按照id倒序输出。然后调用模版文件，将变量传递过去。
 
在上面的代码中使用的模版文件，它的地址是设置文件中的模版路径+在views.py中定义的路径，因此如果报错TemplateDoesNotExist at 路径的话，很可能就是忘了设置模板路径。  
编辑设置文件(settings.py)，修改TEMPLATE_DIRS，设置一个模版路径，这里将模版目录直接指定在项目文件夹(mysite)中：

	TEMPLATE_DIRS = (	
	“/var/www/mysite”
	# Put strings here, like “/home/html/django_templates” or “C:/www/django/templates”.
	# Always use forward slashes, even on Windows.
	# Don’t forget to use absolute paths, not relative paths.
	)
	
这样程序运行时，加载的静态模版就是 /var/www/mysite/article/article.html了。如果使用过其它框架或者模板引擎，下面article.html的内容就很容易看懂了，Django在模版文件中利用相应的TAG控制传递过来的变量显示的位置：

	{% for article in article_list %}
	Author:{{ article.author }}
	Title:{{ article.title }}
	Content:{{ article.title }}
	{% endfor %}
	
最后，修改URL配置文件，让article/指向视图(views.py)中定义的latest_articl函数：
`(r’^article/’, ‘mysite.article.views.latest_article’)`,
这样所有的配置就完成了，当访问 http://pylabs.lamp100.com/article，Django就会自动读取数据库中的内容，并显示在网页上了。
 
推荐两个不错的教程：  

  * Django官方文档：<https://docs.djangoproject.com/en/1.3/>
  * Django book 2.0 的中文版：<http://djangobook.py3k.cn/2.0/>
  
参考：  

  * <http://dmyz.org/archives/110>
  * <http://scnjl.iteye.com/blog/838395>
