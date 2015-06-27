Title: PHP正则表达式之邮件地址验证(E-mail)
Date: 2012-03-28 23:04:11
Tags: PHP, 正则表达式


![php_regex](/static/uploads/2012/03/php_regex.png)

## 正则

这里有一个基本的邮件地址验证，但是，它并不是一个有效且完美的email验证解决方案，并不推荐这样使用：

	$email = "test@ansoncheung.tk";
	if (preg_match('/^[^0-9][a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*[@][a-zA-Z0-9_]+([.][a-zA-Z0-9_]+)*[.][a-zA-Z]{2,4}$/',$email)) {
		echo "Your email is ok.";
	} else {
		echo "Wrong email address format";
	}

为了更高效的验证email地址的合理性，推荐使用 `filer_var`

	if (filter_var('test+email@lamp100.com', FILTER_VALIDATE_EMAIL)) {
		echo 'Your email is ok.';
	} else {
		echo 'Wrong email address format.';
	}

## filter_var()
### 定义和用法
`filter_var()` 函数通过指定的过滤器过滤变量。
如果成功，则返回已过滤的数据，如果失败，则返回false。

## 语法：

	filter_var(variable, filter, options)

![filter_var](/staitc/uploads/2012/03/filter_var_thumb1.png)

更多filter说明：![filter_validate](/static/uploads/2012/03/filter_validate_thumb1.png)


## 参考阅读
  * <http://cn.php.net/filter_var>
  * <http://www.w3school.com.cn/php/func_filter_var.asp>
  * [关于更多的PHP内置函数过滤](http://www.w3school.com.cn/php/php_ref_filter.asp)
