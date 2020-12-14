//
//  BrandNameData.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 10. 30..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "BrandNameData.h"

@implementation BrandNameData
@synthesize brandname, brandurl;


- (id) init
{
    self = [super init];
    if(self)
    {
        self.brandname = @"0";
        self.brandurl = @"0";
        
    }
    return  self;
}

@end
