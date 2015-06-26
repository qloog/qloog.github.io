Title: PHPExcel读取Excel文件实例
Date: 2011-12-30 11:45:24
Tags: PHPExcel


利用PHP读取Excel文件内容是常有之事，可以大量减轻编辑们的工作，以此提高工作效率，现附上一个处理实例，也希望对路过的人们有所帮助。

PHP代码： 
    
    
    <?php
    /*
     * 从Excel上传分类数据到MongoDB中
     * @author lamp100
     * @create 2011-12-30
     */
    ini_set('display_errors',1);
    error_reporting(E_ALL);
    ini_set('memory_limit', '-1');
    
    //设置PHPExcel类库的include path
    set_include_path(dirname(__FILE__).'/libraries/PHPExcel/'.get_include_path());
    /**
     * 以下是使用示例，对于以 //// 开头的行是不同的可选方式，请根据实际需要
     * 打开对应行的注释。
     */
    require_once 'PHPExcel.php'; 
    
    if (isset ( $argv [1] ) && $argv [1]) {
    } else {
    	exit ( 'not args' );
    }
    $fileName = 'Book1.xls';
    $path = '/home/excelfile/';
    $filePath = $path.$fileName;
    $PHPExcel = new PHPExcel();
    $PHPReader = new PHPExcel_Reader_Excel2007();	//用于2007版本
    //$PHPReader = new PHPExcel_Writer_Excel5($objExcel);    // 用于其他版本格式  
    
    //开始时间
    $start_time = microtime_float ();
    
    /*
     * 导入数据到...
     */
    if ($argv [1] == 'user_data') { 
    
    	if(!$PHPReader->canRead($filePath)){
    		$PHPReader = new PHPExcel_Reader_Excel5();
    		if(!$PHPReader->canRead($filePath)){
    			echo 'no Excel';
    			return ;
    		}
    	}
    	$PHPExcel = $PHPReader->load($filePath);
    	$currentSheet = $PHPExcel->getSheet(0);
    	/**取得一共有多少列*/
    	$allColumn = $currentSheet->getHighestColumn();
    	/**取得一共有多少行*/
    	$allRow = $currentSheet->getHighestRow();  
    
    	for($currentRow = 1;$currentRow<=$allRow;$currentRow++){
    		for($currentColumn='A';$currentColumn<=$allColumn;$currentColumn++){
    			$address = $currentColumn.$currentRow;
    
    			echo $currentSheet->getCell($address)->getValue()."\t";
    			//或者是入库前的一些处理
    			//code...
    		}
    		echo "\n";
    	}
    
    }
    
    $end_time = microtime_float();
    $times = $end_time - $start_time;
    
    echo $times ."\n";
    
    //时间函数
    function microtime_float() {
    	list ( $usec, $sec ) = explode ( " ", microtime () );
    	return (( float ) $usec + ( float ) $sec);
    }
    ?>

我一般导入数据是通过在命令行下来操作的,以下为导入数据的执行方法： 

> php /data0/htdocs/import_data.php user_data