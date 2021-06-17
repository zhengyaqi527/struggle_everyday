# Homebrew Services

### 用途

使用macOS的守护进程`launchctl`来管理后台服务

> `launchctl` 相关内容参见[Mac服务管理 – launchd、launchctl、LaunchAgent、LaunchDaemon、brew services详解](https://www.xiebruce.top/983.html)

执行命令时，如果加了 `sudo` 参数，那么会操作`/Library/LaunchDaemons`目录下的服务，否则会操作  `~/Library/LaunchAgents`  目录下的服务。

- [`sudo`] `brew services` [`list`]

  List all managed services for the current user (or root).

- [`sudo`] `brew services run` (*`formula`*|`--all`)
  Run the service *`formula`* without registering to launch at login (or boot).

- [`sudo`] `brew services start` (*`formula`*|`--all`)
Start the service *`formula`* immediately and register it to launch at login (or boot).

- [`sudo`] `brew services stop` (*`formula`*|`--all`)
Stop the service *`formula`* immediately and unregister it from launching at login (or boot).

- [`sudo`] `brew services restart` (*`formula`*|`--all`)
Stop (if necessary) and start the service *`formula`* immediately and register it to launch at login (or boot).

- [`sudo`] `brew services cleanup`
Remove all unused services.
