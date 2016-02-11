---
layout: post
title: PHP计算几个月(年/天/小时/分/秒)前的函数及类
date: 2012-05-20 23:02:12
category: 技术
tags: PHP 函数
---


用到此功能最多的可能就是比较火的微博和评论系统。现有两种实现方法。  1、函数实现 
    
    
    <?php
    function format_date($time){
        $t=time()-$time;
        $f=array(
            '31536000'=>'年',
            '2592000'=>'个月',
            '604800'=>'星期',
            '86400'=>'天',
            '3600'=>'小时',
            '60'=>'分钟',
            '1'=>'秒'
        );
        foreach ($f as $k=>$v)    {
            if (0 !=$c=floor($t/(int)$k)) {
                return $c.$v.'前';
            }
        }
    }
    ?>

2、类的实现 
    
    
    <?php
    /*
     * author: Solon Ring
     * time: 2011-11-02
     * 发博时间计算(年，月，日，时，分，秒)
     * $createtime 可以是当前时间
     * $gettime 你要传进来的时间
     */
    
    class Mygettime{
    
            function  __construct($createtime,$gettime) {
                $this->createtime = $createtime;
                $this->gettime = $gettime;
        }
    
        function getSeconds()
        {
                return $this->createtime-$this->gettime;
            }
    
        function getMinutes()
           {
           return ($this->createtime-$this->gettime)/(60);
           }
    
          function getHours()
           {
           return ($this->createtime-$this->gettime)/(60*60);
           }
    
          function getDay()
           {
            return ($this->createtime-$this->gettime)/(60*60*24);
           }
    
          function getMonth()
           {
            return ($this->createtime-$this->gettime)/(60*60*24*30);
           }
    
           function getYear()
           {
            return ($this->createtime-$this->gettime)/(60*60*24*30*12);
           }
    
           function index()
           {
                if($this->getYear() > 1)
                {
                     if($this->getYear() > 2)
                        {
                            return date("Y-m-d",$this->gettime);
                            exit();
                        }
                    return intval($this->getYear())." 年前";
                    exit();
                }
    
                 if($this->getMonth() > 1)
                {
                    return intval($this->getMonth())." 月前";
                    exit();
                }
    
                 if($this->getDay() > 1)
                {
                    return intval($this->getDay())." 天前";
                    exit();
                }
    
                 if($this->getHours() > 1)
                {
                    return intval($this->getHours())." 小时前";
                    exit();
                }
    
                 if($this->getMinutes() > 1)
                {
                    return intval($this->getMinutes())." 分钟前";
                    exit();
                }
    
               if($this->getSeconds() > 1)
                {
                    return intval($this->getSeconds()-1)." 秒前";
                    exit();
                }
    
           }
    
      }

类的实例 
    
    
    /*
     *
     * 调用类输出方式
     *
     * $a = new Mygettime(time(),strtotime('-25 month'));
     * echo iconv('utf-8', 'gb2312', $a->index())?iconv('utf-8', 'gb2312', $a->index()):iconv('utf-8', 'gb2312', '当前');
     *
     */
