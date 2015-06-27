Title: PHP设计模式之观察者模式
Date: 2013-12-29 12:10:25
Tags: PHP, 设计模式,观察者模式

## PHP设计模式之观察者模式

### 【意图】

定义对象间的一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并被自动更新【GOF95】 又称为发布-订阅（Publish-Subscribe）模式、模型-视图（Model-View）模式、源-监听（Source-Listener）模式、或从属者(Dependents)模式

### 【观察者模式结构图】

![观察者模式](http://lnmp100.b0.upaiyun.com/2013/12/Observer.jpg)  
观察者模式

### 【观察者模式中主要角色】

  * 抽象主题（Subject）角色：主题角色将所有对观察者对象的引用保存在一个集合中，每个主题可以有任意多个观察者。 抽象主题提供了增加和删除观察者对象的接口。 
  * 抽象观察者（Observer）角色：为所有的具体观察者定义一个接口，在观察的主题发生改变时更新自己。 
  * 具体主题（ConcreteSubject）角色：存储相关状态到具体观察者对象，当具体主题的内部状态改变时，给所有登记过的观察者发出通知。具体主题角色通常用一个具体子类实现。 
  * 具体观察者（ConcretedObserver）角色：存储一个具体主题对象，存储相关状态，实现抽象观察者角色所要求的更新接口，以使得其自身状态和主题的状态保持一致。

### 【观察者模式的优点和缺点】

#### 观察者模式的优点：

  1. 观察者和主题之间的耦合度较小； 
  2. 支持广播通信；

#### 观察者模式的缺点：

  1. 由于观察者并不知道其它观察者的存在，它可能对改变目标的最终代价一无所知。这可能会引起意外的更新。

### 【观察者模式适用场景】

  1. 当一个抽象模型有两个方面，其中一个方面依赖于另一个方面。 
  2. 当对一个对象的改变需要同时改变其它对象，而不知道具体有多少个对象待改变。 
  3. 当一个对象必须通知其它对象，而它又不能假定其它对象是谁。换句话说，你不希望这些对象是紧密耦合的。

### 【观察者模式与其它模式】

  * 中介者模式（Mediator）:通过封装复杂的更新语义，ChangeManager充当目标和观察者之间的中介者。 
  * 单例模式(singleton模式):ChangeManager可使用Singleton模式来保证它是唯一的并且是可全局访问的。

### 【观察者模式PHP示例】
    
    
    <?php
    
    /**
    * 观察者模式
    * @package design pattern
    */
    
    /**
    * 抽象主题角色
    */
    interface Subject {
    
        /**
         * 增加一个新的观察者对象
         * @param Observer $observer
         */
        public function attach(Observer $observer);
    
        /**
         * 删除一个已注册过的观察者对象
         * @param Observer $observer
         */
        public function detach(Observer $observer);
    
        /**
         * 通知所有注册过的观察者对象
         */
        public function notifyObservers();
    }
    
    /**
    * 具体主题角色
    */
    class ConcreteSubject implements Subject {
    
        private $_observers;
    
        public function __construct() {
            $this->_observers = array();
        }
    
        /**
         * 增加一个新的观察者对象
         * @param Observer $observer
         */
        public function attach(Observer $observer) {
            return array_push($this->_observers, $observer);
        }
    
        /**
         * 删除一个已注册过的观察者对象
         * @param Observer $observer
         */
        public function detach(Observer $observer) {
            $index = array_search($observer, $this->_observers);
            if ($index === FALSE || ! array_key_exists($index, $this->_observers)) {
                return FALSE;
            }
    
            unset($this->_observers[$index]);
            return TRUE;
        }
    
        /**
         * 通知所有注册过的观察者对象
         */
        public function notifyObservers() {
            if (!is_array($this->_observers)) {
                return FALSE;
            }
    
            foreach ($this->_observers as $observer) {
                $observer->update();
            }
    
            return TRUE;
        }
    
    }
    
    /**
    * 抽象观察者角色
    */
    interface Observer {
    
        /**
         * 更新方法
         */
        public function update();
    }
    
    class ConcreteObserver implements Observer {
    
        /**
         * 观察者的名称
         * @var <type>
         */
        private $_name;
    
        public function __construct($name) {
            $this->_name = $name;
        }
    
        /**
         * 更新方法
         */
        public function update() {
            echo 'Observer', $this->_name, ' has notified.<br />';
        }
    
    }
    

#### 实例化类：
    
    
    $subject = new ConcreteSubject();
    
    /* 添加第一个观察者 */
    $observer1 = new ConcreteObserver('Martin');
    $subject->attach($observer1);
    
    echo '<br /> The First notify:<br />';
    $subject->notifyObservers();
    
    /* 添加第二个观察者 */
    $observer2 = new ConcreteObserver('phppan');
    $subject->attach($observer2);
    
    echo '<br /> The Second notify:<br />';
    $subject->notifyObservers();
    
    /* 删除第一个观察者 */
    $subject->detach($observer1);
    
    echo '<br /> The Third notify:<br />';
    $subject->notifyObservers();
    

#### 具体案例：
    
    
    <?php
     /**  
      * 3.1php设计模式-观测者模式  
      * 3.1.1概念:其实观察者模式这是一种较为容易去理解的一种模式吧，它是一种事件系统，意味  
      *          着这一模式允许某个类观察另一个类的状态，当被观察的类状态发生改变的时候，  
      *          观察类可以收到通知并且做出相应的动作;观察者模式为您提供了避免组件之间
      *          紧密耦合的另一种方法
      * 3.1.2关键点:
      *        1.被观察者->追加观察者;->一处观察者;->满足条件时通知观察者;->观察条件
      *        2.观察者 ->接受观察方法
      * 3.1.3缺点:
      * 3.1.4观察者模式在PHP中的应用场合:在web开发中观察者应用的方面很多
      *        典型的:用户注册(验证邮件，用户信息激活)，购物网站下单时邮件/短信通知等
      * 3.1.5php内部的支持
      *        SplSubject 接口，它代表着被观察的对象，
      *        其结构：
      *        interface SplSubject
      *        {
      *            public function attach(SplObserver $observer);
      *            public function detach(SplObserver $observer);
      *            public function notify();
      *        }
      *        SplObserver 接口，它代表着充当观察者的对象，
      *        其结构：
      *        interface SplObserver
      *        {   
      *            public function update(SplSubject $subject);
      *        }
      */
    
     /**
      * 用户登陆-诠释观察者模式
      */
    class User implements SplSubject {
        //注册观察者
        public $observers = array();
    
        //动作类型
        CONST OBSERVER_TYPE_REGISTER = 1;//注册
        CONST OBSERVER_TYPE_EDIT = 2;//编辑
    
        /**
         * 追加观察者
         * @param SplObserver $observer 观察者
         * @param int $type 观察类型
         */
        public function attach(SplObserver $observer, $type)
        {
            $this->observers[$type][] = $observer;
        }
    
        /**
         * 去除观察者
         * @param SplObserver $observer 观察者
         * @param int $type 观察类型
         */
        public function detach(SplObserver $observer, $type)
        {
            if($idx = array_search($observer, $this->observers[$type], true))
            {
                unset($this->observers[$type][$idx]);
            }
        }
    
        /**
         * 满足条件时通知观察者
         * @param int $type 观察类型
         */
        public function notify($type)
        {
            if(!empty($this->observers[$type]))
            {
                foreach($this->observers[$type] as $observer)
                {
                    $observer->update($this);
                }
            }
        }
    
        /**
         * 添加用户
         * @param str $username 用户名
         * @param str $password 密码
         * @param str $email 邮箱
         * @return bool
         */
