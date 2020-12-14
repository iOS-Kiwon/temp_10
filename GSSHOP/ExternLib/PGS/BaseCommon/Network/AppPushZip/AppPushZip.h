#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface AppPushZip : NSObject
+ (NSData *) AT_gzipInflate:(NSData *)argData;
+ (NSData *)AT_gzipDeflate:(NSData *)argData;
@end
