#import <Foundation/Foundation.h>
@interface NSData (NSDataExtension)
- (NSData *) gzipInflate;
- (NSData *) gzipDeflate;
@end
