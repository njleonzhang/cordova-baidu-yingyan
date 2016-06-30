#import <Cordova/CDVPlugin.h>
#import <BaiduTraceSDK/BaiduTraceSDK-Swift.h>

@interface BaiduTrace : CDVPlugin <ApplicationServiceDelegate, ApplicationEntityDelegate, ApplicationTrackDelegate>{
    @protected
    NSString* _AK;
    NSString* _MCode;
    BTRACE * _traceInstance;
    NSMutableDictionary* _customAttr;
    NSString* startTraceCallbackId;
    CDVPluginResult* startTraceResult;
    NSString* stopTraceCallbackId;
    CDVPluginResult* stopTraceResult;
}

- (void)startTrace:(CDVInvokedUrlCommand*)command;
- (void)stopTrace:(CDVInvokedUrlCommand*)command;
- (void)setInterval:(CDVInvokedUrlCommand*)command;
- (void)setLocationMode:(CDVInvokedUrlCommand*)command;
- (void)setProtocolType:(CDVInvokedUrlCommand*)command;
@end
