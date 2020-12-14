//
//  NSString+GSSLocalization.h
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//
 

#import <Foundation/Foundation.h>

@interface NSString (GSSLocalization)

/**
 * Returns a localized string by key, searching in the provided
 * table, and falling back on the provided locale if none of the
 * preferred languages are available.
 *
 * @param key The key for the localized string.
 * @param table The table in which to search for the localized string.
 * @param fallbackLocale The locale to fall back on if no preferred languages
 * are available.
 *
 * @return A localized NSString. In the edge case where the fallback locale
 * is also missing, this will be equal to the key string.
 */
+ (NSString *)localizedStringWithKey:(NSString *)key
                               table:(NSString *)table
                      fallbackLocale:(NSString *)fallbackLocale;

@end
