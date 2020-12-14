//
//  SplashViewController.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 21..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SplashViewController : UIViewController {
	UIImageView *splashImageView;
    UIImageView   *_activityIndicator;
}

@property(nonatomic, strong) UIImageView *_activityIndicator;
@property(nonatomic,retain) NSTimer *timer;

- (void) finishedFading;
- (void) finishedLoading;
- (void)showUserInfo:(NSString *)name grade:(NSString *) vip;
@end

