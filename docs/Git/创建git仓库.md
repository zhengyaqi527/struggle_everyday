[TOC]

#### git init

在对git仓库进行commit或者执行其他任何操作之前，需要一个实际存在的仓库。要使用Git新建一个仓库，我们将使用`git init`命令

> `init`子命令时`initialize`的简称，它将进行所有仓库初始设置。

`git init`命令会创建隐藏的`.git`目录，此目录是仓库的核心/存储中心。它存储了所有的配置文件和目录，以及所有的commit。

`.git`目录下的各项内容：

- config文件：存储了所有与项目有关的配置设置
- description文件：此文件用于gitweb项目，可以忽略
- hooks目录：放置客户端或服务器脚本，以便用来连接到git的不同生命周期时间
- info目录：包含全局排除文件
- objects目录：此目录存储所有我们提交的commit
- refs目录：此目录存储了指向commit的指针（通常是分支和标签）



#### git clone

`git clone`命令用于创建一个与现有仓库完全相同的副本

```bash
git clone <path-to-repository-to-clone>
```

> 注意：*确保终端的当前工作目录没有位于 Git 仓库中*

该命令：

- 会获取现有仓库的路径

- 默认的创建一个与被克隆的仓库名称一致的目录

- 可以提供第二个参数，作为该目录的名称

  ```bash
  git clone <path-to-repository-to-clone> <directory>
  ```

- 将在现有工作目录想创建一个新的仓库



#### git status

`git status`命令将显示仓库的当前状态

```bash
git status
```

如果是第一次使用git，该命令将：

- 告诉我们已在工作目录中被创建但git尚未开始跟踪的新文件
- git正在跟踪的已修改文件