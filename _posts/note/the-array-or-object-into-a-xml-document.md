Title: 将数组或对象转换为XML文档
Date: 2012-03-27 22:43:10
Tags: PHP, XML


将数组或对象转换为XML文档也是我们作为开发经常要用到的，一般可能做接口提取数据时用的较多。 下面两个函数组合可轻松实现数组或对象转XML： 
    
    
    // xml编码
    function xml_encode($data, $encoding='utf-8', $root="root") {
        $xml = '<?xml version="1.0" encoding="' . $encoding . '"?>';
        $xml.= '<' . $root . '>';
        $xml.= data_to_xml($data);
        $xml.= '</' . $root . '>';
        return $xml;
    }
    
    function data_to_xml($data) {
        if (is_object($data)) {
            $data = get_object_vars($data);
        }
        $xml = '';
        foreach ($data as $key => $val) {
            is_numeric($key) && $key = "item id=\"$key\"";
            $xml.="<$key>";
            $xml.= ( is_array($val) || is_object($val)) ? data_to_xml($val) : $val;
            list($key, ) = explode(' ', $key);
            $xml.="</$key>";
        }
        return $xml;
    }

  使用方法： return xml_encode($result);
