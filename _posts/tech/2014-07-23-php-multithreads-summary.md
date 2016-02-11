---
layout: post
title: PHP实现类多线程的方法总结
date: 2014-07-23 21:43
category: 技术
tags: PHP 多线程 多进程
---


大家都很清楚，php是不支持多线程的。但对于需要类似多线程功能的人来说确实是个头疼的问题。好在有几种方案可以进行解决，类似多线程功能。下面是本人总结的三种实现多线程类似的方法的方案，下面是三种方案与代码实例。

## curl_multi方法

当需要多线程的时候，可以用curl_multi一次性请求多个操作来完成，但curl走的是网络通信，效率与可靠性就比较差了的。

	function main(){

     $sql = "select waybill_id,order_id from waybill where status>40 order by update_time desc limit 10 ";

       $data = Yii::app()->db->createCommand($sql)->queryAll(); //yii 框架格式

       foreach ($data as $k => $v) { 
           if ($k % 2 == 0) { //偶数发一个网址
               $send_data[$k]['url'] = '';
               $send_data[$k]['body'] = $v['waybill_id'];
           } else { //奇数发送另外一个网址
               $send_data[$k]['url'] = 'http://www.abc.com';
               $send_data[$k]['body']=array($v['order_id'] => array('extra' => 16));
           }
       }
 
       $back_data =sendMulitRequest($send_data);
       var_dump($back_data);
    }

    function sendMulitRequest($send_data){
       $params = array();
       $curl = $text = array();

       $handle = curl_multi_init();

       foreach ($data as $k => $v) {
           if (empty($v['url'])) {
               $v['url'] = "http://www.xxx.com"; //if url is empty,set defalut url
           }
           $reqBody = json_encode($v['body']);
           $reqStream = array(
               'body' => $reqBody,
           );

           $encRequest = base64_encode(json_encode($reqStream));
           $params['data'] = $encRequest;
           $curl[$k] = curl_init();
           curl_setopt($curl[$k], CURLOPT_URL, $v['url']);
           curl_setopt($curl[$k], CURLOPT_POST, TRUE);
           curl_setopt($curl[$k], CURLOPT_HEADER, 0);
           curl_setopt($curl[$k], CURLOPT_POSTFIELDS, http_build_query($params));
           curl_setopt($curl[$k], CURLOPT_RETURNTRANSFER, 1);
           curl_multi_add_handle($handle, $curl[$k]);

       }

       $active = null;
       do {
           $mrc = curl_multi_exec($handle, $active);
       } while ($mrc == CURLM_CALL_MULTI_PERFORM);

       while ($active && $mrc == CURLM_OK) {
           if (curl_multi_select($handle) != -1) {
               do {
                   $mrc = curl_multi_exec($handle, $active);
               } while ($mrc == CURLM_CALL_MULTI_PERFORM);
           }
       }

       foreach ($curl as $k => $v) {
           if (curl_error($curl[$k]) == "") {
               $text[$k] = (string) curl_multi_getcontent($curl[$k]);
           }
           curl_multi_remove_handle($handle, $curl[$k]);
           curl_close($curl[$k]);
       }

       curl_multi_close($handle);
       return $text;
    }

## 通过stream_socket_client 方式

	function sendStream() {
        $english_format_number = number_format($number, 4, '.', '');
        echo $english_format_number;
        exit();
        $timeout = 10;
        $result = array();
        $sockets = array();
        $convenient_read_block = 8192;

        $host = "test.local.com";

        $sql = "select waybill_id,order_id from xm_waybill where status>40 order by update_time desc limit 1 ";
        $data = Yii::app()->db->createCommand($sql)->queryAll();
        $id = 0;
        foreach ($data as $k => $v) {
            if ($k % 2 == 0) {
                $send_data[$k]['body'] = NoticeOrder::getSendData($v['waybill_id']);
            } else {
                $send_data[$k]['body'] = array($v['order_id'] => array('extra' => 16));
            }
            $data = json_encode($send_data[$k]['body']);
            $s = stream_socket_client($host . ":80", $errno, $errstr, $timeout, STREAM_CLIENT_ASYNC_CONNECT | STREAM_CLIENT_CONNECT);
            if ($s) {
                $sockets[$id++] = $s;
                $http_message = "GET /php/test.php?data=" . $data . " HTTP/1.0\r\nHost:" . $host . "\r\n\r\n";
                fwrite($s, $http_message);
            } else {
                echo "Stream " . $id . " failed to open correctly.";
            }
        }

        while (count($sockets)) {
            $read = $sockets;
            stream_select($read, $w = null, $e = null, $timeout);
            if (count($read)) {
                /* stream_select generally shuffles $read, so we need to
                  compute from which socket(s) we're reading. */
                foreach ($read as $r) {
                    $id = array_search($r, $sockets);
                    $data = fread($r, $convenient_read_block);
                    if (strlen($data) == 0) {
                        echo "Stream " . $id . " closes at " . date('h:i:s') . ".<br>   ";
                        fclose($r);
                        unset($sockets[$id]);
                    } else {
                        $result[$id] = $data;
                    }
                }
            } else {
                /* A time-out means that *all* streams have failed
                  to receive a response. */
                echo "Time-out!\n";
                break;
            }
        }
        print_r($result);
    }

## 通过多进程代替多线程

	function daemon($func_name,$args,$number){
		while(true){
			$pid=pcntl_fork();
			if($pid==-1){
				echo "fork process fail";
				exit();
			}elseif($pid){//创建的子进程
	
				static $num=0;
				$num++;
				if($num>=$number){
					//当进程数量达到一定数量时候，就对子进程进行回收。
					pcntl_wait($status);
	
					$num--;
				}
	
			}else{ //为0 则代表是子进程创建的，则直接进入工作状态
	
				if(function_exists($func_name)){
					while (true) {
						$ppid=posix_getpid();
						var_dump($ppid);
						call_user_func_array($func_name,$args);
						sleep(2);
					}
				}else{
					echo "function is not exists";
				}
				exit();
	
	
			}
		}
	}

	function worker($args){

		//do something

	}

	daemon('worker',array(1),2);
	
