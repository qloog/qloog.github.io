---
layout: post
title: PHP获取用户真实ip及城市地理位置
date: 2013-09-22 11:13:42
category: 技术
tags: PHP ip 地理位置
---


## PHP获取用户真实ip及城市地理位置

自己不需ip库，免更新。采用淘宝IP库： http://ip.taobao.com
    
    
    <?php
    /**
     * 获取用户真实 IP
     */
    function getIP()
    {
        static $realip;
        if (isset($_SERVER)){
            if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])){
                $realip = $_SERVER["HTTP_X_FORWARDED_FOR"];
            } else if (isset($_SERVER["HTTP_CLIENT_IP"])) {
                $realip = $_SERVER["HTTP_CLIENT_IP"];
            } else {
                $realip = $_SERVER["REMOTE_ADDR"];
            }
        } else {
            if (getenv("HTTP_X_FORWARDED_FOR")){
                $realip = getenv("HTTP_X_FORWARDED_FOR");
            } else if (getenv("HTTP_CLIENT_IP")) {
                $realip = getenv("HTTP_CLIENT_IP");
            } else {
                $realip = getenv("REMOTE_ADDR");
            }
        }
    
    
        return $realip;
    }
    
    
    /**
     * 获取 IP  地理位置
     * 淘宝IP接口
     * @Return: array
     */
    function getCity($ip)
    {
        $url = "http://ip.taobao.com/service/getIpInfo.php?ip=" . $ip;
        $ip = json_decode(file_get_contents($url)); 
        if((string)$ip->code == '1') {
            return false;
        }
        $data = (array)$ip->data;
        return $data; 
    }
