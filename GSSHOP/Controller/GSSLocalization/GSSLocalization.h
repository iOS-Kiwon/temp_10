//
//  GSSLocalization.h
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//



#import "NSString+GSSLocalization.h"

// zh-Hans
// en
// ko

#define GSSLocalizedString(key) [NSString localizedStringWithKey:key table:@"Localizable" fallbackLocale:@"ko"]

