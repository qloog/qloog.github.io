Title: PHP生成静态化的简单实例
Date: 2012-02-24 23:48:29
Tags: PHP, 静态化



直接上代码


	<?php
    	ob_start();
    ?>
    <html>
    <head>
    </head>
    <body>
    <?php 
    	echo 'hello world'; 
    ?>
    </body>
    </html>
    <?php
    	$content = ob_get_contents(); //获取内容
    	ob_end_clean(); //释放
    
    	$handle = fopen('1.html', 'w'); //创建静态文件
    	fwrite($handle, $content); //写入
    	fclose($handle);
    ?>