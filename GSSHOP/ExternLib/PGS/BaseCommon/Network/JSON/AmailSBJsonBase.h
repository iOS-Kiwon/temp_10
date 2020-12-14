#import <Foundation/Foundation.h>
extern NSString * AmailSBJSONErrorDomain;


@interface AmailSBJsonBase : NSObject {
    NSMutableArray *errorTrace;

@protected
    NSUInteger depth, maxDepth;
}
@property NSUInteger maxDepth;
@property(copy,readonly) NSArray* errorTrace;
- (void)addErrorWithCode:(NSUInteger)code description:(NSString*)str;
- (void)clearErrorTrace;
@end
