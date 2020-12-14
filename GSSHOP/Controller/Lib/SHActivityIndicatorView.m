//
//  SHActivityIndicatorView.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 9. 23..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "AppDelegate.h"
#import "SHActivityIndicatorView.h"

@implementation SHActivityIndicatorView

- (id)init
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height)]))
    {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        
        self.frame = CGRectMake(0, 0, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height);
        
        gactivityIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MochaResources.bundle/loadaniimg_01.png" inBundle:nil compatibleWithTraitCollection:nil]];

        gactivityIndicator.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_01.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_02.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_03.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_04.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_05.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_06.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_07.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_08.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_09.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_10.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_11.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_12.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_13.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_14.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_15.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_16.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_17.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_18.png" inBundle:nil compatibleWithTraitCollection:nil],
                                              nil];
        
        gactivityIndicator.animationDuration = 1.0;
        [gactivityIndicator startAnimating];
        
        
        
        
        
        
        
        
        
        gactivityIndicator.frame = CGRectMake(0, 0, 50, 50);
        gactivityIndicator.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
        [self addSubview:gactivityIndicator];
        
        
    }
    
    
    return self;
}

- (void)isDownLoding {
    gactivityIndicator.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height - (70 + (IS_IPHONE_X_SERISE?34:0) ) );
}

- (void)drawRect:(CGRect)rect
{

    
    CGRect rrect =  CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-30, ([[UIScreen mainScreen] bounds].size.height/2)-30 , 60, 60);
    
    CGFloat radius = 8.8;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    
    CGContextFillPath(context);
}


- (void)startAnimating
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.superview) return;
             
        //3초로딩인디케이터
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimating) object:nil];
       
        [ApplicationDelegate.window addSubview:self];
        
        self.alpha = 1.0f;
        self.hidden = NO;
        [gactivityIndicator startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}



- (void)stopAnimating
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            
            if (!self.superview) return;
            if(self == nil) return;
            if((id)self == [NSNull null] ) return;
            
            // nami0342 - Remove animation
            self.hidden = YES;
            [gactivityIndicator stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [self removeFromSuperview];
            
        }
        
        gactivityIndicator.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    });
}



- (BOOL)isAnimating
{
    return [gactivityIndicator isAnimating];
}

@end
