Title: 排序算法PHP版
Date: 2012-10-28 18:54:56
Tags: PHP, 排序算法

## 一、快速排序

### 1.简介

**快速排序**是由[东尼·霍尔](http://zh.wikipedia.org/wiki/%E6%9D%B1%E5%B0%BC%C2%B7%E9%9C%8D%E7%88%BE)所发展的一种[排序算法](http://zh.wikipedia.org/wiki/%E6%8E%92%E5%BA%8F%E7%AE%97%E6%B3%95)。在平均状况下，排序 _n_ 个项目要**[Ο**](http://zh.wikipedia.org/wiki/%E5%A4%A7O%E7%AC%A6%E5%8F%B7)(_n_ log _n_)次比较。在最坏状况下则需要**Ο**(_n_2)次比较，但这种状况并不常见。事实上，快速排序通常明显比其他**Ο**(_n_ log _n_) 算法更快，因为它的内部循环（inner loop）可以在大部分的架构上很有效率地被实现出来。  快速排序使用[分治法](http://zh.wikipedia.org/wiki/%E5%88%86%E6%B2%BB%E6%B3%95)（Divide and conquer）策略来把一个[串行](http://zh.wikipedia.org/wiki/%E5%BA%8F%E5%88%97)（list）分为两个子串行（sub-lists）。

### 2.步骤

  1. 从数列中挑出一个元素，称为 "基准"（pivot），
  2. 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为**分区（partition）**操作。
  3. [递归](http://zh.wikipedia.org/wiki/%E9%80%92%E5%BD%92)地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。

### 3.代码实现


    function quickSort(array $array)
     {
         $len = count($array);
         if($len <= 1)
         {
             return $array;
         }
         $key = $array[0];
         $left = array();
         $right = array();
         for($i=1; $i<$len; ++$i)
         {
             if($array[$i] < $key)
             {
                 $left[] = $array[$i];
             }
             else
             {
                 $right[] = $array[$i];
             }
         }
         $left = quickSort($left);
         $right = quickSort($right);
         return array_merge($left, array($key), $right);
     }

     print '<pre>';
     print_r(quickSort(array(1,4,22,5,7,6,9)));
     print '</pre>';

### 4.排序效果

![Sorting_quicksort_anim](http://upload.wikimedia.org/wikipedia/commons/6/6a/Sorting_quicksort_anim.gif) 使用快速排序法对一列数字进行排序的过程  

## 二、冒泡排序

 

### 1.简介

**冒泡排序**（**Bubble Sort**，台湾译为：**泡沫排序**或**气泡排序**）是一种简单的[排序算法](http://zh.wikipedia.org/wiki/%E6%8E%92%E5%BA%8F%E7%AE%97%E6%B3%95)。它重复地走访过要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。

### 2.步骤

  1. 比较相邻的元素。如果第一个比第二个大，就交换他们两个。
  2. 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。在这一点，最后的元素应该会是最大的数。
  3. 针对所有的元素重复以上的步骤，除了最后一个。
  4. 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。

### 3.代码实现


    <?php
     function bubbingSort(array $array)
     {
         for($i=0, $len=count($array)-1; $i<$len; ++$i)
         {
             for($j=$len; $j>$i; --$j)
             {
                 if($array[$j] < $array[$j-1])
                 {
                     $temp = $array[$j];
                     $array[$j] = $array[$j-1];
                     $array[$j-1] = $temp;
                 }
             }
         }
         return $array;
     }

     print '<pre>';
     print_r(bubbingSort(array(1,4,22,5,7,6,9)));
     print '</pre>';

### 4.排序过程

![Bubble_sort_animation](http://upload.wikimedia.org/wikipedia/commons/3/37/Bubble_sort_animation.gif) 使用冒泡排序为一列数字进行排序的过程   更多排序算法可以参考维基百科：[排序算法](http://zh.wikipedia.org/wiki/%E6%8E%92%E5%BA%8F%E7%AE%97%E6%B3%95)
