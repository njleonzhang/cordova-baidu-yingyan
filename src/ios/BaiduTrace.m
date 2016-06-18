#import "BaiduTrace.h"
#import <Cordova/CDVPluginResult.h>

@implementation BaiduTrace


- (void)startTrace:(CDVInvokedUrlCommand*)command
{
    BTRACE * traceInstance = NULL;
    int const serviceId = 118984; //此处填写在鹰眼管理后台创建的服务的ID
    NSString *const AK = @"rp70coMHPMmpi6QI9r7n2rNGL2eXWel3";//此处填写您在API控制台申请得到的ak，该ak必须为iOS类型的ak
    NSString *const MCODE = @"com.test.test";//此处填写您申请iOS类型ak时填写的安全码
    NSString *const entityName = @"cordova-ios";

    traceInstance = [[BTRACE alloc] initWithAk: AK mcode: MCODE serviceId: serviceId entityName: entityName operationMode: 2];

    [traceInstance setInterval:5 packInterval:30];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[BTRACEAction shared] startTrace:self trace:traceInstance];
    });
}

- (void)stopTrace:(CDVInvokedUrlCommand*)command
{

}

- (NSDictionary*)trackAttr {
    NSMutableDictionary *glossary = [NSMutableDictionary dictionary];
    [glossary setObject: @"col1" forKey: @"v1"];
    [glossary setObject: @"col2" forKey: @"v2"];
    return glossary;
}

#pragma mark - Trace服务相关的回调方法

- (void)onStartTrace:(NSInteger)errNo errMsg:(NSString *)errMsg {
    NSLog(@"startTrace: %@", errMsg);
    // NSString* no = [NSString stringWithFormat:@"%ld",(long)errNo];
}

- (void)onStopTrace:(NSInteger)errNo errMsg:(NSString *)errMsg {
    NSLog(@"stopTrace: %@", errMsg);
}

- (void)onPushTrace:(uint8_t)msgType msgContent:(NSString *)msgContent {
    NSLog(@"收到推送消息: 类型[%d] 内容[%@]", msgType, msgContent);
}

@end
