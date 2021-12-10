#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"


@interface RCT_EXTERN_MODULE(ReactNativeBrotherPrinters, NSObject)


RCT_EXTERN_METHOD(discoverPrinters: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(printImage: (NSString *)device uri:(NSString *)printURI deviceClass:(NSString *)model pageSize:(NSString *)pageWidth)
RCT_EXTERN_METHOD(testPrint: (NSString *)device deviceClass:(NSString *)model pageSize:(NSString *)pageWidth)




@end
