//
//  NSURLConnection+Timeout.h
//  Mocha
//
//  Created by KIM HOECHEON on 13. 8. 20..
//
//

#import <Foundation/Foundation.h>


@interface NSURLConnection (Timeout)

+ (dispatch_queue_t)timeoutLockQueue;
+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response timeout:(NSTimeInterval)timeout error:(NSError **)error;
@end
