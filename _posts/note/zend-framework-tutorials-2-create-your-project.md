Title: Zend Framework教程2-创建你的项目
Date: 2012-07-12 17:27:33
Tags: PHP, Zend Framework

为了创建你的项目，首先需要下载并解压出Zend Framework。 

  * **安装Zend Framework（两种方式）**
1、下载带有完整PHP stack的Zend Framework的最简单的方法是 通过安装 [Zend Server](http://www.zend.com/en/products/server-ce/downloads)。Zend Server有针对Mac OSX,Windows, Fedora Core 和 Ubuntu的本地安装，以及一个通用安装包兼容大多数Linux发行版。  安装好Zend Server之后，框架文件可以在 Mac OSX 和 Linux 的 /usr/local/zend/share/ZendFramework 目录下找到，或者是windows里的C:\Program Files\Zend\ZendServer\share\ZendFramework 文件夹里。 这个include_path将已经被配置成包含Zend框架。（此做法相对比较复杂，我们一般不会用到Zend Server） 2、或者,你可以»[下载最新版本的Zend框架](http://framework.zend.com/download/latest)，同时解压里面的文件;记住你已经这么做了。 可选地，你可以添加此框架路径到你的php.ini配置文件中include_path设置里的 library下的子目录。 就这样，Zend Framework 已经安装好，可以准备使用了。(推荐此方法) 

  * **创建项目**

> 注：zf 命令行工具 在Zend Framework的安装目录里，有一个 bin/的 子目录，里面分别包含有基于UNIX用户的zf.sh和基于windows用户的zf.bat脚本文件，记住这些脚本的绝对路径。 无论你在哪使用命令行工具zf，请用含有绝对路径的脚本文件来代替。在类Unix系统里，你可能想去使用shell脚本的别名功能：**alias zf.sh=path/to/ZendFramework/bin/zf.sh**. 如果在安装命令行工具zf上有问题，请参考：[手册](http://framework.zend.com/manual/en/zend.tool.framework.clitool.html)

打开一个终端（在window下 开始->运行，输入cmd）,转到你要开始创建项目的目录里。然后，使用适当的脚本，执行下面的脚本： 
    
    
    % zf create project quickstart

注：如果按照上述做法不能成功创建你的项目，OK，那没关系，看[这里](/806)。 运行这条命令将会创建基本的站点结构目录，包括初始的控制器和视图。属性目录结构如下： 
    
    
    quickstart
    |-- application
    |   |-- Bootstrap.php
    |   |-- configs
    |   |   `-- application.ini
    |   |-- controllers
    |   |   |-- ErrorController.php
    |   |   `-- IndexController.php
    |   |-- models
    |   `-- views
    |       |-- helpers
    |       `-- scripts
    |           |-- error
    |           |   `-- error.phtml
    |           `-- index
    |               `-- index.phtml
    |-- library
    |-- public
    |   |-- .htaccess
    |   `-- index.php
    `-- tests
        |-- application
        |   `-- bootstrap.php
        |-- library
        |   `-- bootstrap.php
        `-- phpunit.xml

这时候，如果你没有添加Zend Framework到你的include_path,我们推荐拷贝或者符号链接到你的 library/ 目录。不论何种情况，你想要递归的拷贝或者符号链接 Zend Framework安装目录下的 library/Zend/ 目录到你的工程目录 library/ 目录下。在类Unix系统里，你可以执行下面的任何一条： 
    
    
    # Symlink:
    % cd library; ln -s path/to/ZendFramework/library/Zend .
    
    # Copy:
    % cd library; cp -r path/to/ZendFramework/library/Zend .

在Windows 系统下，这个操作通过在资源管理器下是非常容易操作的。 现在，项目已经被创建之后，最主要的任务就是去理解启动、配置、action 控制器和视图。 

  * **引导程序(The Bootstrap)**
你的Bootstrap类文件定义了哪些资源和组件是要被去初始化。默认情况下，Zend Framework的[Front Controller](http://framework.zend.com/manual/en/zend.controller.front.html) 是被初始化，它用application/controllers/作为默认目录，用这个控制器寻找action控制器（稍后详细介绍）。这个类的内容如下：
    
    
    // application/Bootstrap.php
    
    class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
    {
    }

正如你所看到的，开始时没有太多要做的必要，大大的减少了我们的开发步骤。 

  * **配置(Configuration)**
当Zend Framework 本身的配置比较少的时候，这时更多的是配置我们的应用程序。默认情况下，配置是被保存在：application/configs/application.ini 文件里，这个文件包含了一些基本的PHP环境设置的指令（如实例，打开或者关闭错误报告），指明bootstrap类文件的路径（还有bootstrap的类名）和action 控制器的路径。内容大概如下：
    
    
    ; application/configs/application.ini
    
    [production]
    phpSettings.display_startup_errors = 0
    phpSettings.display_errors = 0
    includePaths.library = APPLICATION_PATH "/../library"
    bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
    bootstrap.class = "Bootstrap"
    appnamespace = "Application"
    resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
    resources.frontController.params.displayExceptions = 0
    
    [staging : production]
    
    [testing : production]
    phpSettings.display_startup_errors = 1
    phpSettings.display_errors = 1
    
    [development : production]
    phpSettings.display_startup_errors = 1
    phpSettings.display_errors = 1

有关这个文件的几个事情应该注意：第一，当你使用INI-style的配置文件时，你可以直接引用常量并改写他们；**APPLICATION_PATH**通常是一个常量。另外请注意，有几个部分定义：生产、分期、测试和开发。后面的三个是继承自production 后的配置。这是一个非常有用的方法来组织配置文件，以确保适当的属性设置在每个阶段的应用程序开发都是有效的。

  * **Action控制器(Action  Controllers)**
你的应用程序的action控制器包含了你应用程序的工作流和将你的请求映射到适当的模式和视图要做的工作。 一个action控制器应该包含一个或多个以"Action"结尾的方法；这些方法可能会被经过网络发起请求。默认地，Zend Framework的URLS遵循这样的模式：**/controller/action, **在这“Controller”被映射到action控制器名称(减去"Controller"后缀)，“action”被映射到一个action方法(减去"Action"后缀)。 代表性地，你需要一个**IndexController**，这是一个后背控制器同时也服务于站点的首页；也需要一个**ErrorController，**用来指明一些错误的事情发生，如HTTP 404C错误(controller或action没有找到)和HTTP 500错误(appliction错误)。 默认控制器**IndexController**如下： 
    
    
    // application/controllers/IndexController.php
    
    class IndexController extends Zend_Controller_Action
    {
    
        public function init()
        {
            /* Initialize action controller here */
        }
    
        public function indexAction()
        {
            // action body
        }
    }

默认的**ErrorController**如下： 
    
    
    // application/controllers/ErrorController.php
