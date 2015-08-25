---
layout: post
title: PHP二维数组排序的实现方法
date: 2011-11-17 13:40:40
category: 技术
tags: 二维数组排序 PHP
---


有时候为了达到一定目的，需要对二维数组进行排序，现分享一下其实现的方法。 
    
    
    $arr=array (
    '1' => array ( 'date' => '2011-08-18', 'num' => 5 ) ,
    '2' => array ( 'date' => '2011-08-20', 'num' => 3 ) ,
    '3' => array ( 'date' => '2011-08-17', 'num' => 10 )
     )  ;
    
    
     $result = sysSortArray($arr,'num');

这样运行之后的效果为： 
    
    
    $arr=array (
    '1' => array ( 'date' => '2011-08-18', 'num' => 3 ) ,
    '2' => array ( 'date' => '2011-08-20', 'num' => 5 ) ,
    '3' => array ( 'date' => '2011-08-17', 'num' => 10 )
     )  ;

用到的函数： 
    
    
    /**
     * @package     二维数组排序
     * @version     $Id: FunctionsMain.inc.php,v 1.32 2011/09/24 11:38:37 wwccss Exp $
     *
     *
     * Sort an two-dimension array by some level two items use array_multisort() function.
     *
     * sysSortArray($Array,"Key1","SORT_ASC","SORT_RETULAR","Key2";……)
     * @author                      lamp100
     * @param  array   $ArrayData   the array to sort.
     * @param  string  $KeyName1    the first item to sort by.
     * @param  string  $SortOrder1  the order to sort by("SORT_ASC"|"SORT_DESC")
     * @param  string  $SortType1   the sort type("SORT_REGULAR"|"SORT_NUMERIC"|"SORT_STRING")
     * @return array                sorted array.
     */
    function sysSortArray($ArrayData,$KeyName1,$SortOrder1 = "SORT_ASC",$SortType1 = "SORT_REGULAR")
    {
        if(!is_array($ArrayData))
        {
            return $ArrayData;
        }
    
        // Get args number.
        $ArgCount = func_num_args();
    
        // Get keys to sort by and put them to SortRule array.
        for($I = 1;$I < $ArgCount;$I ++)
        {
            $Arg = func_get_arg($I);
            if(!eregi("SORT",$Arg))
            {
                $KeyNameList[] = $Arg;
                $SortRule[]    = '$'.$Arg;
            }
            else
            {
                $SortRule[]    = $Arg;
            }
        }
    
        // Get the values according to the keys and put them to array.
        foreach($ArrayData AS $Key => $Info)
        {
            foreach($KeyNameList AS $KeyName)
            {
                ${$KeyName}[$Key] = $Info[$KeyName];
            }
        }
    
        // Create the eval string and eval it.
        $EvalString = 'array_multisort('.join(",",$SortRule).',$ArrayData);';
        eval ($EvalString);
        return $ArrayData;
    }

另外：array_multisort 函数功能也很强大，详细可以参看PHP手册，里面讲的很详细。