Title: PHP下solr的分词和搜索函数
Date: 2011-12-31 15:02:53
Tags: Solr, PHP, 分词


在PHP应用下，为了更高效的对输入的关键词进行分词和搜索处理，特整理了专门的两个函数。   

分词函数：function solr_analysis();   
搜索函数：function solr_search();    

在使用之前需要定义两个常量： 

> define('SEARCH_HOSTNAME', 'http://10.10.10.10:8983'); define('SEARCH_QUERY', SEARCH_HOSTNAME .'/solr/browse'); define('SEARCH_ANALYSIS', SEARCH_HOSTNAME. '/solr/analysis/field');

以下提供的是基于CI框架下的function，用到了CI的curl。 源码： 
    
    
    <?php
    /**
     * 搜索相关的应用
     * $Id: search_helper.php 6812 2011-12-16 08:55:03Z wangquanlong $
     * $LastChangedDate: 2011-12-16 16:55:03 +0800 (星期五, 16 十二月 2011) $
     */
    
    /**
     * 通用搜索方法
     * @param $keyword
     * @param $start
     * @param $pagesize
     */
    function solr_search($keyword, $type, $start=0, $pagesize=10, $sort=null){
    	$keyword = trim($keyword);
    
    	if( $keyword=='' ){
    		return array();
    	}
    
    	$CI = & get_instance ();
    	$CI->load->library ( 'curl' );
    
    	$CI->curl->open();
    	$CI->curl->_set_opt(CURLOPT_USERPWD, 'username:password');
    
    	$url = SEARCH_QUERY."?q=".$keyword."+AND+sourcetype:{$type}&version=2.2&start={$start}&rows={$pagesize}&hl.fl=name&indent=off&wt=php".( trim($sort)?'&sort='.trim($sort):'' );
    	$curl_result = $CI->curl->http_get($url);
    
    	$result = array();
    	if ($curl_result) {
    		@eval ( "\$curl_result=$curl_result;" );
    		if (isset ( $curl_result) ) {
    
    			$result['url'] = $url;
    			$result['sum'] = $curl_result['response']['numFound'];
    			$result['docs'] = $curl_result['response']['docs'];
    		}
    	}
    
    	return $result;
    }
    
    /**
     * 通用搜索分词方法，不能指定搜索字段，传入一个字符串，返回数据，分好词的数组
     * @param string $keyword
     * @return array $ana_result_arr
     */
    function solr_analysis($keyword) {
    	$keyword = trim($keyword);
    
    	$CI = & get_instance ();
    	$CI->load->library ( 'curl' );
    	$CI->curl->open();
    	$CI->curl->_set_opt(CURLOPT_USERPWD, 'username:password');
    
    	$url = SEARCH_ANALYSIS."?q=".$keyword."&indent&wt=php";
    	$curl_result = $CI->curl->http_get($url);
    
    	//分词
    	$ana_result_arr = array();
    	if ($curl_result) {
    		@eval ( "\$curl_result=$curl_result;" );
    		if (isset ( $curl_result ['analysis'] ['field_names'] ['text'] ['query'] ['org.wltea.analyzer.lucene.IKTokenizer'] )) {
    
    			$ana_result = $curl_result ['analysis'] ['field_names'] ['text'] ['query'] ['org.wltea.analyzer.lucene.IKTokenizer'];
    			$ana_result_arr = array ();
    			if (is_array ( $ana_result ) ) {
    				foreach ($ana_result as $v){
    					$ana_result_arr [] = $v ['text'];
    				}
    			}
    		}
    	}
    	return $ana_result_arr;
    }
    ?>