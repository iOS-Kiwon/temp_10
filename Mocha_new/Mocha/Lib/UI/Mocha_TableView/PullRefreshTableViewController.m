//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"
#import "Mocha_Define.h"
#define REFRESH_HEADER_HEIGHT 52.0f


@implementation PullRefreshTableViewController

//@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize refreshHeaderView, refreshGSSHOPCircle;

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self != nil) {
    [self setupStrings];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self != nil) {
    [self setupStrings];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self != nil) {
    [self setupStrings];
  }
  return self;
}

- (void)viewDidLoad {
    
    if(IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()){
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }else {
        
        self.wantsFullScreenLayout = YES;
    }

  [super viewDidLoad];
  [self addPullToRefreshHeader];
}

- (void)setupStrings{
 // textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
 // textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
 // textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, APPFULLWIDTH, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];

    
    
    refreshGSSHOPCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MochaResources.bundle/loadaniimg_01.png"]];
    refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                    40, 40);
    
    [refreshHeaderView addSubview:refreshGSSHOPCircle];
    /*
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;

    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MochaResources.bundle/arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;

    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
     */
    
    [self.tableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                
                refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- 40) / 2),
                                                       (floorf(REFRESH_HEADER_HEIGHT - 40) / 2),
                                                       40, 40);
                // User is scrolling above the header
              //  refreshLabel.text = self.textRelease;
               // [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else { 
                // User is scrolling somewhere within the header
               // refreshLabel.text = self.textPull;
                //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
                float i = fabs(scrollView.contentOffset.y);
                if(i>40) { i=40; }
             //   CGSize border = CGSizeMake(fabsf(offset.width) + blur, fabsf(offset.height) + blur);
                refreshGSSHOPCircle.frame = CGRectMake(floorf((APPFULLWIDTH- i) / 2), (floorf(REFRESH_HEADER_HEIGHT - i) / 2),  i, i);
               
                
            }
        }];
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
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    //[UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        //refreshLabel.text = self.textLoading;
        //refreshArrow.hidden = YES;
        //[refreshSpinner startAnimating];
    
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

        
        
  //  }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        
    } 
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
   // refreshLabel.text = self.textPull;
   // refreshArrow.hidden = NO;
   // [refreshSpinner stopAnimating];
     [refreshGSSHOPCircle stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}


@end
