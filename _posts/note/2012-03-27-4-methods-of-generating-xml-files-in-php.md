---
layout: post
title: PHP中的生成XML文件的4种方法
date: 2012-03-27 23:06:23
category: 技术
tags: PHP XML
---

生成xml四种方法，总有自己满意的一种。 
    
    <?xml version="1.0" encoding="utf-8"?>
    <article>
        <item>
            <title size="1">title1</title>
            <content>content1</content>
            <pubdate>2009-10-11</pubdate>
        </item>
        <item>
            <title size="1">title2</title>
            <content>content2</content>
            <pubdate>2009-11-11</pubdate>
        </item>
    </article> 
    

## 直接生成字符串
方法1：使用纯粹的PHP代码生成字符串，并把这个字符串写入一个以XML为后缀的文件。这是最原始的生成XML的方法，不过有效！
PHP代码如下：
    
    <?PHP
    $data_array = array(
        array(
        'title' => 'title1',
        'content' => 'content1',
            'pubdate' => '2009-10-11',
        ),
        array(
        'title' => 'title2',
        'content' => 'content2',
        'pubdate' => '2009-11-11',
        )
    );
    $title_size = 1;
    
    $xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
    $xml .= "<article>\n";
    
    foreach ($data_array as $data) {
    $xml .= create_item($data['title'], $title_size, $data['content'], $data['pubdate']);
    }
    
    $xml .= "</article>\n";
    
    echo $xml;
    
    //  创建XML单项
    function create_item($title_data, $title_size, $content_data, $pubdate_data)
    {
        $item = "<item>\n";
        $item .= "<title size=\"" . $title_size . "\">" . $title_data . "</title>\n";
        $item .= "<content>" . $content_data . "</content>\n";
        $item .= " <pubdate>" . $pubdate_data . "</pubdate>\n";
        $item .= "</item>\n";
    
        return $item;
    }
    
    ?> 
    

## DomDocument
    方法2：使用DomDocument生成XML文件
    创建节点使用createElement方法，
    创建文本内容使用createTextNode方法，
    添加子节点使用appendChild方法，
    创建属性使用createAttribute方法
    PHP代码如下：
    
    <?PHP
    $data_array = array(
        array(
        'title' => 'title1',
        'content' => 'content1',
            'pubdate' => '2009-10-11',
        ),
        array(
        'title' => 'title2',
        'content' => 'content2',
        'pubdate' => '2009-11-11',
        )
    );
    
    //  属性数组
    $attribute_array = array(
        'title' => array(
        'size' => 1
        )
    );
    
    //  创建一个XML文档并设置XML版本和编码。。
    $dom=new DomDocument('1.0', 'utf-8');
    
    //  创建根节点
    $article = $dom->createElement('article');
    $dom->appendchild($article);
    
    foreach ($data_array as $data) {
        $item = $dom->createElement('item');
        $article->appendchild($item);
    
        create_item($dom, $item, $data, $attribute_array);
    }
    
    echo $dom->saveXML();
    
    function create_item($dom, $item, $data, $attribute) {
        if (is_array($data)) {
            foreach ($data as $key => $val) {
                //  创建元素
                $$key = $dom->createElement($key);
                $item->appendchild($$key);
    
                //  创建元素值
                $text = $dom->createTextNode($val);
                $$key->appendchild($text);
    
                if (isset($attribute[$key])) {
                //  如果此字段存在相关属性需要设置
                    foreach ($attribute[$key] as $akey => $row) {
                        //  创建属性节点
                        $$akey = $dom->createAttribute($akey);
                        $$key->appendchild($$akey);
    
                        // 创建属性值节点
                        $aval = $dom->createTextNode($row);
                        $$akey->appendChild($aval);
                    }
                }   //  end if
            }
        }   //  end if
    }   //  end function
    ?> 
    

## XMLWriter
    方法3：使用XMLWriter类创建XML文件
    此方法在PHP 5.1.2后有效
    另外，它可以输出多种编码的XML，但是输入只能是utf-8
    PHP代码如下：
    
    <?PHP
    $data_array = array(
        array(
        'title' => 'title1',
        'content' => 'content1',
            'pubdate' => '2009-10-11',
        ),
        array(
        'title' => 'title2',
        'content' => 'content2',
        'pubdate' => '2009-11-11',
        )
    );
    
    //  属性数组
    $attribute_array = array(
        'title' => array(
        'size' => 1
        )
    );
    
    $xml = new XMLWriter();
    $xml->openUri("php://output");
    //  输出方式，也可以设置为某个xml文件地址，直接输出成文件
    $xml->setIndentString('  ');
    $xml->setIndent(true);
    
    $xml->startDocument('1.0', 'utf-8');
    //  开始创建文件
    //  根结点
    $xml->startElement('article');
    
    foreach ($data_array as $data) {
        $xml->startElement('item');
    
        if (is_array($data)) {
            foreach ($data as $key => $row) {
              $xml->startElement($key);
    
              if (isset($attribute_array[$key]) && is_array($attribute_array[$key]))
              {
                  foreach ($attribute_array[$key] as $akey => $aval) {
                  //  设置属性值
                        $xml->writeAttribute($akey, $aval);
                    }
    
                }
    
                $xml->text($row);   //  设置内容
                $xml->endElement(); // $key
            }
    
        }
        $xml->endElement(); //  item
    }
    
    $xml->endElement(); //  article
    $xml->endDocument();
    
    $xml->flush();
    ?> 
    

## SimpleXML
    方法4：使用SimpleXML创建XML文档
    
    <?PHP
    $data_array = array(
        array(
        'title' => 'title1',
        'content' => 'content1',
            'pubdate' => '2009-10-11',
        ),
        array(
        'title' => 'title2',
        'content' => 'content2',
        'pubdate' => '2009-11-11',
        )
    );
    
    //  属性数组
    $attribute_array = array(
        'title' => array(
        'size' => 1
        )
    );
    
    $string = <<<XML
    <?xml version='1.0' encoding='utf-8'?>
    <article>
    </article>
    XML;
    
    $xml = simplexml_load_string($string);
    
    foreach ($data_array as $data) {
        $item = $xml->addChild('item');
        if (is_array($data)) {
            foreach ($data as $key => $row) {
              $node = $item->addChild($key, $row);
    
              if (isset($attribute_array[$key]) && is_array($attribute_array[$key]))
                {
                  foreach ($attribute_array[$key] as $akey => $aval) {
                 //  设置属性值
                      $node->addAttribute($akey, $aval);
                }
              }
            }
        }
    }
    echo $xml->asXML();
    ?>
