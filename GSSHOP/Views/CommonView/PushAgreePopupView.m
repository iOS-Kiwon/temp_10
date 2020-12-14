//
//  PushAgreePopupView.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 3. 9..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "PushAgreePopupView.h"
#import "AppDelegate.h"

@implementation PushAgreePopupView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    [self.btnOk setTitle:GSSLocalizedString(@"Notification_Ok") forState: UIControlStateNormal];
    [self.btnOk setTitle:GSSLocalizedString(@"Notification_Ok") forState: UIControlStateSelected];
    [self.btnNo setTitle:GSSLocalizedString(@"No_NextTime") forState: UIControlStateNormal];
    [self.btnNo setTitle:GSSLocalizedString(@"No_NextTime") forState: UIControlStateSelected];
    self.btnNoBottomMargin.constant = (IS_IPHONE_X_SERISE ? 50 : 0);
    self.btnOkBottomMargin.constant = (IS_IPHONE_X_SERISE ? 50 : 0);
    //외곽선 추가 (위 아래)
    CALayer *upperBorder = [CALayer layer];
    CALayer *bottomBorder = [CALayer layer];
    upperBorder.backgroundColor = [Mocha_Util getColor:@"dddddd"].CGColor;
    bottomBorder.backgroundColor = [Mocha_Util getColor:@"dddddd"].CGColor;
    upperBorder.frame = CGRectMake(0, 0, APPFULLWIDTH*0.35, 1.0f);
    bottomBorder.frame = CGRectMake(0, CGRectGetHeight(self.btnNo.frame)-(IS_IPHONE_X_SERISE ? 1.0f : 0), APPFULLWIDTH*0.35, 1.0f);
    [self.btnNo.layer addSublayer:upperBorder];
    [self.btnNo.layer addSublayer:bottomBorder];
}


- (IBAction)btnYes:(id)sender {
    [self removeFromSuperview];
    if(self.atarget != nil)
        [self.atarget performSelector:@selector(customAlertView:clickedButtonAtIndex:) withObject:self withObject:0];
}


- (IBAction)btnNo:(id)sender {
    [self removeFromSuperview];
    //20170727 parksegun 수신동의팝업 NO일때도 값을 저장하여 다시 노출하지 않음.
    [ApplicationDelegate FirstAppsettingWithOptinFlag:NO withResultAlert:NO];
}


@end
