#import <Foundation/Foundation.h>
#import "AT_SEED_KISA.h"
@interface AT_Seed : NSObject
+(NSData *) encryptForBabpi:(NSData *)argInputData userKey:(NSString *)argUserKey;
+(NSData *) decryptForBabpi:(NSData *)argInputData userKey:(NSString *)argUserKey;
@end
