Title: PHP二维数组排序之系统函数排序和自定义函数排序
Date: 2013-12-25 15:33:20
Tags: PHP, 函数排序

## PHP二维数组排序之系统函数排序和自定义函数排序

关于排序一般我们都是通过数据库或者nosql(eg:redis)先排好序然后输出到程序里直接使用，但是有些时候我们需要通过PHP直接来对数组进行排序，而在PHP里存储数据用到最多的就是对象和数组，但处理较多的就是数组，因为有非常丰富的内置函数库（其实对象一定程度上也可以理解为是数组），这些函数库很大程度上可以帮助我们实现某些功能。常用的系统函数有sort、asort、arsort、ksort、krsort等等，这里我主要说下对二维数组的排序，两种方法：

### 1.用系统自带函数排序 array_multisort
    
    
    <?php
    
        $data = array();
        $data[] = array('volume' => 67, 'edition' => 2);
        $data[] = array('volume' => 86, 'edition' => 1);
        $data[] = array('volume' => 85, 'edition' => 6);
        $data[] = array('volume' => 98, 'edition' => 2);
        $data[] = array('volume' => 86, 'edition' => 6);
        $data[] = array('volume' => 67, 'edition' => 7);
    
        // 取得列的列表
        foreach ($data as $key => $row)
        {
            $volume[$key]  = $row['volume'];
            $edition[$key] = $row['edition'];
        }
    
        array_multisort($volume, SORT_DESC, $edition, SORT_ASC, $data);
    
        print_r($data);
    ?>
    

#### 输出结果：
    
    
    Array
    (
        [0] => Array
            (
                [volume] => 98
                [edition] => 2
            )
        [1] => Array
            (
                [volume] => 86
                [edition] => 1
            )
        [2] => Array
            (
                [volume] => 86
                [edition] => 6
            )
        [3] => Array
            (
                [volume] => 85
                [edition] => 6
            )
        [4] => Array
            (
                [volume] => 67
                [edition] => 2
            )
        [5] => Array
            (
                [volume] => 67
                [edition] => 7
            )
    )
    

关于array_multisort官方文档也有比较详细的说明：[array_multisort](http://www.php.net/manual/zh/function.array-multisort.php)

### 2\. 自定义函数排序
    
    
    <?php
        $data = array();
        $data[] = array('volume' => 67, 'edition' => 2);
        $data[] = array('volume' => 86, 'edition' => 1);
        $data[] = array('volume' => 85, 'edition' => 6);
        $data[] = array('volume' => 98, 'edition' => 2);
        $data[] = array('volume' => 86, 'edition' => 6);
        $data[] = array('volume' => 67, 'edition' => 7);
    
        // 取得列的列表
        foreach ($data as $key => $row)
        {
            $volume[$key]  = $row['volume'];
            $edition[$key] = $row['edition'];
        }
    
        $ret = arraySort($data, 'volume', 'desc');
    
        print_r($ret);
    
        /**
         * @desc arraySort php二维数组排序 按照指定的key 对数组进行排序
         * @param array $arr 将要排序的数组
         * @param string $keys 指定排序的key
         * @param string $type 排序类型 asc | desc
         * @return array
         */
        function arraySort($arr, $keys, $type = 'asc') {
            $keysvalue = $new_array = array();
            foreach ($arr as $k => $v){
                $keysvalue[$k] = $v[$keys];
            }
            $type == 'asc' ? asort($keysvalue) : arsort($keysvalue);
            reset($keysvalue);
            foreach ($keysvalue as $k => $v) {
               $new_array[$k] = $arr[$k];
            }
            return $new_array;
        }
    ?>
    

#### 输出结果：
    
    
    Array
    (
        [3] => Array
            (
                [volume] => 98
                [edition] => 2
            )
    
        [4] => Array
            (
                [volume] => 86
                [edition] => 6
            )
    
        [1] => Array
            (
                [volume] => 86
                [edition] => 1
            )
    
        [2] => Array
            (
                [volume] => 85
                [edition] => 6
            )
    
        [5] => Array
            (
                [volume] => 67
                [edition] => 7
            )
    
        [0] => Array
            (
                [volume] => 67
                [edition] => 2
            )
    
    )
    

这个自定义函数与系统函数的一个区别就是：自定义函数只支持针对某一个key的排序，如果要支持多个key的排序需要执行多次; 而系统函数[array_multisort](http://www.php.net/manual/zh/function.array-multisort.php)可以一次性对多个key且可以指定多个排序规则，系统函数还是相当强大的，推荐使用系统函数，毕竟是C底层实现的，这里只是举例说明如果通过自定义函数来对数组进行排序，当然这个自定义函数也可以继续扩展来支持更多的排序规则。在取排名、排行榜、成绩等场景中用到的还是非常多的。  
如有疑问欢迎拍砖，欢迎补充。
