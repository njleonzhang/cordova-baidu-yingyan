#百度鹰眼cordova插件 cordova-baidu-yingyan

* js代码示例：

```
      cordova.baiduyingyan.setInterval(2, 10).then(function() {
          console.log('setInterval OK');
      });
      
      // Android only
      cordova.baiduyingyan.setLocationMode(0).then(function(){
        console.log('setLocationMode OK');
      });
      
      // Android only
      cordova.baiduyingyan.setProtocolType(0).then(function(){
        console.log('setProtocolType OK');
      });

      cordova.baiduyingyan.startTrace(
        {
          entityName: 'cordova-test',
          serviceId: '118984',
          customAttr: {
            'type': 'type'    // 自定义属性里不能有中文，否则百度ios SDK导致App会crash。
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

# 下载安装
`cordova plugin add cordova-baidu-yingya`

# 配置
## android

需要在config.xml里添加下面的配置来配置您的AK：

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

## ios
* config.xml里添加如下代码，配置AK和Mcode:
```
  <preference name="BaiduTraceIOSAK" value="rp70coMHPMmpi6QI9r7n2rNGL2eXWel3" />
  <preference name="BaiduTraceIOSMCode" value="com.test.test" />
```
百度的SDK framework的Embedded现在可以自动完成。

# Next
提供更多接口
