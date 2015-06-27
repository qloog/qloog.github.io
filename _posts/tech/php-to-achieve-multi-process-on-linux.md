Title: Linux下实现PHP多进程
Date: 2012-07-08 00:37:43
Tags: PHP, 多进程


多进程：使用PHP的Process Control Functions(PCNTL/线程控制函数) 函数参考可见：http://www.php.net/manual/zh/ref.pcntl.php 只能用在Unix Like OS，Windows不可用。 编译php的时候，需要加上--enable-pcntl，且推荐仅仅在CLI模式运行，不要在WEB服务器环境运行。  以下为简短的测试代码： 
    
    
    <?php
    declare(ticks=1);
    $bWaitFlag = FALSE; /// 是否等待进程结束
    $intNum = 10;           /// 进程总数
    $pids = array();        ///  进程PID数组
    
    echo ("Start\n");
    
    for($i = 0; $i < $intNum; $i++) {
    
      $pids[$i] = pcntl_fork();/// 产生子进程，而且从当前行之下开试运行代码，而且不继承父进程的数据信息
    
      if(!$pids[$i]) {
        // 子进程进程代码段_Start
        $str="";
        sleep(5+$i);
        for ($j=0;$j<$i;$j++) {$str.="*";}
        echo "$i -> " . time() . " $str \n";
        exit();
        // 子进程进程代码段_End
      }
    
    }
    if ($bWaitFlag)
    {
      for($i = 0; $i < $intNum; $i++) {
        pcntl_waitpid($pids[$i], $status, WUNTRACED);
        echo "wait $i -> " . time() . "\n";
      }
    }
    echo ("End\n");
    ?>
