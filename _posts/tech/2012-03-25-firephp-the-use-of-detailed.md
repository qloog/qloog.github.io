---
layout: post
title: FirePHP使用详解
date: 2012-03-25 12:11:54
category: 技术
tags: PHP FirePHP
---

##  面向对象API(Object Oriented API) 
    
    
    require_once('FirePHPCore/FirePHP.class.php');
    $firephp = FirePHP::getInstance(true);
    $firephp-> *
    
    require_once('FirePHPCore/fb.php');
    FB:: *
    
    $firephp->setEnabled(false);  // or FB::
    
    FB::send(/* See fb() */);

## 面向过程API 
    
    
    require_once('FirePHPCore/fb.php');
    
    fb($var);
    fb($var, 'Label');
    fb($var, FirePHP::*);
    fb($var, 'Label', FirePHP::*);

## 参数说明 
    
    
    // Defaults:
    $options = array('maxObjectDepth' => 5,
                     'maxArrayDepth' => 5,
                     'maxDepth' => 10,
                     'useNativeJsonEncode' => true,
                     'includeLineNumbers' => true);
    
    $firephp->getOptions();
    $firephp->setOptions($options);
    FB::setOptions($options);
    
    $firephp->setObjectFilter('ClassName',
                               array('MemberName'));

## 错误、异常及断点处理 
    
    
    $firephp->registerErrorHandler(
                $throwErrorExceptions=false);
    $firephp->registerExceptionHandler();
    $firephp->registerAssertionHandler(
                $convertAssertionErrorsToExceptions=true,
                $throwAssertionExceptions=false);
    
    try {
      throw new Exception('Test Exception');
    } catch(Exception $e) {
      $firephp->error($e);  // or FB::
    }

## 分组 
    
    
    $firephp->group('Test Group');
    $firephp->log('Hello World');
    $firephp->groupEnd();
    
    $firephp->group('Collapsed and Colored Group',
                    array('Collapsed' => true,
                          'Color' => '#FF00FF'));

## 记录信息 
    
    
    $firephp->log('Plain Message');     // or FB::
    $firephp->info('Info Message');     // or FB::
    $firephp->warn('Warn Message');     // or FB::
    $firephp->error('Error Message');   // or FB::
    
    $firephp->log('Message','Optional Label');
    
    $firephp->fb('Message', FirePHP::*);

## 分表 
    
    
    $table   = array();
    $table[] = array('Col 1 Heading','Col 2 Heading');
    $table[] = array('Row 1 Col 1','Row 1 Col 2');
    $table[] = array('Row 2 Col 1','Row 2 Col 2');
    $table[] = array('Row 3 Col 1','Row 3 Col 2');
    
    $firephp->table('Table Label', $table);  // or FB::
    
    fb($table, 'Table Label', FirePHP::TABLE);

## 跟踪 
    
    
    $firephp->trace('Trace Label');  // or FB::
    
    fb('Trace Label', FirePHP::TRACE);

  官方文档： <http://www.firephp.org/HQ/Use.htm>
