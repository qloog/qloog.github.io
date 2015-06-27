Title: Zend Framework教程5-创建表单
Date: 2012-07-16 15:16:45
Tags: PHP, Zend Framework

我们需要一个表单来提交新的留言记录，这对于我们的留言薄来说是有用的。 我们要做的第一件事就是创建一个实际的表单类。要创建这个空的表单类，执行： 
    
    
    % zf create form Guestbook
    Creating a form at application/forms/Guestbook.php
    Updating project profile '.zfproject.xml'

这将会创建一个目录：application/forms/，里面还有文件：Guestbook.php。打开这个文件，并将里面的内容修改如下： 
    
    
    // application/forms/Guestbook.php
    
    class Application_Form_Guestbook extends Zend_Form
    {
        public function init()
        {
            // Set the method for the display form to POST
            $this->setMethod('post');
    
            // Add an email element
            $this->addElement('text', 'email', array(
                'label'      => 'Your email address:',
                'required'   => true,
                'filters'    => array('StringTrim'),
                'validators' => array(
                    'EmailAddress',
                )
            ));
    
            // Add the comment element
            $this->addElement('textarea', 'comment', array(
                'label'      => 'Please Comment:',
                'required'   => true,
                'validators' => array(
                    array('validator' => 'StringLength', 'options' => array(0, 20))
                    )
            ));
    
            // Add a captcha
            $this->addElement('captcha', 'captcha', array(
                'label'      => 'Please enter the 5 letters displayed below:',
                'required'   => true,
                'captcha'    => array(
                    'captcha' => 'Figlet',
                    'wordLen' => 5,
                    'timeout' => 300
                )
            ));
    
            // Add the submit button
            $this->addElement('submit', 'submit', array(
                'ignore'   => true,
                'label'    => 'Sign Guestbook',
            ));
    
            // And finally add some CSRF protection
            $this->addElement('hash', 'csrf', array(
                'ignore' => true,
            ));
        }
    }

上面的表单定义了五个元素：邮件地址字段、评论字段、为防止垃圾邮件提交的一个验证码、一个提交按钮和一个保护令牌。 接下来，我们要添加一个signAction()到我们的GuestbookController()控制器，该控制器可以处理表单提交。要创建这个sign操作和相关的视图文件，执行一下命令： 
    
    
    % zf create action sign Guestbook
    Creating an action named sign inside controller
        at application/controllers/GuestbookController.php
    Updating project profile '.zfproject.xml'
    Creating a view script for the sign action method
        at application/views/scripts/guestbook/sign.phtml
    Updating project profile '.zfproject.xml'

正如你所看到的输出，这已经在我们的控制器里创建了signAction()方法，和适当的视图文件。 让我们添加一些逻辑到我们的留言薄控制器的sign的action。首页，我们需要检测是否得到了一个POST或GET请求。对于后者(GET)我们u会简单的显示表单，而对于POST请求，我们要校验提交过来的数据。如果校验通过，则创建一个新条目并保存。大概的逻辑代码如下： 
    
    
    // application/controllers/GuestbookController.php
    
    class GuestbookController extends Zend_Controller_Action
    {
        // snipping indexAction()...
    
        public function signAction()
        {
            $request = $this->getRequest();
            $form    = new Application_Form_Guestbook();
    
            if ($this->getRequest()->isPost()) {
                if ($form->isValid($request->getPost())) {
                    $comment = new Application_Model_Guestbook($form->getValues());
                    $mapper  = new Application_Model_GuestbookMapper();
                    $mapper->save($comment);
                    return $this->_helper->redirector('index');
                }
            }
    
            $this->view->form = $form;
        }
    }

当然我们也需要编辑视图脚本文件：application/views/scripts/guestbook/sign.phtml ： 
    
    
    <!-- application/views/scripts/guestbook/sign.phtml -->
    
    Please use the form below to sign our guestbook!
    
    <?php
    $this->form->setAction($this->url());
    echo $this->form;

注：让表单看起来更好看 没有人会感觉到这个表单是漂亮的。没关系，表单的外观完全是可以定制的。更多细节可以参看：[装饰器的参考指南](http://framework.zend.com/manual/en/zend.form.decorators.html)。另外，你可能也会对我们的[表单修饰教程](http://framework.zend.com/manual/en/learning.form.decorators.intro.html)兴趣。 浏览：http://localhost/quickstart/public/guestbook/sign,应该可以看到如下的界面： ![](http://lnmp100.b0.upaiyun.com/2012/07/zf-learning.quickstart.create-form.png)
