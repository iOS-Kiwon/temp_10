//
//  DrawView.m
//  GSSHOP
//
//  Created by uinnetworks on 11. 7. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//선그리기 
#import "DrawView.h"


@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Get the current context
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    // Set up the stroke and fill characteristics
    
    CGContextSetLineWidth(context, 3.0f);
    
    CGFloat gray[4] = {227.0f/255.0f, 227.0f/255.0f, 227.0f/255.0f, 1.0f};
    
    CGContextSetStrokeColor(context, gray);
    
    CGFloat red[4] = {0.75f, 0.25f, 0.25f, 1.0f};
    
    CGContextSetFillColor(context, red);
    
    // Draw a line between the two location points
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    
    CGContextAddLineToPoint(context, rect.size.width,rect.size.height);
    
    CGContextStrokePath(context);
}



@end
