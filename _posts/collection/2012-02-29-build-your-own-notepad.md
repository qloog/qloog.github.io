---
layout: post
title: 打造属于自己的Notepad++
date: 2012-02-29 15:03:03
category: 收藏
tags: Notepad
---

Notepad++ 是一款Windows环境下免费开源的代码编辑器,最近一直在用，默认的可能没那么好用，需要来设置和添加插件、主题，这样用起来会舒服些！以下是直接转过来的，以后用到的插件再慢慢加进来吧。

## 代码自动提示设置
Notepad++ 默认是没有打开这个功能的，设置方法如下：
打开[首选项]->[备份与自动完成]，按下图设置
![notepad_auto_complete](/static/uploads/2012/02/notepad_auto_complete.png)  

## 安装插件
因为 Notepad++ 的小巧，就给了它更多的空间用来扩展，其丰富的插件功能让 Notepad++ 如虎添翼。
这里我只介绍两款插件:

  * 就是 [Zen Coding](http://code.google.com/p/zen-coding/downloads/detail?name=Zen.Coding-Notepad%2B%2B.v0.7.zip)
下载地址：http://code.google.com/p/zen-coding/ 下载最新版。 使用教程可以参看：http://rpsh.net/archives/zen-coding-npp/
  * 就是 QuickText 下载地址：<http://sourceforge.net/apps/mediawiki/notepad-plus/index.php?title=Plugin_Central> 这两款插件配合使用，可以让你写代码的速度快上十倍，可以说是 Notepad++ 的必备插件（至少我是少不了这两个插件的）

## 皮肤更换
默认支持十五中皮肤：更换方法： 设置---语言格式设置---选择主题----保存并关闭 ![notepad_default_style](/static/uploads/2012/02/notepad_default_style.bmp)  

## 使用外部主题

 1. 到[Textmate Theme Directory](http://wiki.macromates.com/Themes/UserSubmittedThemes)里找一个你喜欢的主题；
 2. 下载这个主题，用任何文本[编辑器](http://www.aspxhome.com/search.asp?tag=?)把它打开，复制所有代码，贴到[theme converter page](http://framework.lojcomm.com.br/tmtheme2nppstyler/)	里，然后“Download”；
 3. 把转化完的主题放到“D:\Program Files\Notepad++\themes” 中；
 4. 将文件名改为stylers.xml； 5 关闭你的Notepad++，重新打开，通过上面的选择和设置主题，你的新主题是不是已经起作用了?
 	![style_demo](//static/uploads/2012/02/style_demo.png)
