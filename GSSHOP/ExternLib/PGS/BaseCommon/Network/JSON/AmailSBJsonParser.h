#import <Foundation/Foundation.h>
#import "AmailSBJsonBase.h"
@protocol AmailSBJsonParser
- (id)objectWithString:(NSString *)repr;
@end
@interface AmailSBJsonParser : AmailSBJsonBase <AmailSBJsonParser> {
@private
    const char *c;
}
@end
@interface AmailSBJsonParser (Private)
- (id)fragmentWithString:(id)repr;
@end


