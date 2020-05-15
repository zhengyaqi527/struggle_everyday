# docsify使用

### 访问路径

如果你的文档结构如下：

```
.
└── docs
    ├── README.md
    ├── guide.md
    └── zh-cn
        ├── README.md
        └── guide.md
```

那么访问路由应该是：

```
docs/README.md        => http://domain.com
docs/guide.md         => http://domain.com/#/guide
docs/zh-cn/README.md  => http://domain.com/#/zh-cn/
docs/zh-cn/guide.md   => http://domain.com/#/zh-cn/guide
```



### sidebar 

#### 展示sidebar

- 创建_sidebar.md文件或指定其他文件作为sidebar来源

  ```markdown
  <!-- docs/_sidebar.md -->
  
  * [Home](/)
  * [Guide](guide.md)
  ```

- 设置`loadSidebar`

  ```javascript
  <!-- index.html -->
  
  <script>
    window.$docsify = {
    	// load from _sidebar.md
    	loadSidebar: true,
  
    	// load from summary.md
    	loadSidebar: 'summary.md',
  	};
  </script>
  <script src="//cdn.jsdelivr.net/npm/docsify/lib/docsify.min.js"></script>
  ```

  如果`loadSidebar` 为 `true` 就会从 `_sidebar.md` 中加载，否则将从指定的路径中加载，即 `summary.md`

#### Nested Sidebars

可以通过为每个文件夹添加`_sidebar.md` 来实现侧边栏仅更新导航来反映当前目录的目的。

`_sidebar.md`在每层目录中都会被加载，如果当前路径中没有 `_sidebar.md`文件，那将会从父路径中进行加载。

我们可以通过指定`alias`来避免不必要的回退

```javas
<!-- index.html -->

<script>
  window.$docsify = {
    loadSidebar: true,
    alias: {
      '/.*/_sidebar.md': '/_sidebar.md'
    }
  }
</script>
```

#### table of contents

一旦你创建了`_sidebar.md`文件，侧边栏的内容就会基于该`markdown`文件的`headers`属性自动产生。

你可以通过设置`subMaxLevel` 属性来自动生成目录

```javas
<!-- index.html -->

<script>
  window.$docsify = {
    loadSidebar: true,
    subMaxLevel: 2
  }
</script>
<script src="//cdn.jsdelivr.net/npm/docsify/lib/docsify.min.js"></script>
```

#### ignoring subheaders

设置了`subMaxLevel`后，每个`header`都会自动被加到文档的目录中。如果你想忽略每个特定的`header`，可以通过添加`{docsify-ignore}`来实现

```markdown
<!-- guide.md -->

# h1
## h2
## ignore {docsify-ignore}
this is a file for testing 'more pages'
```



