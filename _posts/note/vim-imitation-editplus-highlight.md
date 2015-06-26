Title: VIM终极模仿editplus高亮
Date: 2011-12-14 14:07:24
Tags: vim, editplus



把下面的高亮方案添加到vimfile/color/下：
[editplus_html](/static/uploads/2011/12/editplus_html.zip)
[editplus_php](/static/uploads/2011/12/editplus_php.zip)

把php语法解析文件添加到vim72/syntax/覆盖原来的文件：
[php](/static/uploads/2011/12/php.zip)

_vimrc里设置高亮方案选择：


    " set gui options
    if has("gui_running")
      set guifont=Consolas:h13
      colorscheme editplus_php
      au FileType html,javascript colorscheme editplus_html
    endif

  效果： editplus: ![高亮-editplus2-300x239](/static/uploads/2011/12/高亮\-editplus2-300x239.jpg)
  vim: ![高亮-300x227](/static/uploads/2011/12/高亮\-300x227.jpg)
