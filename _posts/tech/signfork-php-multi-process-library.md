Title: Signfork-PHP多进程类库
Date: 2012-07-08 00:35:43


php多进程库：使用PHP真正的多进程模式，适用于数据采集、邮件群发、数据源更新、tcp服务器等环节。 运行条件：编译时需要 --enable-pcntl 以及 posix扩展。 
    
    
    <?php
    include('Signfork.class.php');
    
    class test
    {
      function __fork($arg)
      {
        return file_get_contents($arg);
      }
    }
    
    $limit    =microtime(true);
    $test    =new test();
    $Signfork  =new Signfork();
    
    
    
    $arg=array(
    'http://yahoo.com',
    'http://baidu.com',
    'http://google.com',
    'http://qq.com',
    'http://163.com',
    'http://sina.com'
    );
    
    
    $Signfork->run($test,$arg);
    echo 'Run time:'.(microtime(true)-$limit); //Run time:1.7930409908295
    ?>

Signfork.class.php源代码： 
    
    
    <?php
    /**
    * Project: Signfork: php多线程库
    * File:    Signfork.class.php
    *
    * @link  http://code.google.com/p/signfork/
    * @author  lajabs <hittyo at gmail dot com> QQ:124321697
    * @version 1.0.0 2009/8/4
    */
    
    
    
    class Signfork
    {
      /**
         * 设置子进程通信文件所在目录
         * @var string
         */
      private $tmp_path='/tmp/';
    
      /**
         * Signfork引擎主启动方法
       * 1、判断$arg类型,类型为数组时将值传递给每个子进程;类型为数值型时,代表要创建的进程数.
       * @param object $obj 执行对象
       * @param string|array $arg 用于对象中的__fork方法所执行的参数
       * 如:$arg,自动分解为:$obj->__fork($arg[0])、$obj->__fork($arg[1])...
       * @return array  返回   array(子进程序列=>子进程执行结果);
         */
      public function run($obj,$arg=1)
      {
        if(!method_exists($obj,'__fork'))
        {
          exit("Method '__fork' not found!");
        }
    
        if(is_array($arg))
        {
          $i=0;
          foreach($arg as $key=>$val)
          {
            $spawns[$i]=$key;
            $i++;
            $this->spawn($obj,$key,$val);
          }
          $spawns['total']=$i;
        }
        elseif($spawns=intval($arg))
        {
          for($i = 0; $i < $spawns; $i++) 
          {
            $this->spawn($obj,$i);
          }
        }
        else
        {
          exit('Bad argument!');
        }
        if($i>1000) exit('Too many spawns!');
    
        return $this->request($spawns);
      }
    
    
      /**
         * Signfork主进程控制方法
       * 1、$tmpfile 判断子进程文件是否存在，存在则子进程执行完毕，并读取内容
       * 2、$data收集子进程运行结果及数据，并用于最终返回
       * 3、删除子进程文件
       * 4、轮询一次0.03秒，直到所有子进程执行完毕，清理子进程资源
       * @param  string|array $arg 用于对应每个子进程的ID
       * @return array  返回   array([子进程序列]=>[子进程执行结果]);
         */
      private function request($spawns)
      {
        $data=array();
        $i=is_array($spawns)?$spawns['total']:$spawns;
        for($ids = 0; $ids<$i; $ids++)
        {
          while(!($cid=pcntl_waitpid(-1, $status, WNOHANG)))usleep(30000);
          $tmpfile=$this->tmp_path.'sfpid_'.$cid;
          $data[$spawns['total']?$spawns[$ids]:$ids]=file_get_contents($tmpfile);
          unlink($tmpfile);
        }
        return $data;
      }
    
      /**
         * Signfork子进程执行方法
       * 1、pcntl_fork 生成子进程
       * 2、file_put_contents 将'$obj->__fork($val)'的执行结果存入特定序列命名的文本
       * 3、posix_kill杀死当前进程
       * @param object $obj  待执行的对象
       * @param object $i    子进程的序列ID，以便于返回对应每个子进程数据
       * @param object $param 用于输入对象$obj方法'__fork'执行参数
         */
      private function spawn($obj,$i,$param=null)
      {
        if(pcntl_fork()===0)
        {
          $cid=getmypid();
          file_put_contents($this->tmp_path.'sfpid_'.$cid,$obj->__fork($param));
          posix_kill($cid, SIGTERM);
          exit;
        }
      }
    }
    
    ?>

下载地址 <http://code.google.com/p/signfork/>
