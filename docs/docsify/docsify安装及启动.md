# docsify安装及启动

### 介绍

- A magical documentation site generator.

  docsify可以为你即时生成文档网站。与GitBook不同的是，它不会生成静态html文件，相反，它可以智能地加载和解析您的Markdown文件并将其显示为网站。 

- 特性

  - 不会静态生成html文件
  - 简单轻量（gzipped格式压缩后21kb）
  - 智能全文搜索插件
  - 主题多样
  - 提供有用的API
  - 支持emoji
  - 适应IE11（笑）
  - 支持服务端渲染

### 安装及启动

#### 安装

- npm

  docsify的安装依赖npm，[安装详见](https://www.npmjs.cn/getting-started/installing-node/)

- 安装 `docsify-cli`

  ```bash
  npm i docsify-cli -g
  ```

  > 推荐全局安装 `docsify-cli`，这样可以在本地初始化和预览文档网站

- 初始化

  使用 `init` 命令去生成文档

  - 语法

    ```bash
    docsify init <path> [--local false] [--theme vue]
    ```

    > - `<path> ` ：不指定默认为当前路径，使用相对路径，如`./docs`
    > - `--local`：可简写为 `-l`，将`docsify`文件复制到`docs`路径，使用`unpkg.com`作为CDN，默认为`false`，要将此选项显示设置为`false`，请使用`--no-local`
    > - `--theme`：可简写为`-t`，默认值`vue`，其他值`buble` 、`dark`、 `pure`

  - 例如

    ```bash
    docsify init docsify_project
    ```

- 文件

  完成init后，在刚刚初始化的目录中可以看到以下几个文件

  - `index.html`  入口文件
  - `README.md`  首页
  - `.nojekyll`  防止`github pages`忽略以 `_` 开头的文件

#### 启动及预览

- `docsify serve`  运行本地服务

  ```bash
  docsify serve <path> [--open false] [--port 3000]
  ```

  > - `--open`：用默认浏览器打开文档，默认是`false`，可以简写为`-o`，如果要显示的设置为`false`，则需要用`--no-open`来设置
  > - `--port`: 指定端口号，默认为`3000`，可简写为`-p`

- 本地运行服务，并通过浏览器`http://localhost:3000`来预览文档

  ```bash
  docsify serve docsify_project
  ```

  

