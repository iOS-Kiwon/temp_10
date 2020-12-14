//
//  UIApplication+OpenUrl.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 7. 24..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "UIApplication+OpenUrl.h"

@implementation UIApplication (UIApplication_OpenUrl)

- (BOOL)openURL_GS:(NSURL*)url{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        
        NSLog(@"open url = %@",url);
        
        [self openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else{
        [self openURL:url];
    }
    
    return YES;
}
@end