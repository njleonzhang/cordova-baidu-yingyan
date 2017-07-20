# 百度鹰眼cordova插件 cordova-baidu-yingyan

百度鹰眼是集轨迹追踪、轨迹数据存储、轨迹处理与查询的一套完整轨迹管理开放服务，通过覆盖多平台的SDK、API以及强大的云端服务，帮助开发者轻松开发人员和车辆轨迹追踪系统。
使用百度鹰眼，您可以轻松开发出一套适用于车队监控、外业人员监管、儿童防丢领域的轨迹管理产品。

[百度的鹰眼系统](http://lbsyun.baidu.com/index.php?title=yingyan)

# 下载安装
`cordova plugin add cordova-baidu-yingyan`

# 配置

## config.xml

1. 添加 `xmlns:android="http://schemas.android.com/apk/res/android"` 到config.xml`widget`tag

    否则当你编译android app时候，你可能遇到 `AAPT: Error parsing XML: unbound prefix`


2. 添加`<preference name="UseLegacySwiftLanguageVersion" value="true" />`到config.xml

    从而支持swift2.3，因为百度的SDK使用的是swift 2.3。

3. 添加`<preference name="android-targetSdkVersion" value="21" />`到config.xml

    如果不做此设置，你的app在android 6.0上运行时，可能无法主动获取权限。

## 设置ak和mcode

### android

需要在config.xml里添加下面的配置来配置您的AK：

```
config.xml:

  <platform name="android">
    <config-file target="AndroidManifest.xml" parent="./application">
      <meta-data
        android:name="com.baidu.lbsapi.API_KEY"
        android:value="你的android AK" />
    </config-file>
  </platform>
```

### ios
config.xml里添加如下代码，配置AK和Mcode:
```
  <preference name="BaiduTraceIOSAK" value="你的IOSAK" />
  <preference name="BaiduTraceIOSMCode" value="你的Mcode" />
```

# js API

* 设置打包间隔和传间隔

  ```
  cordova.baiduTrace.setInterval(gatherInterval, packInterval).then(successCb, errorCb)

    gatherInterval：打包间隔，单位：秒
    packInterval：上传间隔，单位：秒

    ios限制：
      - gatherInterval 最小为2, 最大为60秒
      - packInterval 最小为2, 最大为60秒
      - 打包周期必须比采集周期大，且必须是采集周期的整数倍

    android限制:
      - gatherInterval 最小为2秒，最大为5分钟，否则设置不成功，默认值为5s。
      - packInterval 打包时间间隔必须为采集时间间隔的整数倍，且最大不能超过5分钟，否则设置不成功，默认值为30s。
      - 受打包数据协议最多支持10个轨迹数据的限制，请尽量控制一个打包周期内的轨迹点数量在10个以内，也就是打包周期不要超过采集周期的10倍。
  ```

* 设置定位方式（只有android支持）
  ```
  cordova.baiduyingyan.setLocationMode(locationMode).then(successCb, errorCb)

    locationMode:
          * 0：高精度定位模式，GPS与网络综合定位
          * 1：低功耗定位模式，仅使用网络定位(WiFi和基站定位)
          * 2：仅使用设备(GPS)定位
  ```


* 设置上传用的协议（只有android支持）
  ```  
  cordova.baiduTrace.setProtocolType(type).then(successCb, errorCb)

    type: 获取定位的方式
        * 0：https类型
        * 1：http类型
  ```

* 开始采集
  ```
    cordova.baiduTrace.startTrace(entityName, serviceId, operationMode, customAttr)
      .then(successCb, errorCb)

      entityName: 实例名
      serviceId: 服务ID
      operationMode: 操作模式
        * 0 : 不上传位置数据，也不接收报警信息
        * 1 : 不上传位置数据，但接收报警信息
        * 2 : 上传位置数据，且接收报警信息
      customAttr： 自定义属性, 见下面的栗子
  ```

* 停止采集

  ```
    cordova.baiduTrace.stopTrace().then(successCb, errorCb)
  ```

# 栗子：

```
      cordova.baiduTrace.setInterval(2, 10).then(function() {
          console.log('setInterval OK');
      });

      cordova.baiduTrace.setLocationMode(0).then(function(){
        console.log('setLocationMode OK');
      });

      cordova.baiduTrace.setProtocolType(0).then(function(){
        console.log('setProtocolType OK');
      });

      cordova.baiduTrace.startTrace('cordova-test', '118XXX', '2',
        {
          'type': 'system',
          'workerId': 'senior'
        }).then(function () {
        // 调用成功
        console.log('leon', '开始')
        alert('开始收集')
      }, function (error) {
        // 调用
        alert('收集失败' + error);
      });

      cordova.baiduTrace.stopTrace().then(function(msg) {
        alert('停止收集成功：'+msg)
      }, function(error) {
        alert('停止收集失败：'+error)
      });
```

# 重试机制
app刚起来的时候如果调用鹰眼的这些api，可以会由于sdk还没有完全初始化导致，调用失败，所以最好给api都加入重试机制，这里是一个简单的angular版的例子：

```
angular.module('retryCall')
  .service('retryCall', function($q) {
    this.run = function(fn, ...params) {
      let defer = $q.defer()
      let retryTimes = 3
      let count = 0

      function doSafeCall() {
        fn.apply(null, params).then((value) => {
          defer.resolve(value)
        }, (error) => {
          if(count++ < 3) {
            console.log(`will retry ${fn} in 10 second`)
            window.setTimeout(() => {
              doSafeCall()
            }, 10000)
          } else {
            defer.reject()
          }
        })
      }

      doSafeCall()
      return defer.promise
    }
  })
```

调用的api的时候，这样写：

```
retryCall.run(cordova.baiduTrace.startTrace, entityName, serviceId, operationMode).then(() => {
  console.log('startTrace OK')
}, (error) => {
  console.error(`startTrace for ${cellphone} fail`, error)
})
```

# Next
提供更多接口
用swift重写ios代码
