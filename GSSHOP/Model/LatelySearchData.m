//
//  LatelySearchData.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 20..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "LatelySearchData.h"


@implementation LatelySearchData

@synthesize searchWord, schType, schTime;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.searchWord = @"";
        self.schType = @"";
        self.schTime = @"";
    }
    return self;
}
@end


