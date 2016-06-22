#import "BaiduTrace.h"
#import <Cordova/CDVPluginResult.h>

@implementation BaiduTrace

- (void)pluginInitialize
{
    _AK = [self.commandDelegate.settings objectForKey: [@"BaiduTraceIOSAK" lowercaseString]];
    _MCode = [self.commandDelegate.settings objectForKey: [@"BaiduTraceIOSMCode" lowercaseString]];

    NSLog(@"_AK: %@, _Mcode %@", _AK, _MCode);
}

- (void)startTrace:(CDVInvokedUrlCommand*)command
{
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

     // 不能work， 我不知道为啥。。。
//     NSString *key, *value;

//     NSEnumerator * enumeratorKey = [_customAttr keyEnumerator];
//     for (NSObject *object in enumeratorKey) {
//         NSLog(@"%@", object);
//         key = [(NSString *)object lowercaseString];
//         value = [NSString stringWithFormat:@"%@", [_customAttr objectForKey:object]];
//
//         NSLog(@"%@, %@", key, value);
//         [glossary setObject:value forKey: key];
//     }

     [glossary setObject:@"123" forKey: @"type"];
     return glossary;
 }

#pragma mark - Trace服务相关的回调方法

- (void)onStartTrace:(NSInteger)errNo errMsg:(NSString *)errMsg
{
    NSLog(@"startTrace: %@", errMsg);
}

- (void)onStopTrace:(NSInteger)errNo errMsg:(NSString *)errMsg
{
    NSLog(@"stopTrace: %@", errMsg);
}

// 没有用到
- (void)onPushTrace:(uint8_t)msgType msgContent:(NSString *)msgContent
{
    NSLog(@"收到推送消息: 类型[%d] 内容[%@]", msgType, msgContent);
}

@end
