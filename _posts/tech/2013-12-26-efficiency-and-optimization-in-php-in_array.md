---
layout: post
title: PHP中in_array 效率极其优化
category: 技术
date: 2013-12-26 12:05:20
tags: PHP in_array 优化
---

## PHP中in_array 效率极其优化

大家可能都用过in_array来判断一个数据是否在一个数组中，一般我们的数组可能数据都比较小，对性能没什么影响，所以也就不会太在意，但是如果数组比较大的时候，性能就会下降，运行的就会久一点，那如果针对在大数组情况下做优化呢，下面说两种方法(都是通过自定义函数来实现)：

### 1.数组key与value翻转，通过isset判断key是否存在于数组中
    
    
    /**
     * in_array is too slow when array is large
     */
    public static function inArray($item, $array) {
        $flipArray = array_flip($array);
        return isset($flipArray[$item]);
    }
    

大家可能也会问为什么不用 array_key_exists 来做判断二用isset呢？ 下面看下array_key_exists() 与 isset() 的对比：

> isset()对于数组中为NULL的值不会返回TRUE，而array_key_exists()会。
    
    
    <?php
    $search_array = array('first' => null, 'second' => 4);
    
    // returns false
    isset($search_array['first']);
    
    // returns true
    array_key_exists('first', $search_array);
    ?>
    

### 2.用implode连接，直接用strpos判断

用implode函数+逗号连起来，直接用strpos判断。php里面字符串取位置速度非常快，尤其是在大数据量的情况下。不过需要注意的是首尾都要加"," ,这样比较严谨。如: ,user1,user2,user3, 查找的时候，查,user1,。还有strpos要用!== false，因为第一个会返回0。示例如下:
    
    
    /**
     * in_array is too slow when array is large
     */
    public static function inArray($item, $array) {
        $str = implode(',', $array);
        $str = ',' . $str . ',';
        $item = ',' . $item . ',';
        return false !== strpos($item, $str) ? true : false;
    }
    

关于in_array的执行效率分析可以查看：[php中的in_array函数效率分析](http://www.server110.com/php/201309/1150.html)
