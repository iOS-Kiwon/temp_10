//
//  CategoryData.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "CategoryData.h"

@implementation CategoryData

@synthesize next,directlink;
@synthesize groupId;
@synthesize sectName;
@synthesize cateicon;
@synthesize level, expanded, existchild;
@synthesize childarray;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.next = @"0";
        self.groupId = @"0";
        self.sectName = @"0";
        self.level = 1;
        self.expanded = NO;
        self.existchild = NO;
        self.cateicon = @"";
        self.directlink = NO;
    }
    return  self;
}

@end
