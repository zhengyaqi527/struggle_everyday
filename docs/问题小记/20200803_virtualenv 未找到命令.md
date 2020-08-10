#### 背景

> 想做一个饿了么账单自动算账的小功能，需要在本地启动python虚拟环境，在安装过程中经历了`virtualenv not found`的问题，经过查询后解决了问题。由此总结一下`pip` `virtualenv` `vurtualenvwrapper`的相关知识。



#### pip

- **介绍及安装：**

  pip为python的包安装及管理工具，类似于linux上的包管理工具，可以对python包进行安装、查询、更新及卸载等操作。

  pip包管理器下载的python库来源于  [PyPI](https://pypi.org/) 。

  当使用的python版本 `Python 2 > = 2.7.9`或 `Python 3 > = 3.4`，或者是通过`virtualenv`创建的虚拟环境，那么pip已经自动安装，只需要升级到最新版本即可。

  ```bash
  # 判断是否已安装
  pip --version
  # 升级pip
  pip install -U pip
  ```

  >  `-U`, `--upgrade`：Upgrade all specified packages to the newest available version. The handling of dependencies depends on the upgrade-strategy used.

  如果当前环境未安装pip，则可以通过[链接](https://bootstrap.pypa.io/get-pip.py)下载`get-pip.py` 文件并运行

  ```bash
  curl  https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python get-pip.py
  ```

  > 用哪个版本的 `python` 运行安装脚本，`pip` 就被关联到哪个版本
  >
  > 一般情况下，`pip` 对应 `python2.x`，`pip3`对应`python3.x`

  

- **用法**

  - `pip --help`  查询 pip 帮助

    ```bash
    pip --help
    ```
    
  - `pip install`  安装指定包
  
    ```bash
    pip install packagename              # 安装最新版本的包
    pip install packagename==2.3.2       # 安装指定版本的包
  pip install 'packagename>=2.3.2'     # 安装版本号大于等于xxx的包
    ```
    
    > 因为网络原因，pip 默认下载源下载速度可能会比较慢，这是可指定下载源为国内镜像，如：
    >
    > *  豆瓣：https://pypi.doubanio.com/simple/
    > *  清华：https://pypi.tuna.tsinghua.edu.cn/simple
    >
    > ```bash
    > pip install -i https://pypi.doubanio.com/simple/ packagename
    > ```
    
  - `pip install --upgrade`  升级包版本
  
    ```bash
    pip install --upgrade packagename    # 将指定包升级到最新版本
    ```
  
  - `pip uninstall ` 卸载包
  
    ```bash
    pip uninstall packagename    # 卸载指定包
    ```
  
  - `pip search`  搜索包
  
    ```bash
    pip search packagename   # 搜索指定包
    ```
  ```
  
  > 搜索包名或描述中包含搜索词的 `PyPI` 包
  
  - ` pip show` 展示包相关信息
  
  ​```bash
    bajiaosang@zhengyaqi:~$ pip3 show virtualenv
    Name: virtualenv
    Version: 20.0.29
    Summary: Virtual Python Environment builder
    Home-page: https://virtualenv.pypa.io/
    Author: Bernat Gabor
    Author-email: gaborjbernat@gmail.com
    License: MIT
    Location: /home/bajiaosang/.local/lib/python3.7/site-packages
    Requires: filelock, six, distlib, importlib-metadata, appdirs
  ```
  
    > - `pip show -f packagename`  展示指定包已安装文件列表
    > - `Location` 字段显示安装模块的位置
  
  - `pip list` 展示已安装包
  
    ```bash
    pip list      # 展示已安装包列表 
    pip list -o   # 展示可升级包列表
    ```



#### virtualenv

- **介绍**

  `virtualenv` 是用于创建相互隔离的python环境的工具， `virtualenv` 中的 python 实际上与用于创建它的 python 隔离开来。
  
- **安装**

  ```bash
  sudo pip install virtualenv
  ```

- **使用**

  - **新建**虚拟环境

    ```bash
    virtualenv venv
    ```

    > - ` virtualenv dest` 将会在`/venv` 目录中创建一个文件夹，包含了Python可执行文件，以及 `pip` 库的一份拷贝，这样就能安装其他包了。虚拟环境的名字（此例中是 `venv` ）可以是任意的；若省略名字将会把文件均放在当前目录。
    >
    > - `-p` ：该参数可以指定python解释器程序路径
    >
    >   `virtualenv -p /usr/bin/python3.7 venv`

  - **激活**虚拟环境

    ```bash
    source venv/bin/avtivate
    ```

    > 激活了虚拟环境后，就可以使用`pip`安装需要用的包了，安装的内容将会放在`venv`文件夹中，与全局安装的包隔离开

  - **退出**虚拟环境

    ```bash
    deactivate
    ```

    > 该命令可以退出当前的虚拟环境

  - **删除**虚拟环境

    ```bash
    rm -f venv
    ```

    > 要删除一个虚拟环境，只要删除它的文件夹即可

- **` virtualenv: command not foun`**

  通过 `pip` 安装了 `virtualenv` 后，执行 `virtualenv` 命令时报错 ` virtualenv: command not found`。
  
  经过网上查询后，找到原因：
  
  - 安装时用户身份非root用户，安装目录是：`~/.local/lib/python3.7/site-packages`，可执行文件位于`~/.local/bin/virtualenv`；
  
  - 安装时用户身份为root用户，安装目录是：`/usr/local/lib/python3.7/dist-packages`，可执行文件位于 `/usr/local/bin/virtualenv`
  
  `virtualenv` 命令仅在第二种情况下能被识别，因为`~/.local/bin` 默认不在执行文件路径变量 `$PATH` 中，解决办法有两种：
  
  1. 将 `~/.local/bin` 路径手动添加到 `$PATH` 环境变量下
  2. 先执行 `pip uninstall virtualenv` ，然后使用 `sudo pip install virtualenv` 重新安装



#### virtualenvwrapper

- **介绍**

  `virtualenvwrapper ` 是用于`virtualenv` 工具的一系列扩展。这些扩展可用于创建和删除虚拟环境、管理开发工作流程，这使得一次处理多个项目变得更加容易，而不会在其依赖关系中引入冲突。

  > 用`virtualenv` 创建虚拟环境已经足够，试用`virtualenvwrapper` 仅仅是为了方便集中管理众多虚拟环境  (它会将创建的所有虚拟环境放在一个地方)

- **安装**

  ```bash
  sudo pip install virtualenvwrapper
  ```

  > 确保已安装 `virtualenv` 
  > 
  
- **初始化**
  
```bash
  export WORKON_HOME=$HOME/.virtualenvs
  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
  export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
  
  source /usr/local/bin/virtualenvwrapper.sh
  ```
  
  > 将以上命令添加到shell启动文件中 (如`.bashrc` `.profile` 等)
  >
  > - `WORKON_HOME`：指定虚拟环境创建路径
  > - `VIRTUALENVWRAPPER_PYTHON`：指定`virtualevwrapper` 使用的python执行器路径
  > - `VIRTUALENVWRAPPER_VIRTUALENV`：指定 `virtualenv` 可执行命令路径
  > - `source /usr/local/bin/virtualenvwrapper.sh` ：执行 `virtualenvwrapper` 启动文件
  >
  > 更改完 `.bashrc` 文件后，再次执行使其生效
  
- **使用**

  - **创建**虚拟环境

    ```bash
    mkvirtualenv venv
    ```

    > 该命令会在变量指定的 `WORKON_HOME` 目录下新建名为 `venv` 的虚拟环境

    如果想**指定python版本**，可使用`--python`  参数来指定特定的python解释器，如：

    ```bash
    mkvirtualenv --python=/usr/bin/python3.7 venv
    ```

  - 列出可用的**虚拟环境列表**

    ```bash
    workon
    ```

  - **切换**虚拟环境

    ```bash
    workon venv
    ```

  - **退出**当前虚拟环境

    ```bash
    deactivate
    ```

  - **删除**虚拟环境

    ```bash
    rmvirtualenv venv
    ```

    
