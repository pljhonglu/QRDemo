QRDemo
======

二维码(ZXing+libqrencode)

##### 关于ZXing库，二维码移植的使用

* 把zxing目录整个移动到iOS项目的目录下（不是拖到工程里），把ZXingWidget.xcodeproj文件（只有这一个单一文件）拖进工程内

* 点击build phases tab，然后增加 Target Dependencies 和 Link binary（建立ZXing项目与自己工程的联系）加入以下框架:AVFoundation、Audio Toolbox、CoreVideo、CoreMedia、libiconv、AddressBook、AddressBookUI

* 添加完Target Dependencies和 Link binary以后，在点选link binary libZXingWidget.a会出现，点选添加

* 最后在设置中增加header Search path新版本中添加如下路径即可，不需要在进行设置了./zxing/iphone/ZXingWidget/Classes/**  ./zxing/cpp/core/src

做完以上，就可以编译通过了
有可能找不到iOStrarm头文件，通过改变mm和改变LLVM修改消除

**注意的问题**

* 一个是找不到 头文件。解决方法：把用到ZXing的源文件扩展名由.m改成.mm。

* 报错：Undefined symbols for architecture armv7s，
	* 解决方法: 把ZXingWidget的一个build target参数：”Build Active Architecture Only” 修改成 “NO”.

* 增加生成二维码的方法：同样添加对象QR进入工程，添加。a文件进入 编译如果出错，请查看是否为。mm文件

* zxing 库由于 c++ 标准不同导致出现连接错误
	* 解决办法：LLVM 5.0 languge - c++ 前两项，选择 conpiler default

##### 扫描二维码得到的 pointArray 内容的说明
横向图片  x 坐标 y 坐标,打印的是二维码边缘处几个黑方块的坐标，有几个打印几个

图片正方只有三个点，左下，左上，右上

图片可能不是正放的

第一个点是把图片正放后左下点

第二个点            左上

第三点              右上

```
2013-11-14 21:39:28.654 玩转二维码[14869:70b] (
    "NSPoint: {239, 227}",右下
    "NSPoint: {108.5, 238.5}",左下
    "NSPoint: {101.5, 108.5}",左上
    "NSPoint: {219, 120.5}" 右上
)
2013-11-14 22:19:05.114 玩转二维码[14982:70b] (
    "NSPoint: {180.5, 291.5}",左下
    "NSPoint: {180.5, 136.5}",左上
    "NSPoint: {338.5, 136.5}"右上
)
```