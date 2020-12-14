//
//  NSURLSession+Timeout.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 1..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "NSURLSession+Timeout.h"




@implementation NSURLSession (Timeout)

+ (NSData *)sendSessionSynchronousRequest:(NSURLRequest *)request returningResponse:(__autoreleasing NSURLResponse **)responseReturn timeout:(NSTimeInterval)timeout error:(__autoreleasing NSError **)errorReturn{
    
    __block NSData *data = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = timeout;
    config.timeoutIntervalForResource = timeout;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        if (!data) {
//            NSLog(@"%@", error);
        }
        
        *errorReturn = error;
        *responseReturn = response;
        
        dispatch_semaphore_signal(semaphore);
        
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return data;
}

+ (NSData *)sendSessionSynchronousRequest:(NSURLRequest *)request returningResponse:(__autoreleasing NSURLResponse **)responseReturn error:(__autoreleasing NSError **)errorReturn{
    __block NSData *data = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        if (!data) {
            //NSLog(@"%@", error);
        }
        
        *errorReturn = error;
        *responseReturn = response;
        
        dispatch_semaphore_signal(semaphore);
        
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return data;
}

+ (NSData *)requestSynchronousData:(NSURLRequest *)request
{
    __block NSData *data = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        if (!data) {
            NSLog(@"%@", error);
        }
        dispatch_semaphore_signal(semaphore);
        
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return data;
}

+ (NSData *)requestSynchronousDataWithURLString:(NSString *)requestString
{
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return [self requestSynchronousData:request];
}

+ (NSDictionary *)requestSynchronousJSON:(NSURLRequest *)request
{
    NSData *data = [self requestSynchronousData:request];
    NSError *e = nil;
    if(NCO(data)) {
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
        return jsonData;
    }
    else {
        return nil;
    }
}

+ (NSDictionary *)requestSynchronousJSONWithURLString:(NSString *)requestString
{
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:50];
    theRequest.HTTPMethod = @"GET";
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return [self requestSynchronousJSON:theRequest];
}


+ (NSData *) getCachData :(NSString *) strURL
{
    NSData *retData;
    
    
    return retData;
}


///
#pragma mark -
#pragma mark ASYNC
+ (void)Async_sendSessionRequest:(NSURLRequest *)request timeout:(NSTimeInterval)timeout returnBlock:(NetworkResponseResultBlock) completionBlock{
    
    
   
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    if(timeout <= 0)
    {
        config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
        config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    }
    else
    {
        config.timeoutIntervalForRequest = timeout;
        config.timeoutIntervalForResource = timeout;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        completionBlock(taskData, response, error);
    }];
    [dataTask resume];
    
    
    
}

@end
