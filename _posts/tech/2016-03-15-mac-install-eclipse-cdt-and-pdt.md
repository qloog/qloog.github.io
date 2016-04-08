---
layout: post
title: Mac安装Eclipse插件PDT和CDT
category: tech
date: 2016-03-15
tags: Eclipse PDT CDT
---


在开发PHP 扩展的时候，十有八九会开发PHP，这样的话就可能会在PHP和C之间来回切换。
如果用IDE开发的话，可能会C一个IDE(Eclipse IDE for C/C++ Developers 或 Clion)，
PHP一个IDE(Eclipse for PHP Developers 或 PHPStorm)，这样的话可能就需要装两套IDE，
如果再开发其他的语言，那是不是需要再装一个呢？（当然用vim的可以跳过了哈。）

答案是：当然不用了！一个Eclipse搞定, 里面可以装不同语言的插件。

 > 写本文的时候Eclipse版本：Version: Mars.2 Release (4.5.2)

## 下载一个Eclipse基础版

打开：https://www.eclipse.org/downloads/ 找到：`Eclipse IDE for Java EE Developers`,然后选择对应操作系统的版本即可。

下面开始安装各种DT


## 安装Eclipse PHP开发环境 (PDT)

 下载地址：`http://www.eclipse.org/pdt/index.html`

 步骤： 在Eclipse, 菜单： Help -> Install New Software 在 work with 输入安装源： `http://download.eclipse.org/tools/pdt/updates/3.7`

![PDT](/static/uploads/2016/03/eclipse_pdt_install.png)


## 安装C开发环境 (CDT)

下载地址：https://eclipse.org/cdt/downloads.php

步骤： 在Eclipse, 菜单： Help -> Install New Software 在 work with 输入安装源： `http://download.eclipse.org/tools/cdt/releases/8.8.1`

![CDT](/static/uploads/2016/03/eclipse_cdt_install.png)


## 一次性安装

如果不想太麻烦，也可以通过一个安装源: http://download.eclipse.org/releases/indigo/ 来安装PDT  CDT
但是这个源不是最新的


![ONE-PDT](/static/uploads/2016/03/eclipse_pdt_from_one.png)

![ONE-CDT](/static/uploads/2016/03/eclipse_cdt_from_one.png)



