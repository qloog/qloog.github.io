Title: Zend Framework教程4-创建一个模型和数据库表(MySQL版)
Date: 2012-07-15 17:22:47
Tags: PHP, Zend Framework


我们开始之前，让我们思考一个问题：这么多的类都放在哪里？我们怎样可以快速的找到他们？默认项目中，我们创建实例化了一个autoloader(自动加载类)。我们可以使其他的自动加载类依附于这个autoloader,这样它就知道在哪里找到不同的类。典型地，我希望我们的各种MVC类分组与相同的树下--假若这样，_application/_ \--大多数情况下使用共同的前缀。  **Zend_Controller_Front** 有一种“modules”的概念，它是一种独特迷你的应用程序。Modules模仿zf工具安装application/里的目录结构，里面所有的类都是以共同的前缀假定的：模块名称。application/本身就是一个模块--"default"或"application"模块。同样地，我们想设置autoloading资源在这个目录里。 **Zend_Application_Module_Autoloader** 提供了这么一个功能：需要将一个模块下的各种资源映射到适当的目录，同时也提供了一种标准的命名机制。一个类的实例化在bootstrap对象实例化期间已经默认创建；你的应用程序引导程序(bootstrap)默认使用"Application"作为模块前缀。同样地，我们的模块，表单，表类也将以"Application_"作为类的前缀。 现在，让我们思考下：什么构成了一个留言薄？通常，他们是一个带有评论、时间戳和电子邮件的一个简单列表条目。假设我们把它们存到数据库里，我们也想要对每一个条目有一个唯一标识符。我们也可能想去存储一个条目，取出一个单个的条目和索引整个条目。就其本身而言，一个简单的留言薄模块API看起来应该是这样： 
    
    
    // application/models/Guestbook.php
    
    class Application_Model_Guestbook
    {
        protected $_comment;
        protected $_created;
        protected $_email;
        protected $_id;
    
        public function __set($name, $value);
        public function __get($name);
    
        public function setComment($text);
        public function getComment();
    
        public function setEmail($email);
        public function getEmail();
    
        public function setCreated($ts);
        public function getCreated();
    
        public function setId($id);
        public function getId();
    }
    
    class Application_Model_GuestbookMapper
    {
        public function save(Application_Model_Guestbook $guestbook);
        public function find($id);
        public function fetchAll();
    }

**__get()**和**__set()**为我们访问单个的条目属性提供了一种方便的机制，代理其他的setters和getters。他们还将帮助我们确保在对象里的白名单里的属性是有效的。 **find()**和**fetchAll()**能够获取单个或所有的条目，而**save()**负责保存一个条目到数据库了。 从这里开始，我们要开始思考建立我们的数据库。 首先我们要初始化我们的Db资源。与Layout和View一样，我们可以提供对于Db资源的配置。我们可以通过使用命令: _zf configure db-adapter_ 来做这个。 
    
    
    % zf configure db-adapter "adapter=PDO_MYSQL&host=localhost&dbname=guestbook&username=root&password=" production
    A db configuration for the production has been written to the application config file.
    
    % zf configure db-adapter "adapter=PDO_MYSQL&host=localhost&dbname=guestbook&username=root&password=" testing
    A db configuration for the production has been written to the application config file.
    
    % zf configure db-adapter "adapter=PDO_MYSQL&host=localhost&dbname=guestbook&username=root&password=" development
    A db configuration for the production has been written to the application config file.

现在，编辑你的application/configs/application.ini 文件，在这里你可以看到以下的行被添加在适当的部分。 
    
    
    ; application/configs/application.ini
    
    [production]
    ; ...
    resources.db.adapter = "PDO_MYSQL"
    resources.db.params.host = "localhost"
    resources.db.params.dbname = "guestbook"
    resources.db.params.username = "root"
    resources.db.params.password = ""
    
    [testing : production]
    ; ...
    resources.db.adapter = "PDO_MYSQL"
    resources.db.params.host = "localhost"
    resources.db.params.dbname = "guestbook"
    resources.db.params.username = "root"
    resources.db.params.password = ""
    
    [development : production]
    ; ...
    resources.db.adapter = "PDO_MYSQL"
    resources.db.params.host = "localhost"
    resources.db.params.dbname = "guestbook"
    resources.db.params.username = "root"
    resources.db.params.password = ""

你的配置文件最终看起来应该是这个样子： 
    
    
    ; application/configs/application.ini
    
    [production]
    phpSettings.display_startup_errors = 0
    phpSettings.display_errors = 0
    bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
    bootstrap.class = "Bootstrap"
    appnamespace = "Application"
    resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
    resources.frontController.params.displayExceptions = 0
    resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"
    resources.view[] =
    resources.db.adapter = "PDO_MYSQL"
    resources.db.params.host = "localhost"
    resources.db.params.dbname = "guestbook"
    resources.db.params.username = "root"
    resources.db.params.password = ""
    
    [staging : production]
    
    [testing : production]
    phpSettings.display_startup_errors = 1
    phpSettings.display_errors = 1
    resources.db.adapter = "PDO_MYSQL"
    resources.db.params.host = "localhost"
    resources.db.params.dbname = "guestbook"
    resources.db.params.username = "root"
    resources.db.params.password = ""
    
    [development : production]
    phpSettings.display_startup_errors = 1
    phpSettings.display_errors = 1
    resources.db.adapter = "PDO_MYSQL"
    resources.db.params.host = "localhost"
    resources.db.params.dbname = "guestbook"
    resources.db.params.username = "root"
    resources.db.params.password = ""

  在这我们有一个到数据库的链接。在我们的例子中，这个链接是到MySQL数据库的。所以，让我们来设计一个简单的表来存储留言条目。 
    
    
    CREATE TABLE `guestbook` (
     `id` int(10) NOT NULL AUTO_INCREMENT,
     `email` char(32) NOT NULL,
     `comment` text NOT NULL,
     `created` datetime NOT NULL,
     PRIMARY KEY (`id`)
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8

让我们来创建一些工作数据，插入一些信息让我们对我们的应用程序更加感兴趣。 
    
    
    INSERT INTO  `guestbook`.`guestbook` (
    `id` ,
    `email` ,
    `comment` ,
    `created`
    )
    VALUES (
    NULL ,  'test1@lnmp100.com',  'lnmp100 test',  '2012-07-15 00:01:01');
    INSERT INTO  `guestbook`.`guestbook` (
    `id` ,
    `email` ,
    `comment` ,
    `created`
    )
    VALUES (
    NULL ,  'test2@lnmp100.com',  'www.lnmp100.com',  '2012-07-15 15:01:01')

现在我们有了一个完整的工作数据和表为我们的留言薄应用程序。接下来的几部就是构建我们的应用程序代码。这个包括构建数据源(在我们的例子中，使用Zend_Db_Table)，一个数据映射器链接那个数据源到我们的域模型。最后我们创建一个与这个模型相互作用的控制器，用它来显示存在的条目同时处理新的条目。
