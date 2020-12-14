//
//  InfoCommLawPopupView.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 3. 6..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "InfoCommLawPopupView.h"
#import "AppDelegate.h"

@implementation InfoCommLawPopupView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    [self.btnOk setTitle:GSSLocalizedString(@"Infomation_Confrm") forState: UIControlStateNormal];
    [self.btnOk setTitle:GSSLocalizedString(@"Notification_Ok") forState: UIControlStateSelected];
    self.btnOkBottomMargin.constant = (IS_IPHONE_X_SERISE ? 50 : 0);
}


- (IBAction)oOk:(id)sender {
    [self removeFromSuperview];
    [ApplicationDelegate infoCommLawConfirmSend];
}
@end
