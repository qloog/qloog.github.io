Title: Zend Framework教程3-创建一个布局(Layout)
Date: 2012-07-15 11:03:09


你可以已经注意到之前创建的视图脚本文件是HTML碎片而不是完成的页面。这就需要设计，我们想让我们的actions只返回和该action相关的内容，而不是整个应用程序。 现在我们必须组合，使生成的页面成为一个完成的HTML页面。我们也想有一个一致的外观和感觉的应用程序。我们使用全局站点布局去实现这些任务。  有两种设计模式，使用Zend Framework实现的布局：[Two Step View](http://martinfowler.com/eaaCatalog/twoStepView.html)和[Compsite View](http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html)。Two Step View 通常和传输视图模式([Transform View](http://www.martinfowler.com/eaaCatalog/transformView.html))有关系；基本的思想就是应用程序创建一个代表，然后注入到最终需要转换的主视图。复合视图模式(The _Composite View_ pattern)处理由一个或多个原子构成的应用程序视图。 在Zend Framework,[Zend_Layout](http://framework.zend.com/manual/en/zend.layout.html)组合这些模式背后的思想。相反地每个操作的视图脚本需要包含站点范围内的组件，这样就可以简单地将焦点放在自己的责任（说白了就是方便各自处理自己的，不会相互干扰）。 然而有时候，也需要将你站点范围内的特定应用程序信息应用于视图脚本。幸运的是，Zend Framework提供了种种视图占位符允许你从你的操作视图脚本提供此类的信息。 让我们开始使用**Zend_Layout**吧，首先我们需要通知我们的bootstrap去使用**Layout**资源。这可以通过_zf enable layout_命令来做到： 
    
    
    % zf enable layout
    Layouts have been enabled, and a default layout created at
    application/layouts/scripts/layout.phtml
    A layout entry has been added to the application config file.

通过这表命令我们注意到，application/configs/application.ini文件是被更新了，现在包含了**production**部分： 
    
    
    ; application/configs/application.ini
    
    ; Add to [production] section:
    resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

最终的INI文件看起来应该是这样： 
    
    
    ; application/configs/application.ini
    
    [production]
    ; PHP settings we want to initialize
    phpSettings.display_startup_errors = 0
    phpSettings.display_errors = 0
    includePaths.library = APPLICATION_PATH "/../library"
    bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
    bootstrap.class = "Bootstrap"
    appnamespace = "Application"
    resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
    resources.frontController.params.displayExceptions = 0
    resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"
    
    [staging : production]
    
    [testing : production]
    phpSettings.display_startup_errors = 1
    phpSettings.display_errors = 1
    
    [development : production]
    phpSettings.display_startup_errors = 1
    phpSettings.display_errors = 1

这个指令告诉你的应用程序从_application/layouts/scripts_ 里寻找布局视图脚本。如果你查看你的目录树，你将看到这目录已经被创建了，还带有一个layout.phtml文件。 我们想确保我们的应用程序有一个HTML文档类型声明。要启用这个，需要在bootstarp里添加一个资源。 添加bootstarp资源最简单的方法就是简单的创建一个以**_init**开头的保护方法。既然这样，我们想去初始化文档类型，我们就需要创建一个**_initDoctype()**的方法在bootstarp类里： 
    
    
    // application/Bootstrap.php
    
    class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
    {
        protected function _initDoctype()
        {
        }
    }

在那个方法里，我们需要提示视图使用适当的文档类型。但是视图对象来自哪里呢？最简单的解决方法就是厨师换**View**资源；一旦我们有了这些，我们就可以从bootstarp里取出视图对象并使用它们。 要初始化view资源，添加以下的行到_application/configs/application.ini_里 
    
    
    ; application/configs/application.ini
    
    ; Add to [production] section:
    resources.view[] =

这告诉我们初始化视图不使用操作项(“[]”表明“视图”键是一个数组,我们什么也没有做)。 现在我们有一个视图，让我们填充我们的_initDoctype方法，在这个方法里，我们首先要确保View资源已经在运行，取出View对象后，然后就可以配置了： 
    
    
    // application/Bootstrap.php
    
    class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
    {
        protected function _initDoctype()
        {
            $this->bootstrap('view');
            $view = $this->getResource('view');
            $view->doctype('XHTML1_STRICT');
        }
    }

现在让我们初始化Zend_Layout并设置文档类型，让我们创建站点范围布局： 
    
    
    <!-- application/layouts/scripts/layout.phtml -->
    <?php echo $this->doctype() ?>
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <title>Zend Framework Quickstart Application</title>
      <?php echo $this->headLink()->appendStylesheet('/css/global.css') ?>
    </head>
    <body>
    <div id="header" style="background-color: #EEEEEE; height: 30px;">
        <div id="header-logo" style="float: left">
            <b>ZF Quickstart Application</b>
        </div>
        <div id="header-navigation" style="float: right">
            <a href="<?php echo $this->url(
                array('controller'=>'guestbook'),
                'default',
                true) ?>">Guestbook</a>
        </div>
    </div>
    
    <?php echo $this->layout()->content ?>
    
    </body>
    </html>

我们通过使用**layout()**视图helper和"content" key来获取应用程序内容。如果你愿意，也可以呈献给其他的相应部分，但在大多数情况下，这是必须的。 还有要注意的是使用占位符headLink()。这也是生成HTML标签<link>非常简单的方法，同时通过你的应用程序掌握它们。如果你需要添加另外的CSS来支持单独的一部分，你可以这样做，深信它可以呈现在最终的页面里。 现在你可以输入http://localhost 检测一下，你应该可以看到XHTML的头部、header、title、body部分。

## Comments

**[firedragonpzy](#894 "2012-10-11 16:04:34"):** 不错。做个友情链接呗：【Software Myzone】:http://www.firedragonpzy.com.cn你的连接已做

