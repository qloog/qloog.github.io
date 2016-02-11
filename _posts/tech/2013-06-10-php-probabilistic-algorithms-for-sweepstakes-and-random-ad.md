---
layout: post
title: PHP概率算法（适用于抽奖、随机广告）
date: 2013-06-10 18:18:45
category: 技术
tags: PHP 概率 抽奖
---

做网站类的有时会弄个活动什么的，来让用户参加，既吸引用户注册，又提高网站的用户活跃度。同时参加的用户会获得一定的奖品，有100%中奖的，也有按一定概率中奖的，大的比如中个ipad、iphone5，小的中个Q币什么的。那么我们在程序里必然会设计到算法，即按照一定的概率让用户获得奖品。先来看两个概率算法函数。

## 算法一
    
    
    /**
     * 全概率计算
     *
     * @param array $p array('a'=>0.5,'b'=>0.2,'c'=>0.4)
     * @return string 返回上面数组的key
     */
    function random($ps){
        static $arr = array();
        $key = md5(serialize($ps));
    
        if (!isset($arr[$key])) {
            $max = array_sum($ps);
            foreach ($ps as $k=>$v) {
                $v = $v / $max * 10000;
                for ($i=0; $i<$v; $i++) $arr[$key][] = $k;
            }
        }
        return $arr[$key][mt_rand(0,count($arr[$key])-1)];
    }  
    

## 算法二
    
    
    function get_rand($proArr) { 
        $result = ''; 
    
        //概率数组的总概率精度
        $proSum = array_sum($proArr); 
    
        //概率数组循环
        foreach ($proArr as $key => $proCur) { 
            $randNum = mt_rand(1, $proSum); 
            if ($randNum <= $proCur) { 
                $result = $key; 
                break; 
            } else { 
                $proSum -= $proCur; 
            } 
        } 
        unset ($proArr); 
    
        return $result; 
    }
    

上述代码是一段经典的概率算法，$proArr是一个预先设置的数组，假设数组为：array(100,200,300，400)，开始是从1,1000这个概率范围内筛选第一个数是否在他的出现概率范围之内， 如果不在，则将概率空减，也就是k的值减去刚刚的那个数字的概率空间，在本例当中就是减去100，也就是说第二个数是在1，900这个范围内筛选的。这样筛选到最终，总会有一个数满足要求。就相当于去一个箱子里摸东西，第一个不是，第二个不是，第三个还不是，那最后一个一定是。这个算法简单，而且效率非常高，关键是这个算法已在我们以前的项目中有应用，尤其是大数据量的项目中效率非常棒。

接下来我们通过PHP配置奖项。
    
    
    $prize_arr = array( 
        '0' => array('id'=>1,'prize'=>'平板电脑','v'=>1), 
        '1' => array('id'=>2,'prize'=>'数码相机','v'=>5), 
        '2' => array('id'=>3,'prize'=>'音箱设备','v'=>10), 
        '3' => array('id'=>4,'prize'=>'4G优盘','v'=>12), 
        '4' => array('id'=>5,'prize'=>'10Q币','v'=>22), 
        '5' => array('id'=>6,'prize'=>'下次没准就能中哦','v'=>50), 
    );   
    

中是一个二维数组，记录了所有本次抽奖的奖项信息，其中id表示中奖等级，prize表示奖品，v表示中奖概率。注意其中的v必须为整数，你可以将对应的奖项的v设置成0，即意味着该奖项抽中的几率是0，数组中v的总和（基数），基数越大越能体现概率的准确性。本例中v的总和为100，那么平板电脑对应的中奖概率就是1%，如果v的总和是10000，那中奖概率就是万分之一了。

每次前端页面的请求，PHP循环奖项设置数组，通过概率计算函数get_rand获取抽中的奖项id。将中奖奖品保存在数组$res['yes']中，而剩下的未中奖的信息保存在$res['no']中，最后输出json个数数据给前端页面。
    
    
    //如果中奖数据是放在数据库里，这里就需要进行判断中奖数量
    //在中1、2、3等奖的，如果达到最大数量的则unset相应的奖项，避免重复中大奖
    //code here eg:unset($prize_arr['0'])
    foreach ($prize_arr as $key => $val) { 
        $arr[$val['id']] = $val['v']; 
    } 
    
    $rid = get_rand($arr); //根据概率获取奖项id
    
    $res['yes'] = $prize_arr[$rid-1]['prize']; //中奖项
    //将中奖项从数组中剔除，剩下未中奖项，如果是数据库验证，这里可以省掉
    unset($prize_arr[$rid-1]); 
    shuffle($prize_arr); //打乱数组顺序
    for($i=0;$i<count($prize_arr);$i++){ 
        $pr[] = $prize_arr[$i]['prize']; 
    } 
    $res['no'] = $pr; 
    echo json_encode($res);   
    

## 为什么我抽不到大奖？

在很多类似的抽奖活动中，参与者往往抽不到大奖，笔者从程序的角度举个例给你看，假如我是抽奖活动的主办方，我设置了6个奖项，每个奖项不同的中奖概率，假如一等奖是一台高级轿车，可是我设置了其中奖概率为0，这意味着什么？这意味着参与抽奖者无论怎么抽，永远也得不到这台高级轿车。而当主办方每次翻动剩下的方块时，参与者会发现一等奖也许就在刚刚抽奖的方块旁边的一个数字下，都怪自己运气差。真的是运气差吗？其实在参与者翻动那个方块时程序已经决定了中奖项，而翻动查看其他方块看到的奖项只是一个烟雾弹，迷惑了观众和参与者。我想看完这篇文章后，您或许会知道电视节目中的翻板抽奖猫腻了，您也许大概再不会去机选双色球了。

参考链接：<http://blog.csdn.net/leeyisoft/article/details/8226036>
