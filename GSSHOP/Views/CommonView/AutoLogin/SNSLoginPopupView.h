//
//  SNSLoginPopupView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 3. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MOCHA/TTTAttributedLabel.h>
#import "AutoLoginViewController.h"

@interface SNSLoginPopupView : UIView {
    
    NSDictionary *dicViewInfo;
    
    IBOutlet UIImageView *imgTopConfirm;
    IBOutlet UILabel *lblTopTitle;
    
    IBOutlet UIView *viewPopupContents;
    
    IBOutlet UIView *viewEmailType;
    IBOutlet TTTAttributedLabel *lblEmailType;
    
    IBOutlet UIView *viewTelType;
    IBOutlet UILabel *lblTelType;
    IBOutlet UILabel *lblTelTypeButtonTitle;
    IBOutlet UIView *viewBtnTel;
    
    IBOutlet UIView *viewOauthType;
    IBOutlet UILabel *lblOauthType01;
    IBOutlet UILabel *lblOauthType02;
    IBOutlet UILabel *lblOauthType03;
    
    IBOutlet UIView *viewButtons;
    IBOutlet UIButton *btnLeft;
    IBOutlet UIButton *btnRight;
    IBOutlet UIButton *btnTel;
    
    IBOutlet NSLayoutConstraint *lconstPopupViewHeight;
    IBOutlet NSLayoutConstraint *lconstTopTitleLabelHeight;
    IBOutlet NSLayoutConstraint *lconstEmailLabelHeight;
    IBOutlet NSLayoutConstraint *lconstTelLabelHeight;
    IBOutlet NSLayoutConstraint *lconstOauthLabel01Height;
    IBOutlet NSLayoutConstraint *lconstOauthLabel02Height;
    IBOutlet NSLayoutConstraint *lconstOauthLabel03Height;
    IBOutlet NSLayoutConstraint *lconstOauthViewHeight;
}
@property (nonatomic,weak) id delegate;
@property (nonatomic,strong) NSString *strNowSNS;;

-(void)setViewInfoNDrawData:(NSDictionary*)dicToSet;
-(IBAction)onBtnClose:(id)sender;

@end
