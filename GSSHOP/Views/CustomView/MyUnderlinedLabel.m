//
//  MyUnderlinedLabel.m
//  ditto
//
//  Created by Jin Yun sang on 2014. 7. 22..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "MyUnderlinedLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyUnderlinedLabel
@synthesize underlineOffset;
@synthesize underlineHeight;
@synthesize underlineStart;
@synthesize underlineEnd;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Get bounds
    CGRect f = self.bounds;
    
       
    CGFloat yOff = f.origin.y + f.size.height + underlineOffset;
    
    // Calculate text width
    NSDictionary *fontWithAttributes = @{NSFontAttributeName:self.font};
    CGSize tWidth = [self.text sizeWithAttributes:fontWithAttributes];
    
    // Draw underline
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(con, self.textColor.CGColor);
    CGContextSetLineWidth(con, underlineHeight);
    CGContextMoveToPoint(con, f.origin.x + underlineStart , yOff);
    CGContextAddLineToPoint(con, f.origin.x + tWidth.width +underlineEnd, yOff);
    CGContextStrokePath(con);
}


@end
