#import <Foundation/Foundation.h>
@interface AppPushSecureDataUtil : NSObject
+ (NSString *)enCipherStr:(NSString *)argStr
                      key:(NSString *)argKey
            withUrlEncode:(BOOL)argIsEncode;
+ (NSString *)deCipherParameter:(NSData *)argResponseData
                            key:(NSString *)argKey
                          islog:(BOOL)argIsLog;
+ (NSString *)urlEncodeString:(NSString *)argStr;
+ (NSString *)urlDecodeString:(NSString *)argStr;
@end