//
//  SectionWebView.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 17..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "SectionWebView.h"
#define REFRESH_HEADER_HEIGHT 52.0f


@implementation SectionWebView


@synthesize refreshHeaderView, refreshGSSHOPCircle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self addPullToRefreshHeader];
    }
    return self;
}


- (void)setupStrings{
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, APPFULLWIDTH, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    
    
    refreshGSSHOPCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MochaResources.bundle/loadaniimg_01.png"]];
    refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                           (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                           40, 40);
    
    [refreshHeaderView addSubview:refreshGSSHOPCircle];
    
    [self.scrollView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.scrollView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                
                refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                                       (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                                       40, 40);
                // User is scrolling above the header
            } else {
                // User is scrolling somewhere within the header
                float i = fabs(scrollView.contentOffset.y);
                if(i>40) { i=40; }
                refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- i) / 2), (floorf(REFRESH_HEADER_HEIGHT - i) / 2),  i, i);
                
                
            }
        }];
    }
    
     
    
    if((scrollView.contentOffset.y > -1) && (scrollView.contentOffset.y < 41)) {
        self.frame = CGRectMake(0, -scrollView.contentOffset.y , APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height-kMinusCenterHeight+scrollView.contentOffset.y );
    }else if(scrollView.contentOffset.y > 40)  {
        self.frame = CGRectMake(0,  -40, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height-kMinusCenterHeight+40);
    }
    else {
        
        self.frame = CGRectMake(0,  0, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height-kMinusCenterHeight);
    }
    
    
    
}


- (CABasicAnimation *) boundsAnimation:(CGRect)start : (CGRect)end : (float)duration : (int)count {
    CABasicAnimation *bounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
    bounds.fromValue = [NSValue valueWithCGRect:start];
    bounds.toValue = [NSValue valueWithCGRect:end];
    bounds.duration = duration;
    bounds.repeatCount = count;
    return bounds;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -REFRESH_HEADER_HEIGHT);
        
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    self.scrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                           (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                           40, 40);
    
    refreshGSSHOPCircle.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_01.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_02.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_03.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_04.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_05.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_06.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_07.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_08.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_09.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_10.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_11.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_12.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_13.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_14.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_15.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_16.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_17.png"],
                                           [UIImage imageNamed:@"MochaResources.bundle/loadaniimg_18.png"],
                                           nil];
    
    refreshGSSHOPCircle.animationDuration = 1.0;
    [refreshGSSHOPCircle startAnimating];
    
    
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        
        [self performSelector:@selector(stopLoadingComplete)];
    }
                     completion:^(BOOL finished) {
                         self.scrollView.contentInset = UIEdgeInsetsZero;
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    [refreshGSSHOPCircle stopAnimating];
}

- (void)refresh {
    [self reload];
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0];
}





@end
