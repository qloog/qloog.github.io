---
layout: post
title: cURL常用的几个PHP函数
category: 技术
date: 2012-04-04 15:15:28
tags: PHP curl
---


cURL是一个功能强大的PHP库，我们可以使用PHP的cURL采用GET、POST等方式发送请求，获取网页内容以及取一个XML文件并把其导入数据库等等。本文中收集了几种常用的PHP的cURL函数，以备使用。主要的有几个PHP函数用于：GET，POST，HTTP验证，302重定向，设置cURL的代理。  

## 使用cURL来GET数据
cURL最简单最常用的采用GET来获取网页内容的PHP函数 
    
    
      function getCURL($url){
            $curl = curl_init();
            curl_setopt($curl, CURLOPT_URL, $url);
            curl_setopt($curl, CURLOPT_HEADER, 0);
            curl_setopt($curl, CURLOPT_TIMEOUT, 3);     //超时时间
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            $data = curl_exec($curl);
            curl_close($curl);
            return $data;
        }

## 使用cURL来POST数据
当我们需要对cURL请求的页面采用POST的请求方式时，我们使用下面的PHP函数 
    
    
     function _curl_post($url, $vars)
        {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $vars);
            $data = curl_exec($ch);
            curl_close($ch);
            if ($data) {
                return $data;
            } else {
                return false;
            }
        }

## 使用cURL,需要HTTP服务器认证
当我们请求地址需要加上身份验证，即HTTP服务器认证的时候，我们就要使用下面的函数了，对于cURL中GET方法使用验证也是采用相同的方式。 
    
    
    function _curl_post($url, $vars)
    {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $vars);
        $data = curl_exec($ch);
        curl_close($ch);
        if ($data) {
            return $data;
        } else {
            return false;
        }
    }

## 使用cURL获取302重定向的页面
下面函数$data为重定向后页面的内容，这里我们写一个简单的cURL POST的302重定向后返回重定向页面URL的函数，有时候返回页面的URL更加重要。 
    
    
     function _curl_post_302($url, $vars)
        {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
            // 302 redirect
            curl_setopt($ch, CURLOPT_POSTFIELDS, $vars);
            $data = curl_exec($ch);
            $Headers = curl_getinfo($ch);
            curl_close($ch);
            if ($data&&$Headers) {
                return s$Headers["url"];
            } else {
                return false;
            }
        }

## 给cURL加个代理服务器
    
    
     $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, ‘http://js8.in‘);
        curl_setopt($ch, CURLOPT_HEADER, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_HTTPPROXYTUNNEL, 1);
        curl_setopt($ch, CURLOPT_PROXY, ‘代理服务器地址（js8.in）:端口’);
        curl_setopt($ch, CURLOPT_PROXYUSERPWD, ‘代理用户:密码’);
        $data = curl_exec();
        curl_close($ch);

## 一个cURL简单的类
    
    <?php
        /*
        Sean Huber CURL library
    
        This library is a basic implementation of CURL capabilities.
        It works in most modern versions of IE and FF.
    
        ==================================== USAGE ======================
        It exports the CURL object globally, so set a callback with setCallback($func).
        (Use setCallback(array('class_name', 'func_name')) to set a callback as a func
        that lies within a different class)
        Then use one of the CURL request methods:
    
        get($url);
        post($url, $vars); vars is a urlencoded string in query string format.
    
        Your callback function will then be called with 1 argument, the response text.
        If a callback is not defined, your request will return the response text.
        */
    
        class CURL {
            var $callback = false;
            
            function setCallback($func_name)
            {
                $this->callback = $func_name;
            }
            
            function doRequest($method, $url, $vars)
            {
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, $url);
                curl_setopt($ch, CURLOPT_HEADER, 1);
                curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
                curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookie.txt');
                curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookie.txt');
                if ($method == 'POST') {
                    curl_setopt($ch, CURLOPT_POST, 1);
                    curl_setopt($ch, CURLOPT_POSTFIELDS, $vars);
                }
                $data = curl_exec($ch);
                curl_close($ch);
                if ($data) {
                    if ($this->callback) {
                        $callback = $this->callback;
                        $this->callback = false;
                        return call_user_func($callback, $data);
                    } else {
                        return $data;
                    }
                } else {
                    return curl_error($ch);
                }
            }
            
            function get($url)
            {
                return $this->doRequest('GET', $url, 'NULL');
            }
            
            function post($url, $vars)
            {
                return $this->doRequest('POST', $url, $vars);
            }
        }
        ?>

## 参考阅读
  * <http://summerbluet.com/680>
  * <http://js8.in/379.html>
