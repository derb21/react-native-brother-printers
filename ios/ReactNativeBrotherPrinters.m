#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ReactNativeBrotherPrinters, NSObject)

RCT_EXTERN_METHOD(printImage: (NSString *)device uri:(NSString *)printURI deviceClass:(NSString *)model pageSize:(NSString *)pageWidth resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(testPrint: (NSString *)device deviceClass:(NSString *)model pageSize:(NSString *)pageWidth resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)

@end
