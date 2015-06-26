Title: Zend Framework教程8-自动加载之目标和设计
Date: 2012-07-18 23:33:35
Tags: PHP, Zend Framework


**1、类命名的约定**

为了更好的理解Zend Framework的自动加载机制，首页你需要理解类名和类文件之间的关系。

Zend Framework借鉴了[PEAR](http://pear.php.net/)的思想，即类名都有一个1：1的关系与文件系统。简言之，下划线“_”是被目录分隔符所取代为了解决文件路径，然后加上后缀”.php”。例如，类“Foo_Bar_Baz”会对应于文件系统的“Foo/Bar/Baz.php”。假设是类可以解决通过PHP **include_path**的设置，允许**include()**和**require()**来找到文件名通过相对路径在**include_path**里。

另外，我们使用每个PEAR及[PHP项目](http://php.net/userlandnaming.tips)，也推荐在你的代码里使用第三方或工程前缀。这意思就是你写的所有类将共享一个公共类前缀；例如，在Zend Framework里的所有代码都有一个前缀”Zend_”。这种命名的约定可以帮助避免命名冲突。在Zend Framework，我们通常称之为命名空间前缀；请不要误认为这时PHP的本地命名空间实现。

Zend Framework内部遵循这些简单的规则，我们的编码标准鼓励你也这样做为所有库代码。

**2、自动加载Autoloader的约定和设计**

Zend Framework的自动加载支持，主要提供**Zend_Loader_Autoloader**,遵循了以下的目标和设计元素：

  * 提供命名空间匹配。如果类的命名前缀不在已注册列表里，则立即返回false。这将会更乐观的匹配，以及退回到其它自动加载器。
  * 允许自动加载器担任后备自动加载器。在这种情况下，一个团队可能广泛地使用分布式，或者使用没有定义好的命名前缀，自动加载器将任然可以这样配置，试图去尝试任何命名空间。然后，要注意，这种做法是不推荐的，因为他可能会导致不必须的查找。
  * 允许切换错误抑制。我们感觉到，PHP社区已经做的非常好了，错误抑制是个错误的想法。它是非常有代价的，它掩盖了真正的应用程序错误。所以，默认情况下，错误开关应该是关闭的。然后，如果开发者坚持要打开，就让它打开吧。
  * 自动加载时允许指定自定义回调。一些开发者不想使用**Zend_Loader::loadClass()**在自动加载时，但任然想使用Zend Framework的机制。**Zend_Loader_Autoloader**允许指定一个交替的回调在自动加载时。
  * 允许简单程序语言操作的自动加载回调链。这个目的就是允许指定另外的自动加载器。例如，类的资源加载不许是1:1映射到文件系统，要在主Zend Framework自动加载器之前或之后注册。

英文原文链接：<http://framework.zend.com/manual/en/learning.autoloading.design.html>
