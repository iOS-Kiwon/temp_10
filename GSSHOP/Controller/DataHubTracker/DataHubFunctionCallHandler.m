//
//  DataHubFunctionCallHandler.m
//  GSSHOP
//
//  Created by gsshop on 2015. 6. 11..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <GoogleTagManager/GoogleTagManager.h>
#import "DataHubFunctionCallHandler.h"

// Corresponds to the function name field in the Google Tag Manager interface.
NSString *const kMyTagFunctionName = @"datahubTag";

@implementation DataHubFunctionCallHandler


- (void)execute:(NSString *)functionName parameters:(NSDictionary *)parameters {
    NSLog(@" %@ === %@",functionName, parameters);
}
- (NSObject *)executeWithParameters:(NSDictionary *)parameters {
    return nil;
}

@end
