---
layout: post
title: 常用的中文字符串截取函数
date: 2012-02-23 23:09:31
category: 代码
tags: 字符串截取
---


截取中文字符串的方法有很多，现整理几个常用的。 
    
    
    /**
    +----------------------------------------------------------
    * 字符串截取，支持中文和其他编码
    +----------------------------------------------------------
    * @param string $source 需要转换的字符串
    * @param string $start 开始位置
    * @param string $length 截取长度
    * @param string $charset 编码格式
    * @param string $suffix 截断显示字符后缀
    +----------------------------------------------------------
    * @return string
    +----------------------------------------------------------
    */
    function xs_substr($source, $start=0, $length, $charset="utf-8", $suffix="")
    {
    	if(function_exists("mb_substr"))        //采用PHP自带的mb_substr截取字符串
    	{
    		$string = mb_substr($source, $start, $length, $charset).$suffix;
    	}
    	elseif(function_exists('iconv_substr')) //采用PHP自带的iconv_substr截取字符串
    	{
    		$string = iconv_substr($source,$start,$length,$charset).$suffix;
    	}
    	else
    	{
    		$pattern['utf-8']   = "/[x01-x7f]|[xc2-xdf][x80-xbf]|[xe0-xef][x80-xbf]{2}|[xf0-xff][x80-xbf]{3}/";
    		$pattern['gb2312'] = "/[x01-x7f]|[xb0-xf7][xa0-xfe]/";
    		$pattern['gbk']    = "/[x01-x7f]|[x81-xfe][x40-xfe]/";
    		$pattern['big5']   = "/[x01-x7f]|[x81-xfe]([x40-x7e]|xa1-xfe])/";
    		preg_match_all($pattern[$charset], $source, $match);
    		$slice = join("",array_slice($match[0], $start, $length));
    		 
    		$string = $slice.$suffix;
    	}
    	return $string;
    }