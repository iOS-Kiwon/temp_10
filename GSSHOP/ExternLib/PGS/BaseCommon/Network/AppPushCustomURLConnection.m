#import <UIKit/UIKit.h>
#import "AppPushCustomURLConnection.h"
#import "AppPushNetworkAPI.h"
#define HTTP_REQUEST_TIMEOUT        30
@implementation AppPushCustomURLConnection
@synthesize _tag;
@synthesize timer;
@synthesize object;
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSString*)tag object:(id)argObject {
    self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
    @try {
        if (self) self._tag = tag;
        self.object = argObject;
        SEL sel = @selector(customCancel);
        NSMethodSignature* sig = [self methodSignatureForSelector:sel];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:self];[invocation setSelector:sel];
        self.timer = [NSTimer timerWithTimeInterval:HTTP_REQUEST_TIMEOUT invocation:invocation repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    } @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushCustomURLConnection initWithRequest : %@", exception);
    }return self;
}
- (void)customCancel {
    @try {
        NSLog(@"PMS Network fail : %@",_tag);
        //NSLog(@"PMS N Result Data is : Custom Cancel");
        //NSLog(@"PMS N =========== Network done ===========");
        [[NSNotificationCenter defaultCenter] postNotificationName:_tag object:object userInfo:nil];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[AppPushNetworkAPI sharedNetworkAPI] minusQueue];
        [self.timer invalidate];
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushCustomURLConnection customCancel : %@", exception);
    }
    @finally {
        [super cancel];
    }
}

@end