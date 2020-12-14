//
//  AttachInfo.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 22..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "AttachInfo.h"
 

@implementation AttachInfo

@synthesize contentstr;
@synthesize arruploadimg;
@synthesize errorCode;
@synthesize errorMsg;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.urlreqparser = nil;
        self.contentstr = @"";
        self.arruploadimg = [[NSMutableArray alloc] init];
        self.errorCode = @"";
        self.errorMsg = @"";
    }
    return  self;
}
@end
