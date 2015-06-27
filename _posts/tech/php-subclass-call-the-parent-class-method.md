Title: PHP父类调用子类方法
Date: 2013-07-10 18:47:03
Tags: PHP, 类调用

## PHP父类调用子类方法

今天突然发现需要在父类中调用子类的方法，之前一直都没这么用过，通过实践发现也可以。例子如下：
    
    
    <?php
    /**
     * 父类调用子类方法 基类
     * @author LNMP100
     *
     */
    class BaseApp
    {
        /**
         * 调用子类方法
         * @version  创建时间：2013-07-10
         */
        function _run_action()
            {
                $action = "index";
                $this->$action();
            }
    } 
    
    class DefaultApp extends BaseApp
    {
    
        /**
         * 此方法将在父类中调用
         */
        function index()
            {
                echo "DefaultApp->index() invoked";
            }
    
        function  Go(){
            //调用父类
            parent::_run_action();
        }
    }
    
    $default=new DefaultApp();
    $default->Go();
    //将显示DefaultApp->index() invoked
    
    ?>
