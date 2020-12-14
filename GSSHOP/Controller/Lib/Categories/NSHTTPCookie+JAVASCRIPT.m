//
//  NSHTTPCookie+JAVASCRIPT.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 10. 16..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "NSHTTPCookie+JAVASCRIPT.h"

@implementation NSHTTPCookie (NSHTTPCookie_JAVASCRIPT)
- (NSString *)wn_javascriptString {
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        self.name,
                        self.value,
                        self.domain,
                        self.path ?: @"/"];
    
    if (self.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    
    return string;
}
@end
