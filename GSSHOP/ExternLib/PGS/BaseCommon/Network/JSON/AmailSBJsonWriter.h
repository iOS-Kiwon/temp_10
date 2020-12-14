#import <Foundation/Foundation.h>
#import "AmailSBJsonBase.h"
@protocol AmailSBJsonWriter
@property BOOL humanReadable;
@property BOOL sortKeys;
- (NSString*)stringWithObject:(id)value;
@end
@interface AmailSBJsonWriter : AmailSBJsonBase <AmailSBJsonWriter> {
@private
    BOOL sortKeys, humanReadable;
}
@end
@interface AmailSBJsonWriter (Private)
- (NSString*)stringWithFragment:(id)value;
@end
@interface NSObject (AmailSBProxyForJson)
- (id)proxyForJson;
@end

