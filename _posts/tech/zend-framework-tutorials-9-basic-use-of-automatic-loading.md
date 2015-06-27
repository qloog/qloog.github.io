Title: Zend Framework教程9-自动加载的基本使用
Date: 2012-07-21 19:29:41
Tags: PHP, Zend Framework

现在让我们理解下自动加载是什么以及Zend Framework自动加载方案的设计和目标，让我们看下怎么样去使用**Zend_Loader_Autoloader**。  在简单的实例中，你要简单的包含这个类，并实例化。既然**Zend_Loader_Autoloader**是一个单例（由于这个事实：标准PHP类库自动加载器是一个单例资源），我们通过**getInstance()**来得到一个实例。 
    
    
    require_once 'Zend/Loader/Autoloader.php';
    Zend_Loader_Autoloader::getInstance();

默认情况下，允许加载任何以”Zend_”和”ZendX_”为类命名前缀的类，只要这些类是在**include_path**. 如果你想要用其他你想要使用的命名前缀，那怎么办呢？最好最简单额方法就是在获取实例的时候调用registerNamespace()方法。你可以通过一个简单的命名前缀，或者一组。 
    
    
    require_once 'Zend/Loader/Autoloader.php';
    $loader = Zend_Loader_Autoloader::getInstance();
    $loader->registerNamespace('Foo_');
    $loader->registerNamespace(array('Foo_', 'Bar_'));

交替地，你可以通知Zend_Loader_Autoloader去担当一个备用自动加载器的作用。这意味这将尝试去解析任何类，不管是什么命名前缀。 
    
    
    $loader->setFallbackAutoloader(true);

警告： 不要作为一个备用自动加载器来使用。 当使用Zend_Loader_Autoloader作为一个备用自动加载器时也是非常诱人的，我们并不推荐这么做。 本质上，**Zend_Loader_Autoloader**使用**Zend_Loader::loadClass()**加载类。这个方法使用include()尝试去加载给定的类文件。**include()**如果不成功的话，将返回一个布尔值false，也会发出PHP警告。可能会导致以下提示： 

  * 如果**display_errors**已经启用，会给出警告提示。
  * 依据你这选定的**error_reporting**级别，也会输出到日志里。
你可以抑制错误消息，但要注意只有当**display_errors**启用的时候抑制才会起作用；错误日志将会显示消息。由于这些原因，我们推荐配置命名前缀的自动加载器，这应该是知道的。 注：命名前缀 VS PHP命名空间 当时，PHP5.3已经发布。在这个版本里，PHP已经正式的支持命名空间。然而，Zend Framwork 先于PHP5.3。在Zend Framework里，我们提到的命名空间，指的是一个带有”Zend_”前缀的类。例如，所有的Zend Framework类名都是带有”Zend_”前缀的--也就是我们的”namespace”。 Zend Framework在以后的版本中会将PHP namespace支持加到自动加载器里。zf的类库在2.0.0版本里也将支持namespaces。 英文原文链接：<http://framework.zend.com/manual/en/learning.autoloading.usage.html>
