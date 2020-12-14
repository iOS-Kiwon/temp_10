//
//  CellSubInfoData.m
//  GSSHOP
//
//  Created by gsshop on 2015. 4. 30..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "CellSubInfoData.h"

@implementation CellSubInfoData

@synthesize CellViewType, BCArr;

- (id)init
{
    self = [super init];
    if(self)
    {
        //D, C, O
        self.CellViewType = @"D";
        self.BCArr = nil;
    }
    return self;
}
@end


