### Monkey

 #### 简介

Monkey是一个命令行工具，可以在任何模拟器或真机设备上运行。

它会将伪随机用户事件流（如点击、轻触或手势）及一些系统事件发送到系统中，从而可以实现对开发的应用进行压力测试。

Monkey程序是Android程序自带的，由java语言编写，在Android文件系统中存放路径是：`system/framework/monkey.jar`。

基本操作流程如下：

1. 通过名为`monkey`的shell脚本启动`monkey.jar`程序
2. 在指定的app应用上模拟用户点击、滑动、输入等操作，以极快的速度来对设备程序进行压力测试
3. 检验程序是否会发生异常，然后通过日志进行排错



#### 用法

由于monkey运行在模拟器或设备中，所以必须从该环境中通过shell启动它。

##### 基本语法：

```shell
adb shell monkey [options] <event-count>
```

示例：

```shell
# eg: 启动应用并向其发送500个随机事件
adb shell monkey -p your.package.name -v 500
```

> 如果未指定任何option，monkey则以静默方式启动，并将事件发送到目标设备上安装的任何（及所有）软件包

##### options

monkey包含许多选项，主要分为以下四个类别：

- 基本配置选项：

  - ` <event-count>`：表示要尝试的事件数量
  - `-v` ：代表控制台log级别，`-v`越多日志越详细，最多支持三个

- 操作限制条件：

  - `-p <allowed-package-name>`：指定monkey可以访问的一个或多个软件包名称（指定多个软件包时，每个软件包对应一个`-p`选项
  - `-c <main-category>`：指定一个或多个列表，monkey讲允许系统访问其中一个指定列表中所列的activity（指定多个类别时，每个列表对应一个`-c`选项）

- 事件类型与频率：

  - `-s <seed>`：伪随机数生成器的种子值。如果使用相同的种子值重新运行monkey，它将会生成相同的时间序列

  - `--throttle <milliseconds>`：在事件之间插入固定的延迟事件

  - 事件比例调整

    - `--pct-touch <percent>`：指定轻触事件所占百分比

    - `--pct-motion <percent>`：指定动作时间所占百分比

    - `--pct-trackball <percent>`：指定轨迹球事件所占百分比

    - `--pct-nav <percent>`：指定基本导航事件所占百分比（如向上/向下/向左/向右）

    - `--pct-syskeys <percent>`：指定系统按键事件所占百分比（如主屏幕、返回、发起通话、音量控件）

    - `--pct-appswitch <percent>`：指定activity启动次数所占百分比

    - `--pct-anyevent <percent>`：调整其他类型事件所占百分比

    如果不指定事件比例，这些动作都是随机分配的，所有类型动作百分比之和为`100%`

- 调试选项

  - `--ignore-crashes`：monkey在应用奔溃或遇到任何类型的未处理异常时会停止。如果指定了此选项，monkey会继续向系统发送事件，知道计数完成为止
  - `--ignore-timeouts`：monkey在应用遇到任何类型的超时错误时会停止。如果指定了此选项，monkey会继续向系统发送事件，知道计数完成为止

#### 运行

- 设备

  必须确保设备已经打开`usb`调试功能，可用`adb devices -l`命令查看下系统是否检测到设备。

  >  可以在设备中的开发者选项—>调试—>usb调试中开启

- 运行

  执行以下命令，查看控制台日志即可

  ```shell
  adb shell monkey -p com.guokr.mobile -v -v -v 100
  ```

  



### monkeyrunner

#### 简介

`monkeyrunner` 工具提供了一个 API，用于编写从外部控制 Android 设备或模拟器的程序。

使用 `monkeyrunner`，可以编写 Python 程序来安装 Android 应用或测试软件包，运行该应用或软件包，向其发送模拟击键，截取其界面的屏幕截图，并将屏幕截图存储到工作站中。

需要注意的是，`monkeyrunner` 与上面说的 `monkey` 无关。`monkey`  直接在设备或模拟器上的 `adb` shell 中运行，并生成伪随机用户和系统事件流。相比之下，`monkeyrunner ` 通过从 API 发送特定命令和事件来从工作站控制设备和模拟器。

#### mongkeyrunner类

monkeyrunner API 包含在 `com.android.monkeyrunner` 软件包的三个模块中：

* `MonkeyRunner`：一个包含用于 monkeyrunner 程序的实用程序方法的类。

  此类提供了用于将 monkeyrunner 连接到设备或模拟器的方法。它还提供了用于为 monkeyrunner 程序创建界面以及显示内置帮助的方法。

* `MonkeyDevice`：代表设备或模拟器

  此类提供了用于安装和卸载软件包、启动 Activity 以及向应用发送键盘或轻触事件的方法，也可以使用这个类来运行测试软件包。

* `MonkeyImage`：代表屏幕截图

  此类提供了用于截屏、将位图转换为各种格式、比较两个 MonkeyImage 对象以及将图片写入文件的方法。

##### MonkeyRunner

常用方法如下：

