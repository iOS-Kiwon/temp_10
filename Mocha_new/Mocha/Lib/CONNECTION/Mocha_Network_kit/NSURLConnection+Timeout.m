//
//  NSURLConnection+Timeout.m
//  Mocha
//
//  Created by KIM HOECHEON on 13. 8. 20..
//
//

#import "NSURLConnection+Timeout.h"

@implementation NSURLConnection (Timeout)

+ (dispatch_queue_t)timeoutLockQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("timeout lock queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response timeout:(NSTimeInterval)timeout error:(NSError **)error {
    // DEVNOTE: Timeout interval is quirky
    // https://devforums.apple.com/thread/25282
    //
    // The minimum timeout for NSURLConnection is 120/240 seconds, so we need this workaround
    // to get the synchronous mechanism to cancel before that fixed minimum.
    //
    // Set a min timeout of 5 seconds
    //
    timeout = MAX(1.0, timeout);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, timeout * NSEC_PER_SEC);
    
    // Use a serial queue for locking, it should be faster than a explicit lock
    dispatch_queue_t lockQueue = [self timeoutLockQueue];
    
    __block BOOL finished = NO;
    __block NSData *data = nil;
    __block NSURLResponse *internalResponse = nil;
    __block NSError *internalError = nil;
    __block dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [self sendSynchronousRequest:request returningResponse:&internalResponse error:&internalError];
       
        
        // Use the locking queue
        dispatch_sync(lockQueue, ^{
            if (sema != NULL) {
                finished = YES;
                dispatch_semaphore_signal(sema);
            } else {
                data = nil;
                internalResponse = nil;
                internalError = nil;
            }
        });
    });
    dispatch_semaphore_wait(sema, popTime);
    
    // Release the semaphore inside the locking queue
    dispatch_sync(lockQueue, ^{
        dispatch_release(sema);
        sema = NULL;
    });
    
    if (finished) {
        if (response != NULL) {
            *response = internalResponse;
        }
        if (error != NULL) {
            *error = internalError;
        }
        
        return data;
    }
    
    // If the request timed out, return an error
    if (error != NULL) {
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Request timed out", nil)
                                                             forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0x100 userInfo:infoDict];
    }
    
    return nil;
}

@end