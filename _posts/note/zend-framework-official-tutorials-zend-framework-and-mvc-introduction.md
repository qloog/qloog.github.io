Title: Zend Framework教程1-Zend Framework 及 MVC 介绍
Date: 2012-07-11 17:14:31
Tags: PHP , Zend Framework

## Zend Framework

Zend Framework 是一个开源的、面向对象的web应用程序框架为PHP5。Zend Framework经常被称为一个“组件库”，因为它有很多松散耦合的组件，你可以或多或少的独立使用它。但Zend Framework还提供了一个先进的模型-视图-控制器(MVC)的实现，可用于建立一个基本的结构为你的Zend Framework的应用程序。Zend Framework的带有简短描述的完整组件列表可以在这里找到：[组件概览](http://framework.zend.com/about/components)。这个快速入门将会向你介绍一些Zend Framework经常用到的组件，包括：Zend_Controller,Zend_Layout，Zend_Config，Zend_Db，Zend_Db_Table，Zend_Registry,还有一些视图helper。  通过使用这些组件，我们将在几分钟内即可构建一个简单的数据库驱动的留言板应用程序。对于这个留言板的完整源代码可以从以下的链接中得到： 

  * [» zip](http://framework.zend.com/demos/ZendFrameworkQuickstart.zip)
  * [» tar.gz](http://framework.zend.com/demos/ZendFrameworkQuickstart.tar.gz)

## Model-View-Controller

那么究竟什么是MVC模式，每个人都在不停的讨论着，你为什么会在意？MVC不仅仅是三个字母的首字母缩写（TLA）,用它你可以随时拿出来去口若悬河；它已经成为一种标准的现代web应用程序的设计，而且理由很充分。大多数web应用程序代码属于一下三种类别的一种：表现层，业务逻辑层和数据访问层。MVC模式模型这种关注点的分离。最终的结果是，你的表现层代码被合并到应用程序的一部分，业务逻辑层的数据在另一部分，数据访问层代码在其他一部分。许多开发人员已经发现让它们保持代码组织分离是不可或缺的，特别是当多个开发人员工作在同一个应用程序。 

> Note:More Information 让我们分解模式，看看各个部分： ![](http://lnmp100.b0.upaiyun.com/2012/07/learning.quickstart.intro_.mvc_.png) Model(模型):这是应用程序的一部分，它定义了的它基本功能基于抽象背后的。数据访问和一些业务逻辑也可以在模型中定义。 View(视图):确切低定义哪些视图显示给用户。通常控制器将数据以一定的格式传递给视图。视图也收集来自用户的数据。这就是你很可能会发现在你的MVC应用程序的HTML标记。 Controller(控制器):控制器将整个模式绑定在一起。他们操纵模型，决定哪些视图来显示基于用户的请求和其他因素，传递每个视图需要的数据，或者完整的从这个控制器转移到另一个控制器。大多数MVC专家建议：[尽可能的保持控制器的瘦小](http://weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model)。
