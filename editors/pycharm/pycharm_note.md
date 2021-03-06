Pycharm学习笔记
===========

Install
-------

    snap install [pycharm-community|pycharm-professional] --classic

Note
----

### 区域 排除 代码格式化(Live Templates版)

``` python
# @formatter:off
$SELECTION$
# @formatter:on
```

### Filter

查询框类似SQL的`where` 关键字

    # % 通配 0或更多
    # _ 匹配 1个
    name LIKE 'a%' AND note LIKE 'b_'

Setting Help
------------

- **关闭**enter智能缩进, 否则导致不产生多行div的中间缩进(但开启python中冒号后才能缩进)

> Editor | General | Smart Keys | Enter | Smart indent

- Project忽略文件类型

> Editor | File Types | Ignore files and folders

- 文件代码最后一行可以移动到顶部

> Editor | GeneralGeneral | Virtual Space | Show virtual space at file bottom

- 设置环境变量

> Build, Execution, Deployment | Console | Python Console | Environment variable

### 中文输入

<https://segmentfault.com/q/1010000002641274/a-1020000006061111>

在pycharm.sh中加入下面3个选项：

    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx

### 导入Python live template

<http://peter-hoffmann.com/2010/python-live-templates-for-pycharm.html>

### 配置启动参数

    右上角项目图标 / "Edit Configurations" / Python

- "Script"  文件位置
- "Script Parameters"   参数设置
- "Python interpreter"  Python解释器

### 创建图标和快捷方式

> Tools | Creat Desktop Entry

快捷键
---

Ctrl+鼠标 查看内置函数

`Alt+Enter` 万能键 各种提示和自动功能

`Ctrl+w` 扩展选取

`Ctrl+Shift+F10` 运行当前文件

`Ctrl+q` 差帮助

`Shift+Enter` 向下插行, 等于sublime的ctrl+enter

双击`Shift` 搜索一切
