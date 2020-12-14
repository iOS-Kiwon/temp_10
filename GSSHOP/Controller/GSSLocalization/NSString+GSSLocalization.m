//
//  NSString+GSSLocalization.m
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//


#import "NSString+GSSLocalization.h"

@implementation NSString (GSSLocalization)

+ (NSString *)localizedStringWithKey:(NSString *)key
                               table:(NSString *)table
                      fallbackLocale:(NSString *)fallbackLocale {
    
    
    
    // zh-Hans
    // en
    // ko
    
    // This empty string has a space in it, so as not to be treated as equivalent to nil
    // by the NSBundle method
    NSString *missing = @" ";
    
    //치명 강제로 default 언어 지정해요
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"ko" ofType:@"lproj"];
    NSString *string = [[NSBundle bundleWithPath:defaultPath]  localizedStringForKey:key value:missing table:table];
    
    //시스템만 바라봐요.
    //NSString *string = [[NSBundle mainBundle] localizedStringForKey:key value:missing table:table];
    
    
    // If a localized string can't be found for the desired language, fall back to "en"
    if ([string isEqualToString:missing]) {
        NSString *fallbackPath = [[NSBundle mainBundle] pathForResource:fallbackLocale ofType:@"lproj"];
        string = [[NSBundle bundleWithPath:fallbackPath] localizedStringForKey:key value:key table:table];
    }
    
    // If there is not result for "en", return the key as a last resort, instead of nil
    return string ?: key;
}

@end
