---
layout: post
title: CentOS下安装ImageMagick及PHP扩展IMagick
category: 技术
date: 2011-11-19 11:30:28
tags: ImageMagick IMagick PHP扩展
---

做程序开发难免有时要对图片做处理，一般的有图片缩放、图片裁剪、图片编辑、图片加水印等等的一些工作。   
目前知道的一个好的处理软件的工具是：ImageMagick。   
官网地址：<http://www.imagemagick.org/>  

### 

## 一、ImageMagick 介绍

ImageMagick是一套功能强大、稳定而且免费的工具集和开发包，可以用来读、写和处理超过89种基本格式的图片文件，包括流行的TIFF、JPEG、GIF、 PNG、PDF以及PhotoCD等格式。  
利用ImageMagick，你可以根据web应用程序的需要动态生成图片, 还可以对一个(或一组)图片进行改变大小、旋转、锐化、减色或增加特效等操作，并将操作的结果以相同格式或其它格式保存。  
对图片的操作，即可以通过命令行进行，也可以用C/C++、Perl、Java、PHP、Python或Ruby编程来完成。同时ImageMagick提供了一个高质量的2D工具包，部分支持SVG。现在，ImageMagic的主要精力集中在性能、减少bug以及提供稳定的API和ABI上。    

功能：

1. 将图片从一个格式转换到另一个格式，包括直接转换成图标。
2. 改变尺寸、旋转、锐化(sharpen)、减色、图片特效
3. 缩略图片的合成图( a montage of image thumbnails)
4. 适于web的背景透明的图片
5. 将一组图片作成gif动画，直接convert
6. 将几张图片作成一张组合图片，montage
7. 在一个图片上写字或画图形，带文字阴影和边框渲染。
8. 给图片加边框或框架
9. 取得一些图片的特性信息
10. 几乎包括了gimp可以作到的常规插件功能。甚至包括各种曲线参数的渲染功能。只是那命令的写法，够复杂。
ImageMagick几乎可以在任何非专有的操作系统上编译，无论是32位还是64位的CPU，包括LINUX，Windows ’95/’98/ME/NT 4.0/2000/XP, Macintosh (MacOS 9 /10), VMS 和 OS/2.
 
特性：

1. 格式转换：从一种格式转换成图像到另一个(例如 PNG 转 JPEG)
2. 变换：缩放，旋转，裁剪，翻转或修剪图像
3. 透明度：使图像的部分变为透明
4. 附加：添加形状或一帧到图像
5. 装饰：添加边框或帧图像
6. 特效：模糊，锐化，阈值，或色彩图像动画：创建一个从GIF动画图像组序列
7. 文本及评论：插入描述或艺术图像中的文字
8. 图像识别：描述的格式和图像性能
9. 综合：重叠了一个又一个的图像
10. 蒙太奇：并列图像画布上的图像缩略图
11. 电影支持：读写图像的共同使用的数字电影工作方式
12. 图像计算器：应用数学表达式的图像或图像通道
13. 离散傅立叶变换：实现正向和反向的DFT。
14. 高动态范围图像：准确地表现了从最明亮的阳光直射到最深最黑暗的阴影找到真正的幕后广泛的强度水平
15. 加密或解密图片：转换成不懂乱码，然后再返回普通图像
16. 虚拟像素支持：方便以外区域的图像像素
17. 大图像支持：读，过程，或写mebi和吉比像素的图像尺寸
18. 执行：ImageMagick的是线程安全的，利用内部算法OpenMP的功能及快速的双核和四核处理器技术提供窗口优势
19. 异构分布式处理：某些算法可以在跨越的CPU，GPU，以及其他处理器组成的异构平台音乐会执行速度提高。 

## 二、ImageMagick 下载及安装

  1、安装环境要求 

  * CentOS 5.4+PHP+Nginx
  * 服务器如果没有安装Jpeg v6b、libPng、FreeType 的要在安装imagemagick之前先装好，否则imagemagick没法读取jpeg和png图片，字体文件也读不了。各种解码器可以从<http://www.imagemagick.org/download/delegates/> 下载。

更多安装包地址：

①、RedHat AS4 & CentOS 4 <http://mirrors.163.com/centos/4/os/i386/CentOS/RPMS/> <http://mirrors.163.com/centos/4/os/x86_64/CentOS/RPMS/>

②、RedHat AS5 & CentOS 5 <http://mirrors.163.com/centos/5/os/i386/CentOS/> <http://mirrors.163.com/centos/5/os/x86_64/CentOS/>

③、RPM包搜索网站 <http://rpm.pbone.net/> <http://www.rpmfind.net/> 2、下载 

> wget  <ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz>

注：如果以上链接无法下载，可以在这里：<http://www.imagemagick.org/script/download.php> 找到相应的镜像地址下载。 3、安装 

> tar xvfz ImageMagick.tar.gz cd ImageMagick-6.7.3 ./configure make sudo make install sudo ldconfig /usr/local/lib make check

4、测试是否安装成功的方法（自己找一张图片） 

> convert rose.jpg rose.png

如果成功，则会生成一张rose.png的图片 更多命令行的使用方法可以参考：<http://www.imagemagick.org/script/command-line-tools.php> 注：如果安装出现以下问题(一般为相应的软件包没有安装，如libjpeg、libpng、freetype等)： convert: no decode delegate for this image format `water.jpg'. 可以参考：<http://blog.csdn.net/chengbd/article/details/6667115>  

##  三、ImageMagick的PHP扩展IMagick的下载及安装

1、下载 

> wget  <http://pecl.php.net/get/imagick-3.0.1.tgz>

更多下载地址可参见：<http://pecl.php.net/package/imagick>   2、安装 

> tar zxvf imagick-2.3.0.tgz cd imagick-2.3.0/ /usr/local/webserver/php/bin/phpize ./configure --with-php-config=/usr/local/webserver/php/bin/php-config make make install

运行make install 提示： 

> /usr/local/webserver/php/lib/php/extensions/no-debug-non-zts-20060613/

现在可以在php.ini里加入imagick.so 

> vim  /usr/local/webserver/php/etc/php.ini

查找：extension_dir 在其下面加入： 

> extension = "imagick.so"

修改php.ini后不重启php-cgi，重新加载配置文件使用reload 

> /usr/local/webserver/php/sbin/php-fpm reload

注：php-fpm 其他参数包括：start|stop|quit|restart|reload|logrotate 3、检查imagick是否被安装成功的方法： 

> /usr/local/webserver/php/bin/php -m |grep imagick

如果有结果：imagick 说明安装成功。  

关于该扩展的更多文档可以参看：  
[http://cn2.php.net/manual/zh/book.imagick.php ](http://cn2.php.net/manual/zh/book.imagick.php)     
至此ImageMagick 及其扩安就安装完毕了，接下来就可以使用ImageMagick来处理图片了。