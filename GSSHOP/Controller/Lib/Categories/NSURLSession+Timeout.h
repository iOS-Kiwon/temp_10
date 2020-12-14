//
//  NSURLSession+Timeout.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 1..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TIMEOUT_INTERVAL_REQUEST        5
#define TIMEOUT_INTERVAL_RESPONSE       10

@interface NSURLSession (Timeout)

typedef void (^NetworkResponseResultBlock)(NSData *taskData, NSURLResponse *response, NSError *error);


+ (NSData *)sendSessionSynchronousRequest:(NSURLRequest *)request returningResponse:(__autoreleasing NSURLResponse **)responseReturn timeout:(NSTimeInterval)timeout error:(__autoreleasing NSError **)errorReturn;

+ (NSData *)sendSessionSynchronousRequest:(NSURLRequest *)request returningResponse:(__autoreleasing NSURLResponse **)responseReturn error:(__autoreleasing NSError **)errorReturn;

+ (NSData *)requestSynchronousData:(NSURLRequest *)request;
+ (NSData *)requestSynchronousDataWithURLString:(NSString *)requestString;
+ (NSDictionary *)requestSynchronousJSON:(NSURLRequest *)request;
+ (NSDictionary *)requestSynchronousJSONWithURLString:(NSString *)requestString;

+ (NSData *) getCachData :(NSString *) strURL;

// Async
+ (void)Async_sendSessionRequest:(NSURLRequest *)request timeout:(NSTimeInterval)timeout returnBlock:(NetworkResponseResultBlock) completionBlock;

@end
