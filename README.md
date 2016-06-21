#百度鹰眼cordova插件 cordova-baidu-yingyan (demo版)

* js代码示例：

```
      cordova.baiduyingyan.setInterval(2, 10).then(function() {
          console.log('setInterval OK');
      });

      cordova.baiduyingyan.setLocationMode(0).then(function(){
        console.log('setLocationMode OK');
      });

      cordova.baiduyingyan.setProtocolType(0).then(function(){
        console.log('setProtocolType OK');
      });

      cordova.baiduyingyan.startTrace(
        {
          entityName: 'cordova-test',
          serviceId: '118984',
          customAttr: {
            'type': '系统回传'
          }
        }
      ).then(function() {
        console.log('leon', '开始')
        alert('开始收集')
      }, function(error) {
        alert('收集失败' + error);
      })
    }
```

# 使用
下载本plugin，copy到cordova工程的plugins目录下

## 对于android工程需要在config.xml里添加下面的配置来配置您的AK：

```
config.xml:

  <platform name="android">
    <config-file target="AndroidManifest.xml" parent="./application">
      <meta-data
        android:name="com.baidu.lbsapi.API_KEY"
        android:value="你的AK" />
    </config-file>
  </platform>
```

## 对于ios工程
* config.xml里添加如下代码，配置AK和Mcode:
```
  <preference name="BaiduTraceIOSAK" value="rp70coMHPMmpi6QI9r7n2rNGL2eXWel3" />
  <preference name="BaiduTraceIOSMCode" value="com.test.test" />
```
* 然后做cordova platform add ios
* 用xcode打开生成的ios工程
然后在general选项卡中，找到Embedded Binaries这一项，添加百度的SDK framework。

# Next
目前只是演示版本，还需要完善。
需要提供更多功能
将目前还要手动更改的事情自动化。
让这个插件，安装即用。
