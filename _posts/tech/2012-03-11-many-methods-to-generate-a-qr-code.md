---
layout: post
title: 生成QR二维码的多种方法
date: 2012-03-11 16:49:37
category: 技术
tags: QR 二维码
---


近来发现随着智能手机越来越普及，QR码(二维码)的使用也越来越多了，如网易应用下载中心、手机游戏下载网站、Google code下载中心、个人博客签名以及外面路上发的各种优惠小卡片里都印上了自己的二维码。 利用手机的拍照功能，再加上一些QR码识别软件，可以通过二维码来记录一些比较枯燥并不好记的信息，比如说长长的网址。很多手机软件下载网站都提供了可视化的下载路径，就是将下载路径做成QR码，让手机用户快速读取QR码中的下载链接转到下载页面。既然这么好用那么下面就做下简单的介绍及如何生成二维码(重点)吧。

## 简介

QR码是二维条码的一种，1994年由日本Denso-Wave公司发明。QR来自英文“Quick Response”的缩写，即快速反应的意思，源自发明者希望QR码可让其内容快速被解码。QR码最常见于日本，并为目前日本最流行的二维空间条码。QR码比普通条码可储存更多资料，亦无需像普通条码般在扫描时需直线对准扫描器。 QR码呈正方形，只有黑白两色。在3个角落，印有较小，像“回”字的的正方图案。这3个是帮助解码软件定位的图案，使用者不需要对准，无论以任何角度扫描，资料仍可正确被读取。 ** ** 更多介绍可以参看：<http://zh.wikipedia.org/wiki/QR%E7%A2%BC>  

## 存储

![qr_store](/static/uploads/2012/03/qr_store.png)  

## 生成二维码

### 用Google API快速生成QR码

其实用这个生成二维码很简单，调用以下链接，传入相应的参数就可以获取自己想要的二维码。 [https://chart.googleapis.com/chart?cht=qr&chs=200x200&choe=UTF-8&chld=L|4&chl=http://www.lnmp100.com/](https://chart.googleapis.com/chart?cht=qr&chs=200x200&choe=UTF-8&chld=L|4&chl=http://www.lnmp100.com/) 将其放到img的标签里，就可以生成QR码图片了。 ![google_chart](https://chart.googleapis.com/chart?cht=qr&chs=200x200&choe=UTF-8&chld=L|4&chl=http://www.lnmp100.com/)

链接里的参数说明一下：

  * https://chart.googleapis.com/chart?　这是Google Chart API的头部，直接照抄就行
  * &cht=qr　这是说图表类型为qr也就是二维码
  * &chs=200x200　这是说生成图片尺寸为200*200，是宽*高，这并不是生成图片的真实尺寸，应该是最大尺寸吧
  * &choe=UTF-8　这是说内容的编码格式为UTF-8，此值默认为UTF-8（其他的编码格式请参考[Google API文档](http://code.google.com/intl/zh-CN/apis/chart/infographics/docs/qr_codes.html)）
  * &chld=L|4　L代表默认纠错水平，4代表二维码边界空白大小，可自行调节（具体参数请参考[Google API文档](http://code.google.com/intl/zh-CN/apis/chart/infographics/docs/qr_codes.html)）
  * &chl=XXXX　这是QR内容，也就是解码后看到的信息，包含中文时请使用UTF-8编码汉字，否则将出现问题
更详细的可以参考Google API 文档： <http://code.google.com/intl/zh-CN/apis/chart/infographics/docs/qr_codes.html>  

### 用jQuery QR插件生成QR码

相关插件也不少，这里主要介绍：[jquery.qrcode.js](http://jeromeetienne.github.com/jquery-qrcode) ，demo代码如下：


    <html>
    <head>
    <title>basic example</title>
    </head>
    <body>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>

    <script type="text/javascript" src="http://jeromeetienne.github.com/jquery-qrcode/src/jquery.qrcode.js"></script>
    <script type="text/javascript" src="http://jeromeetienne.github.com/jquery-qrcode/src/qrcode.js"></script>

    <div id="qrcode"></div>
    <script>
    	//jQuery('#qrcode').qrcode("this plugin is great");
    	jQuery('#qrcode').qrcode({
    		render	: "table",
    		text	: "http://jetienne.com"
    	});
    </script>

    </body>
    </html>

这个插件生成的图片形式有：table 和 canvas 两种，但并没有生成真正的图片，如img标签。table下可能会出错,canvas 部分浏览器不支持。 官方链接：<http://jeromeetienne.github.com/jquery-qrcode/> 官方DEMO:<http://jeromeetienne.github.com/jquery-qrcode/examples/basic.html>  

### 用PHP的QR类库来生成QR码

  1. 下载地址：<http://sourceforge.net/projects/phpqrcode/>
  2. 本站演示地址：<http://www.lnmp100.com//demo/phpqrcode/index.php>
  3. 使用说明：
  ①将下载的phpqrcode-xxx.zip包解压到指定目录
  ②简单调用即可生成QR码

		<?php
		//导入qrlib.php 库文件
		include "qrlib.php";

		/**
		*调用png 函数
		*@param $data 图片中要包含的文本信息
		*@param $filename 文件名 eg:/data/images/test.png
		*@param $errorCorrectionLevel 错误纠正级别，有四级：L、M、Q、H
		*@param $matrixPointSize 生成的矩阵大小，1到10
		*/
		QRcode::png($data, $filename, $errorCorrectionLevel, $matrixPointSize, 2);
		?>


## 参考阅读
  * <http://www.cnblogs.com/hooray/archive/2012/02/17/2355560.html>
