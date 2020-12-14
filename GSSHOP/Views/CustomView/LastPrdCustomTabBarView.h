//
//  LastPrdCustomTabBarView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 12. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLDefine.h"
#import "AutoLoginViewController.h"

@class CustomBadge;

@interface LastPrdCustomTabBarView : UIView{
    
    
//    NSString* cart;
//    NSString* myshop;
//    NSString* order;
    
    
    NSTimer *timerAlpha;
    
    UIView *badgeMyShop;
    
    BOOL isLastPrdExist;
}

@property (nonatomic, weak)  UINavigationController  *naviCtrl;
@property (strong, nonatomic) UIView *netwarnv;
@property (strong, nonatomic) MochaNetworkOperation *currentOperation1;

@property (nonatomic, strong) IBOutlet UIView *viewTabMyShop;

@property (nonatomic, strong) IBOutlet UILabel *lblTabHome;
@property (nonatomic, strong) IBOutlet UILabel *lblTabCate;
@property (nonatomic, strong) IBOutlet UILabel *lblTabMyShop;
@property (nonatomic, strong) IBOutlet UILabel *lblTabWish;
@property (nonatomic, strong) IBOutlet UILabel *lblTabHistory;

@property (nonatomic, strong) IBOutlet UIImageView *imgTabHome;
@property (nonatomic, strong) IBOutlet UIImageView *imgTabCate;
@property (nonatomic, strong) IBOutlet UIImageView *imgTabMyShop;
@property (nonatomic, strong) IBOutlet UIImageView *imgTabWish;
@property (nonatomic, strong) IBOutlet UIImageView *imgTabHistory;

@property (nonatomic, strong) IBOutlet UIImageView *imgLastPrd;
@property (nonatomic, weak) UIButton *btnLastClickPosition;


- (IBAction)selectTabMenuSction:(id)sender;

- (void)updateBtnBG;
-(void)badgeDrawingProc:(NSNotification*) notification;

- (BOOL)netcheck;


@end
