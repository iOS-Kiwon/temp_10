//
//  CALayer+XibConfiguration.m
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 13..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end