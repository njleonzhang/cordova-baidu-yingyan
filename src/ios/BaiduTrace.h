#import <Cordova/CDVPlugin.h>
#import <BaiduTraceSDK/BaiduTraceSDK-Swift.h>

@interface BaiduTrace : CDVPlugin <ApplicationServiceDelegate, ApplicationEntityDelegate, ApplicationTrackDelegate>

- (void)startTrace:(CDVInvokedUrlCommand*)command;
- (void)stopTrace:(CDVInvokedUrlCommand*)command;

@end
