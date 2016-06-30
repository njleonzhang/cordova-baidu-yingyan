#import "BaiduTrace.h"
#import <Cordova/CDVPluginResult.h>

@implementation BaiduTrace

- (void)pluginInitialize
{
    _AK = [self.commandDelegate.settings objectForKey: [@"BaiduTraceIOSAK" lowercaseString]];
    _MCode = [self.commandDelegate.settings objectForKey: [@"BaiduTraceIOSMCode" lowercaseString]];

    NSLog(@"_AK: %@, _Mcode %@", _AK, _MCode);
}

- (void)initResult:(CDVPluginResult*)result status:(CDVCommandStatus)status
{
    result = [CDVPluginResult resultWithStatus:status];
    [result setKeepCallbackAsBool:YES];
}

- (void)initResult:(CDVPluginResult*)result status:(CDVCommandStatus)status msg:(NSString*)msg {
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:msg];
    [result setKeepCallbackAsBool:YES];
}

- (void)startTrace:(CDVInvokedUrlCommand*)command
{
    startTraceCallbackId = command.callbackId;

    NSMutableDictionary *options = [command argumentAtIndex:0];
    _customAttr = [options objectForKey:@"customAttr"];

    NSLog(@"%@", [_customAttr objectForKey:@"type"]);

    long long serviceId = [[options objectForKey:@"serviceId"] longLongValue];
    NSString* entityName = [options objectForKey:@"entityName"];


    NSLog(@"%lldd %@", serviceId, entityName);

    _traceInstance = [[BTRACE alloc] initWithAk: _AK mcode: _MCode serviceId: serviceId entityName: entityName operationMode: 2];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[BTRACEAction shared] startTrace:self trace:_traceInstance];
    });
}

- (void)stopTrace:(CDVInvokedUrlCommand*)command
{
    NSLog(@"%@", @"stopTrace");
    stopTraceCallbackId = command.callbackId;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[BTRACEAction shared] stopTrace:self trace:_traceInstance];
    });
}

-(void)setInterval:(CDVInvokedUrlCommand *)command
{
    NSMutableDictionary *options = [command argumentAtIndex:0];
    int32_t gatherInterval = [[options objectForKey:@"gatherInterval"] floatValue];
    int32_t packInterval = [[options objectForKey:@"packInterval"] floatValue];

    NSLog(@"%d %d", gatherInterval, packInterval);
    [_traceInstance setInterval:gatherInterval packInterval:packInterval];
}

-(void)setLocationMode:(CDVInvokedUrlCommand *)command
{
    NSLog(@"IOS SDK 不支持 setLocationMode");
}

-(void)setProtocolType:(CDVInvokedUrlCommand *)command
{
    NSLog(@"IOS SDK 不支持 setProtocolType");
}

 - (NSDictionary*)trackAttr
 {
     NSMutableDictionary *glossary = [NSMutableDictionary dictionary];
     NSString *key, *value;

     NSEnumerator * enumeratorKey = [_customAttr keyEnumerator];
     for (NSObject *object in enumeratorKey) {
         key = (NSString *)object;
         // 下面这句支持自定义属性的值为中文，但是会向server发送encoding之后的值。
         // 还是不支持中文了。
         // value = [[_customAttr objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         value = [_customAttr objectForKey:key];

         [glossary setObject:value forKey: key];
     }

     return glossary;
 }

#pragma mark - Trace服务相关的回调方法

- (void)onStartTrace:(NSInteger)errNo errMsg:(NSString *)errMsg
{
    NSLog(@"startTrace: %ld, %@", (long)errNo, errMsg);
    if(errNo == 0) {
        startTraceResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:errMsg];
    } else {
        startTraceResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errMsg];
    }
    [self.commandDelegate sendPluginResult:startTraceResult callbackId:startTraceCallbackId];
}

- (void)onStopTrace:(NSInteger)errNo errMsg:(NSString *)errMsg
{
    NSLog(@"onStopTrace: %ld, %@", (long)errNo, errMsg);
    if(errNo == 0) {
        stopTraceResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:errMsg];
    } else {
        stopTraceResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errMsg];
    }
    [self.commandDelegate sendPluginResult:stopTraceResult callbackId:stopTraceCallbackId];
}

// 没有用到, 但是必须实现
- (void)onPushTrace:(uint8_t)msgType msgContent:(NSString *)msgContent
{
    NSLog(@"收到推送消息: 类型[%d] 内容[%@]", msgType, msgContent);
}

@end
