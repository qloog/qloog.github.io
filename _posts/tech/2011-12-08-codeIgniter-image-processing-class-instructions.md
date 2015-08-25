---
layout: post
title: CodeIgniter 的图像处理类使用说明
date: 2011-12-08 17:53:45
category: 技术
tages: CodeIgniter
---



CI框架下路径：system/libraries/Image_lib.php 以下主要对图像处理类的参数做一下说明汇总： 
    
    
    //缩略图
    /**
    
    注意
    
    1、当$config['create_thumb']等于FALSE并且$config['new_image']没有指定
    时，会调整原图的大小
    2、当$config['create_thumb']等于TRUE并且$config['new_image']没有指定
    时，生成文件名为(原图名_thumb.扩展名)
    
    3、当$config['create_thumb']等于FALSE并且$config['new_image']指定时，
    生成文件名为$config['new_image']的值
    
    4、当$config['create_thumb']等于TRUE并且$config['new_image']指定时，
    生成文件名为(原图名_thumb.扩展名)
    
    　　*/
    
    　　$config['image_library'] = 'gd2';//(必须)设置图像库
    
    　　$config['source_image'] = 'ptjsite/upload/55002.jpg';//(必须)设置原始图像的名字/路径
    
    　　$config['dynamic_output'] = FALSE;//决定新图像的生成是要写入硬盘还是动态的存在
    
    　　$config['quality'] = '90%';//设置图像的品质。品质越高，图像文件越大
    
    　　$config['new_image'] = 'ptjsite/upload/resize004.gif';//设置图像的目标名/路径。
    
    　　$config['width'] = 575;//(必须)设置你想要得图像宽度。
    
    　　$config['height'] = 350;//(必须)设置你想要得图像高度
    
    　　$config['create_thumb'] = TRUE;//让图像处理函数产生一个预览图像(将_thumb插入文件扩展名之前)
    
    　　$config['thumb_marker'] = '_thumb';//指定预览图像的标示。它将在被插入文件扩展名之前。例如，mypic.jpg 将会变成 mypic_thumb.jpg
    
    　　$config['maintain_ratio'] = TRUE;//维持比例
    
    　　$config['master_dim'] = 'auto';//auto, width, height 指定主轴线
    
    　　$this->image_lib->initialize($config);
    
    　　if (!$this->image_lib->resize()){
    
    　　echo $this->image_lib->display_errors();
    
    　　}else{
    
    　　echo "ok";
    
    　　}
    
    　　//图像裁剪
    
    　　$config['image_library'] = 'gd2';//设置图像库
    
    　　$config['source_image'] = 'ptjsite/upload/004.gif';//(必须)设置原始图像的名字/路径
    
    　　$config['dynamic_output'] = FALSE;//决定新图像的生成是要写入硬盘还是动态的存在
    
    　　$config['quality'] = '90%';//设置图像的品质。品质越高，图像文件越大
    
    　　$config['new_image'] = 'ptjsite/upload/crop004.gif';//(必须)设置图像的目标名/路径。
    
    　　$config['width'] = 75;//(必须)设置你想要得图像宽度。
    
    　　$config['height'] = 50;//(必须)设置你想要得图像高度
    
    　　$config['maintain_ratio'] = TRUE;//维持比例
    
    　　$config['x_axis'] = '30';//(必须)从左边取的像素值
    
    　　$config['y_axis'] = '40';//(必须)从头部取的像素值
    
    　　$this->image_lib->initialize($config);
    
    　　if (!$this->image_lib->crop())
    
    　　{
    
    　　echo $this->image_lib->display_errors();
    
    　　}else{
    
    　　echo "成功的";
    
    　　}
    
    　　//图像旋转
    
    　　$config['image_library'] = 'gd2';//(必须)设置图像库
    
    　　$config['source_image'] = 'ptjsite/upload/001.jpg';//(必须)设置原始图像的名字/路径
    
    　　$config['dynamic_output'] = FALSE;//决定新图像的生成是要写入硬盘还是动态的存在
    
    　　$config['quality'] = '90%';//设置图像的品质。品质越高，图像文件越大
    
    　　$config['new_image'] = 'ptjsite/upload/rotate001.jpg';//设置图像的目标名/路径
    
    　　$config['rotation_angle'] = 'vrt';//有5个旋转选项 逆时针90 180 270 度 vrt 竖向翻转 hor 横向翻转
    
    　　$this->image_lib->initialize($config);
    
    　　if ( ! $this->image_lib->rotate())
    
    　　{
    
    　　echo $this->image_lib->display_errors();
    
    　　}
    
    　　//文字水印
    
    　　$config['image_library'] = 'gd2';//(必须)设置图像库
    
    　　$config['source_image'] = 'ptjsite/upload/003.jpg';//(必须)设置原图像的名字和路径. 路径必须是相对或绝对路径，但不能是URL.
    
    　　$config['dynamic_output'] = FALSE;//TRUE 动态的存在(直接向浏览器中以输出图像),FALSE 写入硬盘
    
    　　$config['quality'] = '90%';//设置图像的品质。品质越高，图像文件越大
    
    　　$config['new_image'] = 'ptjsite/upload/crop004.gif';//设置图像的目标名/路径。
    
    　　$config['wm_type'] = 'overlay';//(必须)设置想要使用的水印处理类型(text, overlay)
    
    　　$config['wm_padding'] = '5';//图像相对位置(单位像素)
    
    　　$config['wm_vrt_alignment'] = 'middle';//竖轴位置 top, middle, bottom
    
    　　$config['wm_hor_alignment'] = 'center';//横轴位置 left, center, right
    
    　　$config['wm_vrt_offset'] = '0';//指定一个垂直偏移量(以像素为单位)
    
    　　$config['wm_hor_offset'] = '0';//指定一个横向偏移量(以像素为单位)
    
    　　/* 文字水印参数设置 */
    
    　　$config['wm_text'] = 'Copyright 2008 - John Doe';//(必须)水印的文字内容
    
    　　$config['wm_font_path'] = 'ptj_system/fonts/type-ra.ttf';//字体名字和路径
    
    　　$config['wm_font_size'] = '16';//(必须)文字大小
    
    　　$config['wm_font_color'] = 'FF0000';//(必须)文字颜色，十六进制数
    
    　　$config['wm_shadow_color'] = 'FF0000';//投影颜色，十六进制数
    
    　　$config['wm_shadow_distance'] = '3';//字体和投影距离(单位像素)。
    
    　　/* 图像水印参数设置 */
    
    　　/*
    
    　　$config['wm_overlay_path'] = 'ptjsite/upload/overlay.png';//水印图像的名字和路径
    
    　　$config['wm_opacity'] = '50';//水印图像的透明度
    
    　　$config['wm_x_transp'] = '4';//水印图像通道
    
    　　$config['wm_y_transp'] = '4';//水印图像通道
    
    　　*/
    
    　　$this->image_lib->initialize($config);
    
    　　$this->image_lib->watermark();
    
    　　}
    
    　　//图像水印
    
    　　$config['image_library'] = 'gd2';//(必须)设置图像库
    
    　　$config['source_image'] = 'ptjsite/upload/003.jpg';//(必须)设置原图像的名字和路径. 路径必须是相对或绝对路径，但不能是URL.
    
    　　$config['dynamic_output'] = FALSE;//TRUE 动态的存在(直接向浏览器中以输出图像),FALSE 写入硬盘
    
    　　$config['quality'] = '90%';//设置图像的品质。品质越高，图像文件越大
    
    　　$config['new_image'] = 'ptjsite/upload/crop004.gif';//设置图像的目标名/路径。
    
    　　$config['wm_type'] = 'overlay';//(必须)设置想要使用的水印处理类型(text, overlay)
    
    　　$config['wm_padding'] = '5';//图像相对位置(单位像素)
    
    　　$config['wm_vrt_alignment'] = 'middle';//竖轴位置 top, middle, bottom
    
    　　$config['wm_hor_alignment'] = 'center';//横轴位置 left, center, right
    
    　　$config['wm_vrt_offset'] = '0';//指定一个垂直偏移量(以像素为单位)
    
    　　$config['wm_hor_offset'] = '0';//指定一个横向偏移量(以像素为单位)
    
    　　/* 文字水印参数设置 */
    
    　　/*
    
    　　$config['wm_text'] = 'Copyright 2008 - John Doe';//(必须)水印的文字内容
    
    　　$config['wm_font_path'] = 'ptj_system/fonts/type-ra.ttf';//字体名字和路径
    
    　　$config['wm_font_size'] = '16';//(必须)文字大小
    
    　　$config['wm_font_color'] = 'FF0000';//(必须)文字颜色，十六进制数
    
    　　$config['wm_shadow_color'] = 'FF0000';//投影颜色，十六进制数
    
    　　$config['wm_shadow_distance'] = '3';//字体和投影距离(单位像素)。
    
    　　*/
    
    　　/* 图像水印参数设置 */
    
    　　$config['wm_overlay_path'] = 'ptjsite/upload/overlay.png';//水印图像的名字和路径
    
    　　$config['wm_opacity'] = '50';//水印图像的透明度
    
    　　$config['wm_x_transp'] = '4';//水印图像通道
    
    　　$config['wm_y_transp'] = '4';//水印图像通道
    
    　　$this->image_lib->initialize($config);
    
    　　$this->image_lib->watermark();
    
    　　}


