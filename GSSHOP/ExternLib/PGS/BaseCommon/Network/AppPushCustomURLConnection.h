#import <Foundation/Foundation.h>
@interface AppPushCustomURLConnection : NSURLConnection {
    NSString *_tag;
    NSTimer * timer;
//    id object;
}
@property (nonatomic, retain) NSString *_tag;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, retain) id object;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSString*)tag object:(id)argObject;
@end
