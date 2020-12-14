#import <Foundation/Foundation.h>
@interface AT_Base64 : NSObject 
+ (void) initialize;
+ (NSString*) encode:(NSData*) rawBytes;
+ (NSData*) decode:(NSString*) string;
+ (NSString *) decodeAsString:(NSString *) string;
+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
@end