---
layout: post
title: MAC下安装ImageMagick及PHP扩展Imagick
category: 技术
date: 2013-06-10 11:34:12
tags: MAC ImageMagick Imagick
---


之前介绍过Linux下的安装，其实MAC下和Linux下安装基本类似。这里再重复下 他们的功能。

## imagick 介绍

[imagick](http://pecl.php.net/package/imagick)是一个[PHP](http://www.php.net/)的扩展，用[ImageMagick](http://www.imagemagick.org/)提供的API来进行图片的创建与修改，不过这些操作已经包装到扩展imagick中去了，最终调用的是ImageMagick提供的API。

## ImageMagick 介绍

ImageMagick是一套软件系列，主要用于图片的创建、编辑以及转换等，详细的解释见ImageMagick的官方网站<http://www.imagemagick.org/>，ImageMagick与GD的性能要高很多，如果是在处理大量的图片时更加能体现ImageMagick的性能。

英文原文介绍如下：  
imagick is a native php extension to create and modify images using the ImageMagick API. 

ImageMagick is a software suite to create, edit, and compose bitmap images.. It can read, convert and write images in a variety of formats (over 100) including DPX, EXR, GIF, JPEG, JPEG-2000, PDF, PhotoCD, PNG, Postscript, SVG, and TIFF. 

著名的图片服务提供商[Flickr](http://www.flickr.com/)使用的是ImageMagick，还有[Yupoo](http://www.yupoo.com/)、[手机之家](http://www.imobile.com.cn/)使用的也是ImageMagick。

## 一、安装环境及版本库
    
    
    OS: MAC OS X 10.8.3 
    
    PHP:5.3.20 
    
    ImageMagick:6.8.5 
    
    Imagick:3.0.1 
    

## 二、安装ImageMagick
    
    
    curl -O ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz  
    tar -zxf ImageMagick.tar.gz  
    cd ImageMagick-6.8.5-10/  
    ./configure --prefix=/usr/local/ImageMagick  
    make  
    sudo make install 
    

注：prefix这样写也可以：--prefix=/user/local/ImageMagick，但后面也要用相应的地址才可以

也可参考官方安装示例：http://www.imagemagick.org/script/install-source.php#unix

## 三、安装PHP扩展Imagick
    
    
    curl -O http://pecl.php.net/get/imagick-3.0.1.tgz
    tar -zxf  imagick-3.0.1.tgz
    cd imagick-3.0.1 
    /usr/local/php/bin/phpize
    export PKG_CONFIG_PATH=/usr/local/ImageMagick/lib/pkgconfig
    ./configure --with-php-config=/usr/local/php/bin/php-config \
    --with-imagick=/usr/local/ImageMagick
    make
    sudo make install 
    

安装后会有一段这个提示：
    
    
                 Option                        Value 
    -------------------------------------------------------------
    Shared libraries  --enable-shared=yes       yes
    Static libraries  --enable-static=yes       yes
    Module support    --with-modules=yes        yes
    GNU ld            --with-gnu-ld=no      no
    Quantum depth     --with-quantum-depth=16   16
    High Dynamic Range Imagery
                      --enable-hdri=no      no
    
    Delegate Configuration:
    BZLIB             --with-bzlib=yes      yes
    Autotrace         --with-autotrace=yes      no
    Dejavu fonts      --with-dejavu-font-dir=default    none
    DJVU              --with-djvu=yes       no
    DPS               --with-dps=yes        no
    FFTW              --with-fftw=yes       no
    FlashPIX          --with-fpx=yes        no
    FontConfig        --with-fontconfig=yes     no
    FreeType          --with-freetype=yes       yes
    GhostPCL          None              pcl6 (unknown)
    GhostXPS          None              gxps (unknown)
    Ghostscript       None              gs (unknown)
    Ghostscript fonts --with-gs-font-dir=default    none
    Ghostscript lib   --with-gslib=yes      no
    Graphviz          --with-gvc=yes        no
    JBIG              --with-jbig=yes       no
    JPEG v1           --with-jpeg=yes       no (failed tests)
    JPEG-2000         --with-jp2=yes        no
    LCMS v1           --with-lcms=yes       no
    LCMS v2           --with-lcms2=yes      no
    LQR               --with-lqr=yes        no
    LTDL              --with-ltdl=yes       yes
    LZMA              --with-lzma=yes       yes
    Magick++          --with-magick-plus-plus=yes   yes
    OpenEXR           --with-openexr=yes        no
    PANGO             --with-pango=yes      no
    PERL              --with-perl=yes       /usr/bin/perl
    PNG               --with-png=yes        yes
    RSVG              --with-rsvg=yes       no
    TIFF              --with-tiff=yes       no
    WEBP              --with-webp=yes       no
    Windows fonts     --with-windows-font-dir=  none
    WMF               --with-wmf=yes        no
    X11               --with-x=yes          yes
    XML               --with-xml=yes        yes
    ZLIB              --with-zlib=yes       yes
    

有一些必须是yes的，以后的命令才不会有问题。如：JPEG v1 如果为no，则以后转换图像会报错。

## 遇到的问题：

问题1:
    
    
    checking for MagickWand.h header file… configure: error: Cannot locate header file MagickWand.h  
    

原因:ImageMagick 6.8这个版后的目录结构变了,旧版本头文件是放在/usr/local/ImageMagick/include/ImageMagick目录的,而ImageMagick 6.8则是放在/usr/local/ImageMagick/include/ImageMagick-6

解决方法：添加软连接，命令如下
    
    
    ln -s /usr/local/ImageMagick/include/ImageMagick-6 \
    /usr/local/ImageMagick/include/ImageMagick make && make install
    

编译通过！

参考：<http://www.92csz.com/30/1232.html>

问题2:
    
    
    /usr/local/ImageMagick/bin/MagickWand-config: line 53: pkg-config: command not found
    

原因：没有安装pkg-config 工具

解决方法：
    
    
    brew install pkg-config 
    

问题3：错误信息
    
    
    ./php_imagick.h:49:12: fatal error: ‘wand/MagickWand.h’ file not found
    #  include <wand/MagickWand.h>
           ^
    1 error generated.
    make: *** [imagick_class.lo] Error 1
    

原因：没安装pkg-config 工具导致

解决方法：按照上一步安装pkg-config 即可。 ok,到此安装完毕。需要注意的是 少一个参数或者有一个不对的，可能会折腾好久。

问题4:
    
    
    convert: no decode delegate for this image format `3.jpg' \
    @ error/constitute.c/ReadImage/552  
    

原因: jpeg包没有没安装，或者是安装了但是ImageMagick没有找到。

解决方法: 重新编译ImageMagick
    
    
    ./configure CPPFLAGS="-I/usr/local/jpeg-8c \
    -I/usr/local/jpeg-8c/include" \
    LDFLAGS="-L/usr/local/lib \
    -L/usr/local/jpeg-8c/lib" \
    --prefix=/usr/local/ImageMagick
    

如果出现这个,说明安装成功：
    
    
    DELEGATES       = bzlib freetype jng jpeg lzma png x xml zlib
    

参考：<http://hi.baidu.com/quqiufeng/item/87fb24b9ef8ed1e84fc7fd3c>

## 相关参考：

<http://hi.baidu.com/quantumcloud/item/90f2c550994b88a2acc85724>

<http://doc.linuxpk.com/1864.html>

<http://blog.csdn.net/yasi_xi/article/details/8794930>
