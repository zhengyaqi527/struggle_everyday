# Ubuntu下给普通用户添加管理员权限

### 背景

电脑本身是Win 10系统，下载了 `Ubuntu for windows 10` 用于Linux的学习，安装时，系统会要求输入一对用户名和密码，用于登录Ubuntu子系统，这个用户具有一定的管理功能，可有通过 `sudo su` 切换到 `root`，或者通过 `sudo`  执行 `root` 权限的操作。那如果我想新建一个用户，也想让这个用户拥有像默认用户一样的操作权限呢？

### 新建用户

- adduser

  ```bash
  sudo adduser egg
  ```

- 在提示下输入密码及其他信息，完成用户新建。此时查看该用户

  ```bash
  zhengyaqi@zhengyaqi:~$ cat /etc/passwd | grep egg
  egg:x:1003:1003:,,,:/home/egg:/bin/bash
  ```

- 此时进行`sudo` 操作

  ```bash
  egg@zhengyaqi:/home/zhengyaqi$ sudo su
  [sudo] password for bajiaosang:
  egg is not in the sudoers file.  This incident will be reported.
  ```

  

### 赋予root权限

- 先切换到有管理权限的用户，然后切换到root

  ```bash
  su zhengyaqi
  sudo su
  ```

- 查询`/etc/sudoers` 文件，可以看到当前文件不可写

  ```bash
  root@zhengyaqi:/home/zhengyaqi# ls -lh /etc/ | grep sudoers
  -r-xr----- 1 root root       782 May  6 16:26 sudoers
  ```

- 然后修改`sudoers` 文件为可写权限

  ```bash
  root@zhengyaqi:/home/zhengyaqi# chmod u+w /etc/sudoers
  root@zhengyaqi:/home/zhengyaqi# ls -lh /etc/ | grep sudoers
  -rwxr----- 1 root root       782 May  6 16:26 sudoers
  ```

- 修改`sudoers` 文件，将要修改的用户添加到其他用户后面

  ```bash
  # User privilege specification
  root    ALL=(ALL:ALL) ALL
  zhengyaqi ALL=(ALL:ALL) ALL
  egg   ALL=(ALL:ALL) ALL
  ```

- 将`sudoers` 文件去掉写权限

  ```bash
  root@zhengyaqi:/home/zhengyaqi# chmod u-w /etc/sudoers
  root@zhengyaqi:/home/zhengyaqi# ls -lh /etc/ | grep sudoers
  -r-xr----- 1 root root       806 May  9 18:35 sudoers
  ```

- 切换到` egg` 用户，进行`sudo su` 操作

  ```bash
  root@zhengyaqi:/home/zhengyaqi# su egg
  egg@zhengyaqi:/home/zhengyaqi$ sudo su
  [sudo] password for egg:
  root@zhengyaqi:/home/zhengyaqi#
  ```



### 更换默认账户

> 如果我们想更换ubuntu默认的登录账户，该如何操作呢？

```bash
ubuntu2004.exe config --default-user egg
```

更换默认登陆账户后，重新启动ubuntu进行登录，可以看到默认用户为 `egg`