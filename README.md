#百度鹰眼cordova插件 cordova-baidu-yingyan

## 使用：
* 修改config.xml里的AK

```
<meta-data
  android:name="com.baidu.lbsapi.API_KEY"
  android:value="你的AK" />
```

* 在js里使用：

```
cordova.baiduyingyan.startTrace(
        function(){
          console.log('OK');
        },
        function(){
          console.log('error');
        },
        {
          entityName: 'cordova-test',
          serviceId: '118984'
        }
      )
```

## Next 
支持ios
