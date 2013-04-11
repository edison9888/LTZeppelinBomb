## LTZeppelinBomb

LTZeppelinBomb 是以减少 AppDelegate 污染，同时简化注册 device token 和接收推送的过程为目的而写的类。


### 使用它的 Apps
* [iWeekly图历](http://itunes.apple.com/app/id488116020)
* [LOHAS 乐活杂志](http://itunes.apple.com/app/id498941101)
* --Drafffted-- 已下架
* --V2EX-- 未上架


###环境要求
因为使用了 Block，最低需要 iOS 4.0 以上 SDK。
使用了 __has_feature(objc_arc) 判断 ARC 环境，不需要设置 -fno-objc-arc。


###使用方法
因为太好用了，所以不高兴写使用方法了...
请想像 Zeppelin 战舰投放 ZeppelinBomb 的过程...
请参考 DemoAppDelegate.m


### TODO
- 加密传输字符串
- 封装处理程序升级推送的方法
- 封装处理推送参数的方法，从而实现推送跳转到某个 ViewController 并执行某一 block 的功能


###LICENSE
Copyright (C) 2013 LexTang.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.