| 返回值         | 方法                                                         | 描述                                                         |
| :------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| void           | [alert](https://developer.android.com/studio/test/monkeyrunner/MonkeyRunner#alert) (*string* message, *string* title, *string* okTitle) | 针对运行当前程序的进程显示一个提醒对话框。                   |
| *integer*      | [choice](https://developer.android.com/studio/test/monkeyrunner/MonkeyRunner#choice) (*string* message, *iterable* choices, *string* title) | 显示一个对话框，其中列出了针对运行当前程序的进程的选项。     |
| void           | [help](https://developer.android.com/studio/test/monkeyrunner/MonkeyRunner#help) (*string* format) | 使用指定格式以类似于 Python 的 `pydoc` 工具的样式显示 monkeyrunner API 引用。 |
| *string*       | [input](https://developer.android.com/studio/test/monkeyrunner/MonkeyRunner#input) (*string* message, *string* initialValue, *string* title, *string* okTitle, *string* cancelTitle) | 显示一个接受输入的对话框。                                   |
| void           | [sleep](https://developer.android.com/studio/test/monkeyrunner/MonkeyRunner#sleep) (*float* seconds) | 将当前程序暂停指定的秒数。                                   |
| `MonkeyDevice` | [waitForConnection](https://developer.android.com/studio/test/monkeyrunner/MonkeyRunner#waitForConnection) (*float* timeout, *string* deviceId) | 尝试在 `monkeyrunner` 后端与指定的设备或模拟器之间建立连接。 |

##### MonkeyDevice

此类用于控制 Android 设备或模拟器，常用方法如发送界面事件，检索信息，安装和移除应用，以及运行应用等。

可以通过下面的方法获得一个MonkeyDevice实例

```python
device = MonkeyRunner.waitForConnection()
```

| 返回值        | 方法                                                         | 描述                                                         |
| :------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| void          | [broadcastIntent](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#broadcastIntent) (*string* uri, *string* action, *string* data, *string* mimetype, *iterable* categories *dictionary* extras, *component* component, *iterable* flags) | 向此设备广播 Intent，就像 Intent 来自应用一样。              |
| void          | [drag](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#drag) (*tuple* start, *tuple* end, *float* duration, *integer* steps) | 在此设备的屏幕上模拟拖动手势（轻触、按住和移动）。           |
| void          | [installPackage](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#installPackage) (*string* path) | 安装测试包到此设备上，如果应用或测试软件包已安装，则会被替换。 |
| void          | [press](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#press) (*string* name, *dictionary* type) | 将 type 指定的按键事件发送到键码指定的按键。                 |
| void          | [removePackage](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#removePackage) (*string* package) | 从此设备中删除指定的软件包，包括其数据和缓存。               |
| void          | [startActivity](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#startActivity) (*string* uri, *string* action, *string* data, *string* mimetype, *iterable* categories *dictionary* extras, *component* component, *flags*) | 在此设备上启动一个 Activity。                                |
| `MonkeyImage` | [takeSnapshot](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#takeSnapshot)() | 捕获此设备的整个屏幕缓冲区，并生成一个 `MonkeyImage `对象，其中包含当前显示内容的屏幕截图。 |
| void          | [touch](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#touch) (*integer* x, *integer* y, *integer* type) | 将 type 指定的轻触事件发送到由 x 和 y 指定的屏幕位置。       |
| void          | [type](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#touch) (*string* message) | 将消息中包含的字符发送到此设备                               |
| void          | [wake](https://developer.android.com/studio/test/monkeyrunner/MonkeyDevice#touch) () | 唤醒此设备的屏幕。                                           |

##### MonkeyImage

可用于存储设备或模拟器屏幕截图。

可以使用 `MonkeyDevice.takeSnapshot()` 根据屏幕截图创建一个`MonkkeyImage`：

```python
device = MonkeyRunner.waitForConnection()
image = device.takeSnapshot()
```

常用方法：

| 返回值        | 方法                                                         | 备注                                                         |
| :------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| *string*      | [convertToBytes](https://developer.android.com/studio/test/monkeyrunner/MonkeyImage#convertToBytes) (*string* format) | 将当前图片转换为特定格式并以字符串形式返回该图片             |
| `MonkeyImage` | [getSubImage](https://developer.android.com/studio/test/monkeyrunner/MonkeyImage#getSubImage) (*tuple* rect) | 根据当前图片的矩形选择区创建一个新的 `MonkeyImage` 对象。    |
| *void*        | [writeToFile](https://developer.android.com/studio/test/monkeyrunner/MonkeyImage#writeToFile) (*string* path, *string* format) | 将当前图片以 `format` 指定的格式写入 `filename` 指定的文件。 |



#### 运行monkeyrunner

- 位置：monkeyrunner位置SDK目录下的`/tools`目录

- 启动方式：如果以参数的形式提供文件名，`monkeyrunner` 命令会将文件的内容作为 Python 程序运行；否则，它会启动一个交互式会话。

- 命令语法：

  ```she
  monkeyrunner -plugin <plugin-jar> <program_filename> <program_options>
  ```

  - `-plugin <plugin-jar>`：（可选）指定包含 monkeyryrunner 插件的 `.jar` 文件
  - `<program_filename>`：如果提供此参数，`monkeyrunner` 命令会将文件的内容作为 Python 程序运行。如果未提供此参数，该命令将启动交互式会话。
  - ` <program_options>`：该程序在 `<program_filename> `中的标志和参数

### 实例

创建一个python文件`test.py` ，通过以下命令启动monkeyrunner

```she
monkeyrunner  monkeyrunner Q:\projects\test_monkeyrunner\test.py
```

> 注：要指定python文件的绝对路径，否则会找不到文件报错

下面的脚本首先会获取到当前设备，并安装一个名为`app-play-debug.apk`的android包，并启动应用，对当前设备进行截屏。

```python
from com.android.monkeyrunner import MonkeyRunner

def main():
    device = MonkeyRunner.waitForConnection()
    device.installPackage(r'Q:\projects\test_monkeyrunner\app-play-debug.apk')
    package = 'com.guokr.mobile'
    activity = 'com.guokr.mobile.MainActivity'
    run_component = package + '/' +activity
    device.startActivity(component=run_component)
    image = device.takeSnapshot()
    image.writeToFile(r'Q:\projects\test_monkeyrunner\image.png', 'png')

if __name__ == '__main__':
    main()
```

效果如[视频](https://guokrapp-static.guokr.com/test_monkeyrunner.mp4)



