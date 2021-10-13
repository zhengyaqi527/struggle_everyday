> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [developer.aliyun.com](https://developer.aliyun.com/article/634481)





**简介：** 

在项目开发过程中个，一般都会添加 .gitignore 文件，规则很简单，但有时会发现，规则不生效。 原因是 .gitignore 只能忽略那些原来没有被 track 的文件，如果某些文件已经被纳入了版本管理中，则修改. gitignore 是无效的。

那么解决方法就是先把本地缓存删除（改变成未 track 状态），然后再提交。

```
git rm -r --cached .

git add .

git commit -m 'update .gitignore'
```



